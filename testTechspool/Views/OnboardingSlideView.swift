//
//  OnboardingSlideView.swift
//  testTechspool
//
//  Created by Дмитрий Вакульчик on 12.02.26.
//

import UIKit
import SnapKit

final class OnboardingSlideView: UIView {

    // MARK: - UI Elements

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, descriptionLabel])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 20
        return stack
    }()
    
    private var imageCenterConstraint: Constraint?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup

private extension OnboardingSlideView {

    func setupUI() {
        backgroundColor = .clear
        addSubview(stackView)
    }

    func setupLayout() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(30)
        }

        imageView.snp.makeConstraints {
            imageCenterConstraint = $0.centerX.equalToSuperview().constraint
            $0.height.equalTo(imageView.snp.width)
        }
    }
}

// MARK: - Configuration

extension OnboardingSlideView {

    func configure(with model: OnboardingSlideModel) {
        imageView.image = model.image
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
}

// MARK: - applyParallax
extension OnboardingSlideView {

    func applyParallax(offset: CGFloat) {
        imageCenterConstraint?.update(offset: offset * 0.2)
    }
}
