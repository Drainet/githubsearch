//
// Created by drain on 2019/10/15.
// Copyright (c) 2019 drain. All rights reserved.
//

import Alamofire
import CodableAlamofire
import Foundation
import RxSwift

protocol GithubService {
    func search(query: String, page: GithubRequestPage<GithubUser>?) -> Single<GithubRequestPage<GithubUser>>
}

class AlaGithubService: GithubService {
    let sessionManager: SessionManager

    let decoder: JSONDecoder

    init(sessionManager: SessionManager, decoder: JSONDecoder) {
        self.sessionManager = sessionManager
        self.decoder = decoder
    }

    func search(query: String, page: GithubRequestPage<GithubUser>?) -> Single<GithubRequestPage<GithubUser>> {
        let requestUrl: String
        if let nextUrl = page?.nextUrl {
            requestUrl = nextUrl
        } else {
            requestUrl = "https://api.github.com/search/users?q=\(query)"
        }
        return Single<GithubRequestPage<GithubUser>>.create { observer in
            self.sessionManager
                .request(
                    requestUrl,
                    method: .get,
                    encoding: URLEncoding.default
                )
                .responseDecodableObject(decoder: self.decoder) { (response: DataResponse<GithubSearchResult>) in
                    switch response.result {
                    case let .success(searchResult):
                        if let linkHeader = response.response?.allHeaderFields["Link"] as? String {
                            let next = self.parse(linkHeader: linkHeader)
                            observer(.success(GithubRequestPage(nextUrl: next, data: searchResult.items ?? [GithubUser]())))
                        } else {
                            observer(.error(NSError()))
                        }
                    case let .failure(error):
                        observer(.error(error))
                    }
                }
            return Disposables.create()
        }
        .observeOn(MainScheduler.instance)
    }
    private func parse(linkHeader: String) -> String? {
        if let index = linkHeader.index(of: ">; rel=\"next\"") {
            let substring = linkHeader[..<index]
            let string = String(substring)
            if let lastIndex = string.lastIndex(of: "<") {
                let afterLastIndex = string.index(after: lastIndex)
                return string.substring(from: afterLastIndex)
            }
        }
        return nil
    }

}
extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
}

