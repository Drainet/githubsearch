//
//  MainViewController.swift
//  githubsearch
//
//  Created by 張喬彥 on 2019/10/15.
//  Copyright © 2019 drain. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    required init?(coder _: NSCoder) {
        fatalError("not supported")
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    let textField = UITextField()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        return collectionView
    }()

    override func loadView() {
        super.loadView()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
}
