//
//  iTunesSearchDetailViewController.swift
//  RxSwiftBasic
//
//  Created by Minjae Kim on 8/11/24.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit

final class iTunesSearchDetailViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let appImage = AppImageView(cornerRadius: 12)
    private let appTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    private let companyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .systemGray
        return label
    }()
    private let downloadButton = CapsuleButton(title: "받기", backgroundColor: .systemBlue, textColor: .white)
    private let updateTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    private let currentVersionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .systemGray
        return label
    }()
    private let releaseNotesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    private let screenshotCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let disposeBag = DisposeBag()
    private let viewModel: iTuneSearchDetailViewModel
    
    init(searchApp: SearchApp) {
        self.viewModel = iTuneSearchDetailViewModel()
        super.init(nibName: nil, bundle: nil)
        bind(searchApp: searchApp)
    }
    
    private func bind(searchApp: SearchApp) {
        let initVC = PublishSubject<SearchApp>()
        
        let input = iTuneSearchDetailViewModel.Input(initVC: initVC)
        let output = viewModel.transform(input: input)
        
        output.configureContent
            .bind(with: self) { owner, searchApp in
                owner.appImage.setImage(imageUrl: searchApp.artworkUrl100)
                owner.appTitleLabel.text = searchApp.trackName
                owner.companyLabel.text = searchApp.sellerName
                owner.updateTitleLabel.text = "새로운 소식"
                owner.currentVersionLabel.text = "버전 \(searchApp.version)"
                owner.releaseNotesLabel.text = searchApp.releaseNotes
                owner.descriptionLabel.text = searchApp.description
            }
            .disposed(by: disposeBag)
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectioniDetailScreenshot> { [weak self] dataSource, collectionView, indexPath, item in
            guard let self, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: iTuneDetailScreenshotCollectionViewCell.identifier, for: indexPath) as? iTuneDetailScreenshotCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.setImage(imageUrl: item)
            
            return cell
        }
        
        output.screenshotUrlList
            .bind(to: screenshotCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        Observable.just(searchApp)
            .bind(to: initVC)
            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureHieararchy()
        configureLayout()
    }
    
    private func configureHieararchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(appImage)
        contentView.addSubview(appTitleLabel)
        contentView.addSubview(companyLabel)
        contentView.addSubview(downloadButton)
        contentView.addSubview(updateTitleLabel)
        contentView.addSubview(currentVersionLabel)
        contentView.addSubview(releaseNotesLabel)
        contentView.addSubview(screenshotCollectionView)
        contentView.addSubview(descriptionLabel)
    }
    
    private func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.verticalEdges.equalTo(scrollView)
        }
        
        appImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
            make.size.equalTo(100)
        }
        
        appTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(appImage.snp.top)
            make.leading.equalTo(appImage.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        companyLabel.snp.makeConstraints { make in
            make.top.equalTo(appTitleLabel.snp.bottom)
            make.leading.equalTo(appImage.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.leading.equalTo(appImage.snp.trailing).offset(20)
            make.bottom.equalTo(appImage.snp.bottom)
            make.width.equalTo(80)
        }
        
        updateTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(appImage.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        currentVersionLabel.snp.makeConstraints { make in
            make.top.equalTo(updateTitleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        releaseNotesLabel.snp.makeConstraints { make in
            make.top.equalTo(currentVersionLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        screenshotCollectionView.snp.makeConstraints { make in
            make.top.equalTo(releaseNotesLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(500)
        }
        screenshotCollectionView.register(iTuneDetailScreenshotCollectionViewCell.self, forCellWithReuseIdentifier: iTuneDetailScreenshotCollectionViewCell.identifier)
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(screenshotCollectionView.snp.bottom).offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension iTunesSearchDetailViewController {
    static func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(4)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
