//
//  OnboardingCell.swift
//  testTechspool
//
//  Created by Дмитрий Вакульчик on 12.02.26.
//

import UIKit
import SnapKit

final class OnboardingCell: UICollectionViewCell {
    
    private let slideView = OnboardingSlideView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }

    func configure(with model: OnboardingSlideModel) {
        slideView.configure(with: model)
    }

    func setParallax(offset: CGFloat) {
        slideView.applyParallax(offset: offset)
    }
}

// MARK: - private func

private extension OnboardingCell {
    func setupUI() {
        contentView.addSubview(slideView)
        slideView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
