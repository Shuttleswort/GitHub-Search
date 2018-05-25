//
//  ManagedRepository+CoreDataClass.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/24/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ManagedRepository)
public class ManagedRepository: NSManagedObject {
    func toRepository() -> Repository {
        return Repository(id: Int(id), name: name ?? "", url: urlString ?? "", stars: Int(stars), description: detail)
    }

    func fromRepository(_ repository: Repository) {
        id = Int64(repository.id)
        name = repository.name
        urlString = repository.url
        stars = Int64(repository.stars)
        detail = repository.description
    }
}
