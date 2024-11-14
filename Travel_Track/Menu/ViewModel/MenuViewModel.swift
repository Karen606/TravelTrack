//
//  MenuViewModel.swift
//  Travel_Track
//
//  Created by Karen Khachatryan on 14.11.24.
//

import Foundation

class MenuViewModel {
    static let shared = MenuViewModel()
    private init() {}
    
    func fetchMyTravels(completion: @escaping ([TravelModel], Error?) -> Void) {
        CoreDataManager.shared.fetchMyTravels(completion: completion)
    }
    
    func fetchFriendTravels(completion: @escaping ([TravelModel], Error?) -> Void) {
        CoreDataManager.shared.fetchFriendTravels(completion: completion)
    }
}
