//
//  OnboardingViewModel.swift
//  testTechspool
//
//  Created by Дмитрий Вакульчик on 12.02.26.
//

import Foundation
import Combine

protocol OnboardingViewModelProtocol {
    func completeOnboarding()
    func page(for index: Int) -> OnboardingSlideModel?
    func updatePageIndex() -> Int?
    func btnTitle() -> String
    var slidesCount: Int { get }
}

final class OnboardingViewModel {
    
    private enum Constants {
        static let startWork = "Начать работу"
        static let next = "Далее"
    }
    
    struct Dependencies {
        let storage: UDProtocol
    }
    
    private let deps: Dependencies
    private let slides: [OnboardingSlideModel]
    
    @Published var currentPage = 0
    
    init(slides: [OnboardingSlideModel], deps: Dependencies) {
        self.slides = slides
        self.deps = deps
    }
}

// MARK: - OnboardingViewModelProtocol

extension OnboardingViewModel: OnboardingViewModelProtocol {
    var slidesCount: Int {
        return slides.count
    }
    
    func page(for index: Int) -> OnboardingSlideModel? {
        guard currentPage < slides.count else { return nil }
        return slides[index]
    }
    
    func updatePageIndex() -> Int? {
        guard currentPage < slides.count - 1 else { return nil }
        currentPage += 1
        return currentPage
    }
    
    func completeOnboarding() {
        deps.storage.update(key: .onboardingSeen, value: true)
    }
    
    func btnTitle() -> String {
        let title = currentPage == slides.count - 1 ? Constants.startWork : Constants.next
        return title
    }
}
