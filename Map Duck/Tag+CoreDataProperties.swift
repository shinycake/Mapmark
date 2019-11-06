//
//  Tag+CoreDataProperties.swift
//  Map Duck
//
//  Created by Idan Birman on 27/10/2019.
//  Copyright © 2019 Idan Birman. All rights reserved.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var locations: NSSet?

}

// MARK: Generated accessors for locations
extension Tag {

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: SavedLocation)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: SavedLocation)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSSet)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSSet)

}
