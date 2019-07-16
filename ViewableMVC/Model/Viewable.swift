//
//  Viewable.swift
//  ViewableMVC
//
//  Created by K Y on 7/1/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation

typealias BoolReturnVoid = (Bool)->Void

public protocol Viewable: Decodable {
    var items: [Item] { get }
}

public protocol Item: Decodable {
    var text: String? { get }
    var info: String? { get }
    var imageSource: String? { get }
}
