//
//  MockLoader.swift
//  Snakey List
//
//  Created by Ali Adam on 1/26/18.
//  Copyright © 2018 Ali Adam. All rights reserved.
//

import Foundation

/// constant file name to easly change them at any time
private enum Constants {
    static let itemListFileName = "ItemsList"
    static let FileExtension = "json"
    static let FileAndExt = "\(itemListFileName).\(FileExtension)"
    static let backUpFileAndExt = "backUP.\(FileExtension)"
}
/// this struct to load the items list file form bundel and add it to the doc diractory
struct MockLoader {
    
    /// load file from doc if exist or from bundel if not and add it to the diractroy
    ///
    /// - Parameter fileName: file name to load
    /// - Returns: data represnt the file
    static  fileprivate func loadMock(forFile fileName: String) -> Data? {
        
        if fileExists(Constants.FileAndExt) {
            guard  let url = getFileURL(Constants.FileAndExt), let data = FileManager.default.contents(atPath: url.path) else {
                return nil
            }
            return data
        }
        guard let file = Bundle.main.url(forResource: fileName, withExtension: Constants.FileExtension),
            let data = try? Data(contentsOf: file) else { return nil }
        try? FileManager.default.copyItem(at: file, to: getFileURL(Constants.FileAndExt)!)
        return data
        
    }
    
    /// varible represnt the data on file this what others can access
    static var itemsListMock: Data? {
        guard let result: Data = loadMock(forFile: Constants.itemListFileName) else { return nil }
        return result
    }
    
    /// cheack if file exist on doc dir or not
    static fileprivate func fileExists(_ fileName: String) -> Bool {
        guard let url = getFileURL(fileName) else {
            return false
        }
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    /// get file url by adding its name to the doc diractory
    static fileprivate func getFileURL(_ fileName: String) -> URL? {
        guard let cachurl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        let url = cachurl.appendingPathComponent(fileName, isDirectory: false)
        return url
        
    }
    
    /// update date on current file
    static func updateitems(_ data: Data) -> Bool {
        let url = getFileURL(Constants.FileAndExt)!
        do {
            if FileManager.default.fileExists(atPath: url.path) {
                createBackUpFileBeforeUpdate()
                //url.setTemporaryResourceValue(Constants.backUpFileAndExt, forKey: .nameKey)
                
            }
            if  FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil) {
                try FileManager.default.removeItem(at: getFileURL(Constants.backUpFileAndExt)!)
                return true
            }
            else
            {
                return false
            }
        } catch {
            return false
        }
    }
    
    /// create back file from current file to backup data in case any error happen
    @discardableResult static fileprivate func createBackUpFileBeforeUpdate() -> Bool {
        do {
            let originPath = getFileURL(Constants.FileAndExt)!
            let destinationPath = getFileURL(Constants.backUpFileAndExt)!
            try FileManager.default.moveItem(at: originPath, to: destinationPath)
            return true
        } catch {
            print(error)
            return false
        }
    }
}
