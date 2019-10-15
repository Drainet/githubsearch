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

class MainViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    required init?(coder _: NSCoder) {
        fatalError("not supported")
    }

    private let githubService: GithubService

    private let disposeBag = DisposeBag()

    init(githubService: GithubService = Services.githubService) {
        self.githubService = githubService
        super.init(nibName: nil, bundle: nil)
    }

    let textField = UITextField()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(GithubUserCell.self, forCellWithReuseIdentifier: "GithubUserCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    override func loadView() {
        super.loadView()
        view.backgroundColor = .black
        view.addSubview(textField)
        view.addSubview(collectionView)

        textField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    private var page: Page<GithubUser> = Page<GithubUser>.empty()

    override func viewDidLoad() {
        super.viewDidLoad()
        githubService
            .search(query: "tom", page: page)
            .subscribe(
                onSuccess: { page in
                    self.page = page
                    self.collectionView.reloadData()
                },
                onError: { _ in
                }
            )
            .disposed(by: disposeBag)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GithubUserCell", for: indexPath) as! GithubUserCell
        cell.bind(githubUser: self.page.data[indexPath.row])
        return cell
    }

    func numberOfSections(in _: UICollectionView) -> Int {
        1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        self.page.data.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 40)
    }
}
