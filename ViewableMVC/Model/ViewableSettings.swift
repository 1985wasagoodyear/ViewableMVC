//
//  ViewableSettings.swift
//  ViewableMVC
//
//  Created by K Y on 7/1/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import UIKit

public enum ViewableCacheSetting {
    case inMemory
    case inMemoryAndDisk
    case never
}

public struct ViewableSettings {
    var font: UIFont
    var textColor: UIColor
    var placeholderImage: Data
    var placeholderText: String? = nil
    var cacheImages: ViewableCacheSetting
}

extension ViewableSettings {
    public static let standard = ViewableSettings(font: .systemFont(ofSize: 14.0),
                                                  textColor: .black,
                                                  placeholderImage: Data(),
                                                  placeholderText: "Text is missing, quack!",
                                                  cacheImages: .inMemoryAndDisk)
}
