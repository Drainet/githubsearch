//
// Created by 張喬彥 on 2019/10/15.
// Copyright (c) 2019 drain. All rights reserved.
//

import Alamofire
import CodableAlamofire
import Foundation
import RxSwift

protocol GithubService {
    func search(query: String, page: Page<GithubUser>) -> Single<Page<GithubUser>>
}

class AlaGithubService: GithubService {
    let sessionManager: SessionManager

    let decoder: JSONDecoder

    init(sessionManager: SessionManager, decoder: JSONDecoder) {
        self.sessionManager = sessionManager
        self.decoder = decoder
    }

    func search(query: String, page: Page<GithubUser>) -> Single<Page<GithubUser>> {
        Single<Page<GithubUser>>.create { observer in
            self.sessionManager
                .request(
                    "https://api.github.com/search/users",
                    method: .get,
                    parameters: ["q": query, "page": page.nextId ?? 1],
                    encoding: URLEncoding.default
                )
                .responseDecodableObject(decoder: self.decoder) { (response: DataResponse<GithubSearchResult>) in
                    switch response.result {
                    case let .success(searchResult):
                        observer(.success(Page(nextId: (page.nextId ?? 1) + 1, data: searchResult.items)))
                    case let .failure(error):
                        observer(.error(error))
                    }
                }
            return Disposables.create()
        }
    }
}
