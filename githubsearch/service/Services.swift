//
// Created by drain on 2019/10/15.
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
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }()

    static let githubService: GithubService = AlaGithubService(sessionManager: sessionManager, decoder: jsonDecoder)
}
