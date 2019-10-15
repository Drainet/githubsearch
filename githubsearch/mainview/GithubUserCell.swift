//
// Created by drain on 2019/10/15.
// Copyright (c) 2019 drain. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import SnapKit

class GithubUserCell : UICollectionViewCell {
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    private let label = UILabel()

    private let avatarImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.addSubview(avatarImageView)

        label.textColor = .white

        avatarImageView.layer.cornerRadius = 15
        avatarImageView.clipsToBounds = true

        avatarImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 30, height: 30))
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        label.snp.makeConstraints {
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
    }

    func bind(githubUser: GithubUser) {
        label.text = githubUser.login
        avatarImageView.sd_setImage(with: URL(string: githubUser.avatarUrl), placeholderImage: nil)
    }
}
