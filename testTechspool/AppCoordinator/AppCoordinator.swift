//
//  AppCoordinator.swift
//  testTechspool
//

import UIKit

final class AppCoordinator {

    let window: UIWindow
    private let storage: UDProtocol
    private let mainVC: MainVC

    init(window: UIWindow, storage: UDProtocol = UDStorage()) {
        self.window = window
        self.storage = storage

        // создаём MainVC и передаём Coordinator как делегат
        let mainViewModel = MainViewModel(storage: storage)
        self.mainVC = MainVC(viewModel: mainViewModel)
        self.mainVC.delegate = self
    }

    func start() {
        window.rootViewController = mainVC
        window.makeKeyAndVisible()
        showOnboardingIfNeeded()
    }

    private func showOnboardingIfNeeded() {
        guard !storage.value(key: .onboardingSeen) else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.showOnboarding()
        }
    }

    private func showOnboarding() {
        let slides = OnboardingSlidesFactory.make()
        let onboardingVM = OnboardingViewModel(slides: slides, deps: .init(storage: storage))
        let onboardingVC = OnboardingVC(viewModel: onboardingVM)
        onboardingVC.modalPresentationStyle = .fullScreen
        mainVC.present(onboardingVC, animated: true)
    }
}

// MARK: - MainVCDelegate

extension AppCoordinator: MainVCDelegate {
    func mainVCButtonTapped(_ mainVC: MainVC) {
        showOnboarding()
    }
}
