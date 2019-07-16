//
//  FileCache.swift
//  ViewableMVC
//
//  Created by K Y on 6/17/19.
//  Copyright © 2019 KY. All rights reserved.
//

import Foundation

extension Data {
    var ns: NSData {
        return NSData(data: self)
    }
}

extension String {
    var ns: NSString {
        return NSString(string: self)
    }
}

class ImageCache {
    static private let baseURL = FileManager.default.urls(for: .cachesDirectory,
                                                  in: .userDomainMask).first!
    
    private var inMemoryCache = NSCache<NSString, NSData>()
    private let setting: ViewableCacheSetting
    
    public init(_ setting: ViewableCacheSetting) {
        if setting == .never {
            fatalError("Invalid ViewableCacheSetting for ImageCache: Never say 'never'")
        }
        self.setting = setting
    }
    
    func getImage(_ name: String) -> Data? {
        if let dat = inMemoryCache.object(forKey: name.ns) {
            return Data(referencing: dat)
        }
        else if setting == .inMemoryAndDisk {
            let url = ImageCache.baseURL.appendingPathComponent(name)
            do {
                let data = try Data(contentsOf: url)
                return data
            }
            catch {
                print("error: \(error)")
            }
        }
        return nil
    }
    
    open func saveImage(_ name: String, _ imageData: Data) {
        inMemoryCache.setObject(imageData.ns, forKey: name.ns)
        if setting == .inMemoryAndDisk {
            let url = ImageCache.baseURL.appendingPathComponent(name)
            do {
                try imageData.write(to: url)
            }
            catch {
                print("Error saving image")
            }
        }
    }
}
