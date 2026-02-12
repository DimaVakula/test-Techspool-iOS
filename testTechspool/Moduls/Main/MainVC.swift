//
//  MainVC.swift
//  testTechspool
//
//  Created by Дмитрий Вакульчик on 12.02.26.
//

import UIKit
import SnapKit

final class MainVC: UIViewController {

    // MARK: - Properties

    private let viewModel: MainViewModelProtocol
    private let button = UIButton(type: .system)

    // MARK: - Init

    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
        showOnboardingIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configure()
    }
}

// MARK: - Private

private extension MainVC {

    func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(button)

        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(220)
        }

        button.addTarget(self, action: #selector(onboardingTapped), for: .touchUpInside)
    }

    func configure() {
        button.setTitle(viewModel.buttonTitle, for: .normal)
        button.isEnabled = viewModel.isButtonEnabled
    }

    func showOnboardingIfNeeded() {
        guard viewModel.shouldShowOnboarding else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.onboardingTapped()
        }
    }

    @objc func onboardingTapped() {
        let slides = OnboardingSlidesFactory.make()

        let onboardingVM = OnboardingViewModel(
            slides: slides,
            deps: .init(storage: UDStorage())
        )

        let vc = OnboardingVC(viewModel: onboardingVM)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}
