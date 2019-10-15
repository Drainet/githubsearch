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

    private let loadNextSubject = PublishSubject<String>()

    private var page: Page<GithubUser> = Page<GithubUser>.empty()

    private var results = [GithubUser]()

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

    override func viewDidLoad() {
        super.viewDidLoad()

        searchSubject
            .distinctUntilChanged()
            .flatMapLatest { [unowned self] query -> Single<Page<GithubUser>> in
                self.page = Page<GithubUser>.empty()
                self.results = [GithubUser]()
                self.collectionView.reloadData()
                return self.githubService
                    .search(query: query, page: self.page)
            }
            .subscribe(
                onNext: { [unowned self] page in
                    self.page = page
                    self.results = page.data
                    self.collectionView.reloadData()
                }
            )
            .disposed(by: disposeBag)

        loadNextSubject
            .flatMapLatest { [unowned self] query -> Single<Page<GithubUser>> in
                self.githubService
                    .search(query: query, page: self.page)
            }
            .subscribe(
                onNext: { [unowned self] page in
                    self.page = page
                    self.results += page.data
                    self.collectionView.reloadData()
                }
            )
            .disposed(by: disposeBag)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GithubUserCell", for: indexPath) as! GithubUserCell
        cell.bind(githubUser: results[indexPath.row])
        return cell
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        results.count
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 62)
    }

    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row > results.count - 3, let query = searchBar.text, self.page.hasNext {
            self.loadNextSubject.onNext(query)
        }
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        0
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        0
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            searchSubject.onNext(query)
            searchBar.endEditing(true)
        }
    }
}
