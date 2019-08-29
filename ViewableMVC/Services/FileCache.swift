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

private let fileManager = FileManager.default

class ImageCache {
    static private let baseDirectory = fileManager.urls(for: .cachesDirectory,
                                                        in: .userDomainMask)
    static private let baseURL = baseDirectory.first!
    
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
                inMemoryCache.setObject(data.ns, forKey: name.ns)
                return data
            }
            catch let err as NSError {
                let isError = (err.code == 260 || err.code == 4)
                print(isError ? "File not found" : "Error reading image: \(err)")
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
                print("Error saving image: \(error)")
            }
        }
    }
    
    class func deleteAllFiles() {
        let files = try? fileManager.contentsOfDirectory(at: baseURL,
                                                         includingPropertiesForKeys: nil,
                                                         options: .skipsPackageDescendants)
        for file in (files ?? []) {
            print(file)
            try? fileManager.removeItem(at: file)
        }
        
    }
}
