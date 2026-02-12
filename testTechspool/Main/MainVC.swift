//
//  MainVC.swift
//  testTechspool
//
//  Created by Дмитрий Вакульчик on 12.02.26.
//

import UIKit
import SnapKit

final class MainVC: UIViewController {

    private let storage = OnboardingStorage()
    private let button = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        button.addTarget(self, action: #selector(onboardingTapped), for: .touchUpInside)
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }

        updateButton()
        checkOnboarding()
    }

    private func updateButton() {
        if storage.hasSeenOnboarding {
            button.setTitle("Добро пожаловать обратно", for: .normal)
            button.isEnabled = false
        } else {
            button.setTitle("Показать онбординг", for: .normal)
            button.isEnabled = true
        }
    }

    private func checkOnboarding() {
        guard !storage.hasSeenOnboarding else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.onboardingTapped()
        }
    }

    @objc private func onboardingTapped() {
        let slides = [
            OnboardingSlide(image: UIImage(systemName: "1.circle")!, title: "Привет!", description: "Добро пожаловать в приложение"),
            OnboardingSlide(image: UIImage(systemName: "2.circle")!, title: "Функции", description: "Узнайте все функции"),
            OnboardingSlide(image: UIImage(systemName: "3.circle")!, title: "Начнем", description: "Готовы начать работу?")
        ]

        let vm = OnboardingViewModel(slides: slides, storage: storage)
        let onboardingVC = OnboardingVC(viewModel: vm)
        onboardingVC.delegate = self
        onboardingVC.modalPresentationStyle = .fullScreen
        present(onboardingVC, animated: true)
    }

}

extension MainVC: OnboardingDelegate {
    func didFinishOnboarding() {
        updateButton()
    }
}
