//
//  Tag+CoreDataClass.swift
//  Map Duck
//
//  Created by Idan Birman on 24/10/2019.
//  Copyright © 2019 Idan Birman. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Tag)
public class Tag: NSManagedObject, Codable, Identifiable {
    
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    private init(name: String) {
        let context = Dao.sharedInstance.persistentContainer.viewContext
        let description = NSEntityDescription.entity(forEntityName: "Tag", in: context)!
        super.init(entity: description, insertInto: context)
        
        
        self.id = UUID()
        self.name = name
                
    }
    
    class func named(_ name: String) -> Tag {
        let lowercased = name.lowercased()
        let request : NSFetchRequest<NSFetchRequestResult> = Tag.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", lowercased)
        
        do {
            let result = try Dao.sharedInstance.persistentContainer.viewContext.fetch(request)
            for tag in result as! [Tag] {
                return tag
          }
            
        } catch {
            print("Failed")
        }
        
        return Tag(name: lowercased)
    }
    
    class func dummyArray() -> [Tag] {
        var arr = [Tag]()
        arr.append(Tag.named("food"))
        arr.append(Tag.named("groovy"))
        arr.append(Tag.named("hot stuff"))
        arr.append(Tag.named("chips"))
        arr.append(Tag.named("burger"))
        arr.append(Tag.named("freedom"))
        arr.append(Tag.named("hummus"))
        arr.append(Tag.named("biking"))
        arr.append(Tag.named("hiking"))
        arr.append(Tag.named("weed"))
        
        return arr
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    required public init(from decoder: Decoder) throws {
        let context = Dao.sharedInstance.persistentContainer.viewContext
        let description = NSEntityDescription.entity(forEntityName: "Tag", in: context)!
        super.init(entity: description, insertInto: context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        
    }
    
    
    
    

}
