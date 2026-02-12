//
//  MainViewModel.swift
//  testTechspool
//
//  Created by Дмитрий Вакульчик on 12.02.26.
//

import UIKit

protocol MainViewModelProtocol {
    var buttonTitle: String { get }
    var isButtonEnabled: Bool { get }
    var shouldShowOnboarding: Bool { get }
    func markOnboardingSeen()
}

final class MainViewModel: MainViewModelProtocol {

    private let storage: OnboardingStorageProtocol

    init(storage: OnboardingStorageProtocol) {
        self.storage = storage
    }

    private var hasSeenOnboarding: Bool {
        storage.value(key: .onboardingSeen)
    }

    var buttonTitle: String {
        hasSeenOnboarding
        ? "Добро пожаловать обратно"
        : "Показать онбординг"
    }

    var isButtonEnabled: Bool {
        !hasSeenOnboarding
    }

    var shouldShowOnboarding: Bool {
        !hasSeenOnboarding
    }

    func markOnboardingSeen() {
        storage.update(key: .onboardingSeen, value: true)
    }
}
