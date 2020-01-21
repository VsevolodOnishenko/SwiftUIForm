//
//  SettingStore.swift
//  SwiftUIList
//
//  Created by Vsevolod Onishchenko on 15.01.2020.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import Foundation
import Combine

final class SettingStore: ObservableObject {
    
    @Published var defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        defaults.register(defaults: [
            "view.preferences.showCheckInOnly": false,
            "view.preferences.displayOrder": 0,
            "view.preferences.maxPriceLevel": 5
        ])
    }
    
    var showCheckInOnly: Bool {
        get {
            defaults.bool(forKey: "view.preferences.showCheckInOnly")
        }
        
        set {
            defaults.set(newValue, forKey: "view.preferences.showCheckInOnly")
        }
    }
    
    var displayOrder: DisplayOrderType {
        get {
            DisplayOrderType(type: defaults.integer(forKey: "view.preferences.displayOrder"))
        }
        
        set {
            defaults.set(newValue.rawValue, forKey: "view.preferences.displayOrder")
        }
    }
    
    var maxPriceLevel: Int {
        get {
            defaults.integer(forKey: "view.preferences.maxPriceLevel")
        }
        
        set {
            defaults.set(newValue, forKey: "view.preferences.maxPriceLevel")
        }
    }
}

enum DisplayOrderType: Int, CaseIterable {
    case alphabetical = 0
    case favoriteFirst = 1
    case checkInFirst = 2
    
    init(type: Int) {
        switch type {
        case 0: self = .alphabetical
        case 1: self = .favoriteFirst
        case 2: self = .checkInFirst
        default: self = .alphabetical
        }
    }
    
    var text: String {
        switch self {
        case .alphabetical: return "Alpabetical"
        case .favoriteFirst: return "Show Favorite First"
        case .checkInFirst: return "Show Check-In First"
        }
    }
    
    func predicate() -> ((Restaurant, Restaurant) -> Bool) {
        switch self {
        case .alphabetical: return { $0.name < $1.name }
        case .checkInFirst: return { $0.isCheckIn && !$1.isCheckIn }
        case .favoriteFirst: return { $0.isFavorite && !$1.isFavorite }
        }
    }
}
