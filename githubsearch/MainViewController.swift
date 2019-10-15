//
//  MainViewController.swift
//  githubsearch
//
//  Created by 張喬彥 on 2019/10/15.
//  Copyright © 2019 drain. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("not supported")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }

}
