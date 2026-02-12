//
//  OnboardingStorage.swift
//  testTechspool
//
//  Created by Дмитрий Вакульчик on 12.02.26.
//

import Foundation


protocol UDProtocol {
    func update(key: UDStorage.Keys, value: Bool)
    func value(key: UDStorage.Keys) -> Bool
}

final class UDStorage {
    
    private let userDefaults = UserDefaults.standard
    
    enum Keys: String {
        case onboardingSeen = "hasSeenOnboarding"
    }
}

// MARK: - OnboardingStorageProtocol

extension UDStorage: UDProtocol {
    
    func update(key: UDStorage.Keys, value: Bool) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    func value(key: UDStorage.Keys) -> Bool {
        userDefaults.bool(forKey: key.rawValue)

    }
}
