//
// Created by 張喬彥 on 2019/10/15.
// Copyright (c) 2019 drain. All rights reserved.
//

import Foundation
import Alamofire

class Services {

    private static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private static let sessionManager: SessionManager = {
        let manager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        return manager
    }()

    static let githubService: GithubService = AlaGithubService(sessionManager: sessionManager, decoder: jsonDecoder)
}
