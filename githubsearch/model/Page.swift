//
// Created by drain on 2019/10/15.
// Copyright (c) 2019 drain. All rights reserved.
//

import Foundation

public struct Page<T: Decodable> {
    public let nextId: Int?
    public let data: [T]
    public var hasNext: Bool {
        !data.isEmpty
    }

    public static func empty<T: Decodable>() -> Page<T> {
        Page<T>(nextId: 1, data: [T]())
    }
}
