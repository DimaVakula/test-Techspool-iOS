//
//  OnboardingVC.swift
//  testTechspool
//
//  Created by Дмитрий Вакульчик on 12.02.26.
//

import UIKit
import SnapKit
import Combine

final class OnboardingVC: UIViewController {

    weak var delegate: OnboardingDelegate?

    private let viewModel: OnboardingViewModel
    private var cancellables = Set<AnyCancellable>()

    private let collectionView: UICollectionView
    private let pageControl = UIPageControl()
    private let nextButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)

    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero

        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(OnboardingCell.self, forCellWithReuseIdentifier: "OnboardingCell")

        pageControl.numberOfPages = viewModel.slides.count
        pageControl.currentPage = 0

        nextButton.setTitle("Далее", for: .normal)
        nextButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        closeButton.setTitle("×", for: .normal)
        closeButton.titleLabel?.font = .boldSystemFont(ofSize: 28)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        [collectionView, pageControl, nextButton, closeButton].forEach { view.addSubview($0) }

        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(pageControl.snp.top).offset(-20)
        }
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50); $0.width.equalTo(200)
        }
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.right.equalToSuperview().inset(20)
            $0.height.width.equalTo(40)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.pageIndicatorTintColor = .secondaryLabel
    }

    private func bindViewModel() {
        viewModel.$currentPage.sink { [weak self] page in
            guard let self = self else { return }
            self.pageControl.currentPage = page
            let isLast = page == self.viewModel.slides.count - 1
            UIView.transition(with: self.nextButton, duration: 0.3, options: .transitionCrossDissolve) {
                self.nextButton.setTitle(isLast ? "Начать работу" : "Далее", for: .normal)
            }
        }.store(in: &cancellables)
    }

    @objc private func nextTapped() {
        if let next = viewModel.nextPage() {
            viewModel.currentPage = next
            collectionView.scrollToItem(at: IndexPath(item: next, section: 0), at: .centeredHorizontally, animated: true)
        } else {
            viewModel.completeOnboarding()
            delegate?.didFinishOnboarding()
            dismiss(animated: true)
        }
    }

    @objc private func closeTapped() {
        viewModel.completeOnboarding()
        delegate?.didFinishOnboarding()
        dismiss(animated: true)
    }
}

// MARK: - UICollectionView
extension OnboardingVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.slides.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCell
        cell.configure(with: viewModel.slides[indexPath.item])
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        for cell in collectionView.visibleCells as! [OnboardingCell] {
            let delta = offsetX - cell.frame.origin.x
            cell.setParallax(offset: delta, width: collectionView.frame.width)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
}

