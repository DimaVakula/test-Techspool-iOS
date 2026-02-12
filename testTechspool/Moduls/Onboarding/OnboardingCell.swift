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
        contentView.addSubview(slideView)
        slideView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(with model: OnboardingSlide) {
        slideView.configure(with: model)
    }

    func setParallax(offset: CGFloat, width: CGFloat) {
        slideView.imageView.snp.updateConstraints { make in
            make.centerX.equalToSuperview().offset(offset * 0.2)
        }
    }
}
