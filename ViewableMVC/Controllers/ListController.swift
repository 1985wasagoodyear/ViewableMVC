//
//  ListController.swift
//  ViewableMVC
//
//  Created by K Y on 7/1/19.
//  Copyright © 2019 K Y. All rights reserved.
//

import Foundation

public protocol ListNavigationHandler {
    func go(to index: Int)
}

public class ListController<T: Viewable> {
    
    let url: URL
    var settings: ViewableSettings {
        didSet {
            if settings.cacheImages != .never {
                imageCache = ImageCache(settings.cacheImages)
            }
        }
    }
    let navigationHandler: ListNavigationHandler
    
    private var service = NetworkService()
    private var imageCache: ImageCache!
    var datum = [Item]()
    let queue = DispatchQueue.main
    
    public init(url: URL,
                settings: ViewableSettings = ViewableSettings.standard,
                navigationHandler: ListNavigationHandler) {
        self.url = url
        self.settings = settings
        self.navigationHandler = navigationHandler
    }
    
    var count: Int {
        return datum.count
    }
    
    func fetchIfNeeded(_ completion: @escaping (Bool)->()) {
        let comp: BoolReturnVoid = { (success) in
            self.queue.async {
                completion(success)
            }
        }
        guard datum.isEmpty else {
            comp(true)
            return
        }
        service.dataTask(url: url,
                         type: T.self,
                         params: nil)
        { result in
            switch (result) {
            case .success (let val):
                self.datum = val.items
                comp(true)
            case .failure:
                comp(false)
            }
        }
    }
    
    public func text(at index: Int) -> String? {
        return datum[index].text
    }
    
    public func info(at index: Int) -> String? {
        return datum[index].info
    }
    
    public func image(at index: Int, _ completion: @escaping (Data) -> ()) {
        guard let imageURLString = datum[index].imageSource,
            let imageURL = URL(string: imageURLString) else {
                completion(settings.placeholderImage)
                return
        }
        if let name = datum[index].text,
            let im = imageCache?.getImage(name) {
            completion(im)
            return
        }
        let placeholder = settings.placeholderImage
        service.image(url: imageURL, params: nil) { [weak self] (im) in
            if let image = im {
                DispatchQueue.main.async {
                    completion(image)
                }
                if let name = self?.datum[index].text {
                    self?.imageCache?.saveImage(name, image)
                }
            }
            else {
                completion(placeholder)
            }
        }
    }
    
    func didSelect(at index: Int) {
        navigationHandler.go(to: index)
    }
    
}
