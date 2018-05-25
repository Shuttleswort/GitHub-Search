//
//  ManagedRepository+CoreDataProperties.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/25/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//
//

import Foundation
import CoreData


extension ManagedRepository {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedRepository> {
        return NSFetchRequest<ManagedRepository>(entityName: "ManagedRepository")
    }

    @NSManaged public var detail: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var stars: Int64
    @NSManaged public var urlString: String?

}
