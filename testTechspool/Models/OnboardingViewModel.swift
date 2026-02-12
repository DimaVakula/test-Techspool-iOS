//
//  OnboardingViewModel.swift
//  testTechspool
//
//  Created by Дмитрий Вакульчик on 12.02.26.
//

import Foundation
import Combine

final class OnboardingViewModel {
    let slides: [OnboardingSlide]
    @Published var currentPage = 0
    private var storage: OnboardingStorageProtocol

    init(slides: [OnboardingSlide], storage: OnboardingStorageProtocol) {
        self.slides = slides
        self.storage = storage
    }

    func nextPage() -> Int? {
        let next = currentPage + 1
        return next < slides.count ? next : nil
    }

    func completeOnboarding() {
        storage.hasSeenOnboarding = true
    }
}
