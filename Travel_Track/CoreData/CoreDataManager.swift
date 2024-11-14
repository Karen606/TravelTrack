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
    
    func fetchMyTravels(completion: @escaping ([TravelModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<MyTravel> = MyTravel.fetchRequest()

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var travelsModel: [TravelModel] = []
                for result in results {
                    let travelModel = TravelModel(id: result.id, name: result.name, country: result.country, city: result.city, startDate: result.startDate, endDate: result.endDate, friends: false, feedBack: result.feedBack, assessment: Int(result.assessment))
                    travelsModel.append(travelModel)
                }
                DispatchQueue.main.async {
                    completion(travelsModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func fetchFriendTravels(completion: @escaping ([TravelModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<FriendTravel> = FriendTravel.fetchRequest()

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var travelsModel: [TravelModel] = []
                for result in results {
                    let travelModel = TravelModel(id: result.id, name: result.name, country: result.country, city: result.city, startDate: result.startDate, endDate: result.endDate, friends: true, feedBack: result.feedBack, assessment: Int(result.assessment))
                    travelsModel.append(travelModel)
                }
                DispatchQueue.main.async {
                    completion(travelsModel, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func removeMyTravel(withId id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<MyTravel> = MyTravel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let travelToRemove = results.first {
                    backgroundContext.delete(travelToRemove)
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "CoreDataManager",
                                           code: 404,
                                           userInfo: [NSLocalizedDescriptionKey: "Travel not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func removeFriendTravel(withId id: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<FriendTravel> = FriendTravel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let travelToRemove = results.first {
                    backgroundContext.delete(travelToRemove)
                    try backgroundContext.save()
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "CoreDataManager",
                                           code: 404,
                                           userInfo: [NSLocalizedDescriptionKey: "Travel not found"]))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func addFriendTravelToMyTravels(friendTravelId: UUID, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<FriendTravel> = FriendTravel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", friendTravelId as CVarArg)
            do {
                guard let friendTravel = try backgroundContext.fetch(fetchRequest).first else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "CoreDataManager",
                                           code: 404,
                                           userInfo: [NSLocalizedDescriptionKey: "FriendTravel not found"]))
                    }
                    return
                }
                let myTravelFetchRequest: NSFetchRequest<MyTravel> = MyTravel.fetchRequest()
                myTravelFetchRequest.predicate = NSPredicate(format: "id == %@", friendTravelId as CVarArg)
                let myTravel: MyTravel
                if let existingMyTravel = try backgroundContext.fetch(myTravelFetchRequest).first {
                    myTravel = existingMyTravel
                } else {
                    myTravel = MyTravel(context: backgroundContext)
                    myTravel.id = friendTravel.id
                }
                myTravel.name = friendTravel.name
                myTravel.country = friendTravel.country
                myTravel.city = friendTravel.city
                myTravel.startDate = friendTravel.startDate
                myTravel.endDate = friendTravel.endDate
                myTravel.feedBack = friendTravel.feedBack
                myTravel.assessment = friendTravel.assessment                
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

}
