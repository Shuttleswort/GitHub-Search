//
//  CoreDataStack.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/24/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import Foundation
import CoreData


class SearchCoreDataStack {

    let containerIdentifier: String

    lazy var managedObjectContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerIdentifier)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                print(error)
            }
        }
        return container
    }()

    required init(containerIdentifier: String) {
        self.containerIdentifier = containerIdentifier
    }



    func fetchAllRepository(completion: @escaping ([ManagedRepository]?, Error?) -> ()) {
        let request: NSFetchRequest<ManagedRepository> = NSFetchRequest(entityName: String(describing: ManagedRepository.self))
        request.sortDescriptors = [ NSSortDescriptor(key: "stars", ascending: false)]
        do {
            let repositoryArray = try managedObjectContext.fetch(request)
            completion(repositoryArray, nil)
        } catch {
            completion(nil, error)
        }
    }

    func fetchRepository(with query: String, completion: @escaping ([ManagedRepository]?, Error?) -> ()) {
        let request: NSFetchRequest<ManagedRepository> = ManagedRepository.fetchRequest()
        request.sortDescriptors = [ NSSortDescriptor(key: "stars", ascending: false)]
        request.predicate = NSPredicate(format: "name contains[c] %@", query)

        do {
            let repositoryArray = try managedObjectContext.fetch(request)
            completion(repositoryArray, nil)
        } catch {
            completion(nil, error)
        }
    }

    func createManagedRepository(_ repositoryArray: [Repository]) {
        persistentContainer.performBackgroundTask { [unowned self] context in
            repositoryArray.compactMap { $0 }.forEach {
                if !self.isExist(id: $0.id, context: context) {
                    let mo = ManagedRepository(context: context)
                    mo.fromRepository($0)
                }
            }
            self.saveContext(context)
        }
    }



    func clearAllManagedRepository() {
        self.persistentContainer.performBackgroundTask { [unowned self] context in
            let request: NSFetchRequest<ManagedRepository> = ManagedRepository.fetchRequest()
            do {
                let repositoryArray = try context.fetch(request)
                repositoryArray.forEach { context.delete($0) }
                self.saveContext(context)
            } catch {
                fatalError("clearAllManagedRepository failed")
            }
        }
    }

    private func isExist(id: Int, context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<ManagedRepository> = ManagedRepository.fetchRequest()
        request.predicate = NSPredicate(format: "id = \(id)", argumentArray: nil)
        let res = try! context.fetch(request)
        return res.count > 0 ? true : false
    }

    private func saveContext(_ context: NSManagedObjectContext) {
        do {
            guard context.hasChanges else { return }
            try context.save()

        } catch {
            fatalError("saveContext failed")
        }
    }





}
