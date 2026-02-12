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
    
    // MARK: UI Elements
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        view.register(OnboardingCell.self, forCellWithReuseIdentifier: "OnboardingCell")
        return view
    }()
    
    private lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.numberOfPages = viewModel.slidesCount
        page.currentPage = 0
        return page
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(viewModel.btnTitle(), for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("×", for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 28)
        btn.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return btn
    }()
    
    // MARK: properties
    
    private let viewModel: OnboardingViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: init
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: overrides funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.pageIndicatorTintColor = .secondaryLabel
    }
}

// MARK: - private funcs

private extension OnboardingVC {
    func setupUI() {
        view.backgroundColor = .systemBackground
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
    
    func bindViewModel() {
        viewModel.$currentPage.sink { [weak self] page in
            guard let self = self else { return }
            self.pageControl.currentPage = page
            UIView.transition(with: self.nextButton, duration: 0.3, options: .transitionCrossDissolve) {
                self.nextButton.setTitle(self.viewModel.btnTitle(), for: .normal)
            }
        }.store(in: &cancellables)
    }
    
    @objc func nextTapped() {
        if let next = viewModel.updatePageIndex() {
            viewModel.currentPage = next
            collectionView.scrollToItem(at: IndexPath(item: next, section: 0), at: .centeredHorizontally, animated: true)
        } else {
            viewModel.completeOnboarding()
            dismiss(animated: true)
        }
    }
    
    @objc func closeTapped() {
        viewModel.completeOnboarding()
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension OnboardingVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.slidesCount
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OnboardingVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as? OnboardingCell,
              let model = viewModel.page(for: indexPath.item) else {
            assertionFailure()
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let visibleCells = collectionView.visibleCells as? [OnboardingCell] else { return }
        
        let offsetX = scrollView.contentOffset.x
        
        for cell in visibleCells {
            let delta = offsetX - cell.frame.origin.x
            cell.setParallax(offset: delta)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
}

