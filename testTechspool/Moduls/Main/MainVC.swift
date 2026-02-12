//
//  MainVC.swift
//  testTechspool
//
//  Created by Дмитрий Вакульчик on 12.02.26.
//

import UIKit
import SnapKit

// MARK: - Delegate

protocol MainVCDelegate: AnyObject {
    func mainVCButtonTapped(_ mainVC: MainVC)
}

final class MainVC: UIViewController {

    // MARK: - Properties

    private let viewModel: MainViewModelProtocol
    
    weak var delegate: MainVCDelegate?

    private let button: UIButton = {
        let btn = UIButton(type: .system)
        return btn
    }()

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
        configureButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureButton()
    }
}

// MARK: - Private UI Setup

private extension MainVC {

    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(button)

        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalTo(220)
        }

        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    func configureButton() {
        button.setTitle(viewModel.buttonTitle, for: .normal)
        button.isEnabled = viewModel.isButtonEnabled
    }
    
    @objc func buttonTapped() {
        delegate?.mainVCButtonTapped(self)
    }
}
