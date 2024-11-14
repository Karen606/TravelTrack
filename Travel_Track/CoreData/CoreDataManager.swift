//
//  CoreDataManager.swift
//  Travel_Track
//
//  Created by Karen Khachatryan on 13.11.24.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Travel_Track")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveMyTravel(travelModel: TravelModel, completion: @escaping (Error?) -> Void) {
        let id = travelModel.id ?? UUID()
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<MyTravel> = MyTravel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let travel: MyTravel
                
                if let existingTravel = results.first {
                    travel = existingTravel
                } else {
                    travel = MyTravel(context: backgroundContext)
                    travel.id = id
                }
                travel.name = travelModel.name
                travel.country = travelModel.country
                travel.city = travelModel.city
                travel.startDate = travelModel.startDate
                travel.endDate = travelModel.endDate
                travel.feedBack = travelModel.feedBack
                if let assessment = travelModel.assessment {
                    travel.assessment = Int32(assessment)
                }
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func saveFriendTravel(travelModel: TravelModel, completion: @escaping (Error?) -> Void) {
        let id = travelModel.id ?? UUID()
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<FriendTravel> = FriendTravel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let travel: FriendTravel
                
                if let existingTravel = results.first {
                    travel = existingTravel
                } else {
                    travel = FriendTravel(context: backgroundContext)
                    travel.id = id
                }
                travel.name = travelModel.name
                travel.country = travelModel.country
                travel.city = travelModel.city
                travel.startDate = travelModel.startDate
                travel.endDate = travelModel.endDate
                travel.feedBack = travelModel.feedBack
                if let assessment = travelModel.assessment {
                    travel.assessment = Int32(assessment)
                }
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
//    func fetchParties(completion: @escaping ([PartyModel], Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Party> = Party.fetchRequest()
//
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                var partyModels: [PartyModel] = []
//                for result in results {
//                    let partyModel = PartyModel(id: result.id, name: result.name, location: result.location, theme: result.theme, date: result.date)
//                    partyModels.append(partyModel)
//                }
//                completion(partyModels, nil)
//            } catch {
//                DispatchQueue.main.async {
//                    completion([], error)
//                }
//            }
//        }
//    }
}
