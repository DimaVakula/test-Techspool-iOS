//
//  AppDelegate.swift
//  testTechspool
//
//  Created by Дмитрий Вакульчик on 12.02.26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let storage = OnboardingStorage()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)

        let mainVC = MainVC()
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()

        if !storage.hasSeenOnboarding {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showOnboarding(from: mainVC)
            }
        }

        return true
    }

    private func showOnboarding(from rootVC: UIViewController) {
        let slides = [
            OnboardingSlide(image: UIImage(systemName: "1.circle")!, title: "Привет!", description: "Добро пожаловать в приложение"),
            OnboardingSlide(image: UIImage(systemName: "2.circle")!, title: "Функции", description: "Узнайте все функции"),
            OnboardingSlide(image: UIImage(systemName: "3.circle")!, title: "Начнем", description: "Готовы начать работу?")
        ]

        let vm = OnboardingViewModel(slides: slides, storage: storage)
        let onboardingVC = OnboardingVC(viewModel: vm)
        onboardingVC.delegate = rootVC as? OnboardingDelegate
        onboardingVC.modalPresentationStyle = .fullScreen
        rootVC.present(onboardingVC, animated: true)
    }
}
