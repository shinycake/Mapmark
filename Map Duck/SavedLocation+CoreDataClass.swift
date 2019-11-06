//
//  SavedLocation+CoreDataClass.swift
//  Map Duck
//
//  Created by Idan Birman on 24/10/2019.
//  Copyright © 2019 Idan Birman. All rights reserved.
//
//

import Foundation
import CoreData
import Combine
import CoreLocation
import MobileCoreServices

@objc(SavedLocation)
public class SavedLocation: NSManagedObject, Codable, Identifiable {
    
    var clLocation : CLLocation {
        let lat = CLLocationDegrees(exactly: self.latitude)!
        let long = CLLocationDegrees(exactly: self.longitude)!
        return CLLocation(latitude: lat, longitude: long)
    }
    
    var titleUnderline : String {
        guard let title = self.title else {return ""}
        var res = "---"
        for _ in 0..<title.count {
            res += "-"
        }
        return res
    }

    
    var links : (apple: String, google: String, waze: String) {
        return (
            apple: "https://maps.apple.com/?ll=\(self.latitude),\(self.longitude)",
            google: "https://www.google.com/maps/@\(self.latitude),\(self.longitude),15z",
            waze: "https://www.waze.com/ul?ll=\(self.latitude)%2C\(self.longitude)&navigate=yes&zoom=15"
        )
    }
    
    var printedElapsedTime : String {
        guard let ts = self.timestamp else {
            return ""
        }
        
        let elapsedTime = Date().timeIntervalSince(ts)
        
        let hours = floor(elapsedTime / 60 / 60)
        let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
        
        let hoursText = hours > 0 ? "\(Int(hours)) hour\(hours > 1 ? "s " : " ")" : ""
        let minutesText = minutes > 0 ? "\(Int(minutes)) minute\(minutes > 1 ? "s " : " ")" : ""
        
        let res = hoursText + minutesText
        
        return res.isEmpty ? "Just now" : res + "ago"
    }
    
    var printedDescription : String {
        return """
        \(self.title ?? "Shared Location")
        \(titleUnderline)
        
        \(self.remarks ?? "")
        
        lat: \(self.latitude)
        long: \(self.longitude)
        
        Maps
        \(self.links.apple)
        
        Google Maps
        \(self.links.google)
        
        Waze
        \(self.links.waze)
        
        
        """
    }
    
    
    var printedDate : String {
        guard let ts = self.timestamp else {return "oopsie"}
        let df = DateFormatter()
        df.dateFormat = "EEEE, MMM d, yyyy"
        return df.string(from: ts)
    }
    
    var printedTime : String {
        guard let ts = self.timestamp else {return "oopsie"}
        let df = DateFormatter()
        df.dateFormat = "h:mm:ss a"
        return df.string(from: ts)
    }
    
    var tagsArray : [Tag]? {
        if let tags = tags {
            var arr = [Tag]()
            for tag in tags {
                arr.append(tag as! Tag)
            }
            return arr
        } else {
            return nil
        }
    }
    
    class func dummy() -> SavedLocation {
        let dummy =  SavedLocation(title: "Dummy Location", lat: 31.894992, long: 35.012634, remarks: "This a remark for the dummy location which is supposed to probably contain a few sentences and all that jazz")
        
        for tag in Tag.dummyArray() {
            tag.addToLocations(dummy)
        }
        
        return dummy
    }
    
     func parking() -> SavedLocation {
        self.title = "Parking Location"
        self.addToTags(Tag.named("parking"))
        Dao.sharedInstance.saveContext()
        return self
    }
    
    func satisfies(query: String) -> Bool {
        if query.isEmpty {return true}
        
        var titleContains = false
        if let title = title {
            titleContains = title.lowercased().contains(query.lowercased())
        }
        
        var remarksContain = false
        if let remarks = remarks {
            remarksContain = remarks.lowercased().contains(query.lowercased())
        }
        
        var tagsContain = false
        if let tagsArray = tagsArray {
            for tag in tagsArray {
                tagsContain = tag.name!.contains(query.lowercased())
                if tagsContain {break}
            }
        }
        
        return titleContains || remarksContain || tagsContain
        
    }
    
    func addAutoTags() {
        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        location.placemark { (placemark) in
            
            if let country = placemark.country {
                self.addToTags(Tag.named(country))
            }
            
            if let city = placemark.locality {
                self.addToTags(Tag.named(city))
            }
            
            if let postalCode = placemark.postalCode {
                self.addToTags(Tag.named(postalCode))
            }
            Dao.sharedInstance.saveContext()
            self.objectWillChange.send()
        }
    }
    
    func delete() {
        Dao.sharedInstance.persistentContainer.viewContext.delete(self)
        Dao.sharedInstance.saveContext()
    }
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    public init(title: String, lat: Double, long: Double, remarks: String? = nil){
        let context = Dao.sharedInstance.persistentContainer.viewContext
        let description = NSEntityDescription.entity(forEntityName: "SavedLocation", in: context)!
        super.init(entity: description, insertInto: context)
        
        self.id = UUID()
        self.timestamp = Date()
        
        self.title = title
        self.latitude = lat
        self.longitude = long
        self.remarks = remarks
        
        addAutoTags()
                
    }
    
    public init(location: CLLocation, title: String? = nil, remarks: String? = nil) {
        let context = Dao.sharedInstance.persistentContainer.viewContext
        let description = NSEntityDescription.entity(forEntityName: "SavedLocation", in: context)!
        super.init(entity: description, insertInto: context)
        
        self.id = UUID()
        
        self.timestamp = location.timestamp
        self.title = title
        self.latitude = Double(location.coordinate.latitude)
        self.longitude = Double(location.coordinate.longitude)
        self.remarks = remarks
        
        addAutoTags()
        
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case timestamp
        case title
        case latitude
        case longitude
        case remarks
    }
    
    required public init(from decoder: Decoder) throws {
        let context = Dao.sharedInstance.persistentContainer.viewContext
        let description = NSEntityDescription.entity(forEntityName: "SavedLocation", in: context)!
        super.init(entity: description, insertInto: context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        timestamp = try values.decode(Date.self, forKey: .timestamp)
        title = try values.decode(String.self, forKey: .title)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
        remarks = try values.decode(String.self, forKey: .remarks)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(title, forKey: .title)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(remarks, forKey: .remarks)
        
    }
    
    
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
    
    func placemark(completion: @escaping (CLPlacemark)->Void){
        CLGeocoder().reverseGeocodeLocation(self, completionHandler:
            {(placemarks, error) in
                if let error = error {
                    print("geolocation failed: \(error.localizedDescription)")
                    return
                }
                let pm = placemarks!
                if pm.count > 0 {
                    completion(pm.first!)
                }
        })
    }}




