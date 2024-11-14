//
//  CalendarViewModel.swift
//  Travel_Track
//
//  Created by Karen Khachatryan on 14.11.24.
//

import Foundation

class CalendarViewModel {
    static let shared = CalendarViewModel()
    @Published var dates: [[Date]] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchMyTravels { [weak self] travels, _ in
            guard let self = self else { return }
            var dates: [[Date]] = []
            for travel in travels {
                let date = [travel.startDate ?? Date(), travel.endDate ?? Date()]
                dates.append(date)
            }
            self.dates = dates
        }
    }
}
