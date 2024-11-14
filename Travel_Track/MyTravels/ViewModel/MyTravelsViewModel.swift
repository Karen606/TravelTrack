//
//  MyTravelsViewModel.swift
//  Travel_Track
//
//  Created by Karen Khachatryan on 14.11.24.
//

import Foundation

class MyTravelsViewModel {
    static let shared = MyTravelsViewModel()
    @Published var travels: [TravelModel] = []
    private var data: [TravelModel] = []
    var search: String?
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchMyTravels { [weak self] travels, _ in
            guard let self = self else { return }
            self.data = travels
            filter(by: search)
        }
    }
    
    func remove(id: UUID, completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.removeMyTravel(withId: id, completion: completion)
    }
    
    func filter(by value: String?) {
        self.search = value
        if let value = value?.lowercased(), !value.isEmpty {
            self.travels = data.filter { travel in
                    let countryMatch = travel.country?.lowercased().contains(value) ?? false
                    let cityMatch = travel.city?.lowercased().contains(value) ?? false
                    return countryMatch || cityMatch
                }
        } else {
            travels = data
        }
    }
    
    func clear() {
        search = nil
        travels = []
    }
}
