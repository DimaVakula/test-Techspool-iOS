//
//  OnboardingSlidesFactory.swift
//  testTechspool
//
//  Created by Дмитрий Вакульчик on 12.02.26.
//

import UIKit

enum OnboardingSlidesFactory {

    static func make() -> [OnboardingSlideModel] {
        return [
            OnboardingSlideModel(
                image: UIImage(systemName: "1.circle") ?? UIImage(),
                title: "Привет!",
                description: "Добро пожаловать в приложение"
            ),
            OnboardingSlideModel(
                image: UIImage(systemName: "2.circle") ?? UIImage(),
                title: "Функции",
                description: "Узнайте все функции"
            ),
            OnboardingSlideModel(
                image: UIImage(systemName: "3.circle") ?? UIImage(),
                title: "Начнем",
                description: "Готовы начать работу?"
            )
        ]
    }
}
