//
//  OnboardingStorage.swift
//  testTechspool
//
//  Created by Дмитрий Вакульчик on 12.02.26.
//

import Foundation

protocol OnboardingStorageProtocol {
    var hasSeenOnboarding: Bool { get set }
}

protocol OnboardingDelegate: AnyObject {
    func didFinishOnboarding()
}

final class OnboardingStorage: OnboardingStorageProtocol {
    private let key = "hasSeenOnboarding"

    var hasSeenOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: key) }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}
