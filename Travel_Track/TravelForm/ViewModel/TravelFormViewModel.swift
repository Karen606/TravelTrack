//
//  TravelFormViewModel.swift
//  Travel_Track
//
//  Created by Karen Khachatryan on 13.11.24.
//

import Foundation

class TravelFormViewModel {
    static let shared = TravelFormViewModel()
    @Published var travelModel = TravelModel(id: UUID())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        if travelModel.friends ?? false {
            CoreDataManager.shared.saveFriendTravel(travelModel: travelModel, completion: completion)
        } else {
            CoreDataManager.shared.saveMyTravel(travelModel: travelModel, completion: completion)
        }
    }
    
    func clear() {
        travelModel = TravelModel(id: UUID())
    }
}
