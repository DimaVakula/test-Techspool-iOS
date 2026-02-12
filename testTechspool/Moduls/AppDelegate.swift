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

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        let mainVC = MainVC(viewModel: MainViewModel(storage: UDStorage()))
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()

        return true
    }
}
