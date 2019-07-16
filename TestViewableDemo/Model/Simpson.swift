//
//  Simpson.swift
//  SimpsonsViewer
//
//  Created by K Y on 7/1/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation
import ViewableMVC

struct SimpsonContainer: Viewable {
    var simpsons: [Simpson]
    
    var items: [Item] {
        return simpsons
    }
    
    enum TopLevelCodingKeys: String, CodingKey {
        case relatedTopics = "RelatedTopics"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TopLevelCodingKeys.self)
        simpsons = try container.decode([Simpson].self, forKey: .relatedTopics)
    }
    
}

struct Simpson: Item {
    let name: String
    let info: String?
    let url: String
    
    var text: String? {
        return name
    }
    var imageSource: String? {
        return url
    }
    
    enum SimpsonCodingKeys: String, CodingKey {
        case icon = "Icon"
        case url = "URL"
        case text = "Text"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SimpsonCodingKeys.self)
        let allText: String = try container.decode(String.self, forKey: .text)
        let allTextComps = allText.components(separatedBy: " - ")
        guard allTextComps.count == 2 else {
            throw NSError(domain: "Simpson Decoding Error - \"Text\" is improperly formatted",
                          code: 1,
                          userInfo: nil)
        }
        let iconDictContainer = try container.nestedContainer(keyedBy: SimpsonCodingKeys.self,
                                                              forKey: .icon)
        url = try iconDictContainer.decode(String.self, forKey: .url)
        name = allTextComps[0]
        info = allTextComps[1]
    }
    
}
