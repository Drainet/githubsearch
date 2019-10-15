//
//  MainViewController.swift
//  githubsearch
//
//  Created by 張喬彥 on 2019/10/15.
//  Copyright © 2019 drain. All rights reserved.
//

import RxSwift
import SnapKit
import UIKit

class MainViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UISearchBarDelegate {
    required init?(coder _: NSCoder) {
        fatalError("not supported")
    }

    private let githubService: GithubService

    private let disposeBag = DisposeBag()

    init(githubService: GithubService = Services.githubService) {
        self.githubService = githubService
        super.init(nibName: nil, bundle: nil)
    }

    private let searchBar = UISearchBar()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(GithubUserCell.self, forCellWithReuseIdentifier: "GithubUserCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    private let searchSubject = PublishSubject<String>()

    override func loadView() {
        super.loadView()
        view.backgroundColor = .black
        view.addSubview(searchBar)
        view.addSubview(collectionView)

        searchBar.delegate = self
        searchBar.barStyle = .black
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private var page: Page<GithubUser> = Page<GithubUser>.empty()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchSubject
            .distinctUntilChanged()
            .flatMapLatest { [unowned self] query -> Single<Page<GithubUser>> in
                self.page = Page<GithubUser>.empty()
                self.collectionView.reloadData()
                return self.githubService
                    .search(query: query, page: self.page)
            }
            .subscribe(
                onNext: { [unowned self] page in
                    self.page = page
                    self.collectionView.reloadData()
                }
            )
            .disposed(by: disposeBag)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GithubUserCell", for: indexPath) as! GithubUserCell
        cell.bind(githubUser: page.data[indexPath.row])
        return cell
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        page.data.count
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 62)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            self.searchSubject.onNext(query)
            searchBar.endEditing(true)
        }
    }
}
