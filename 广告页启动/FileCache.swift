//
//  FileCache.swift
//  广告页启动
//
//  Created by 文伟佳 on 2021/11/16.
//

import Foundation

class FileCache {
//    static let shareInstance = FileCache()
    
    static let shareInstance: FileCache = {
        let file = FileCache()
        file.createPathsIfNotExist()
        return file
    }()
    
    private init(){}
    
    private func createPathsIfNotExist() {
        let adPath = adPath()!
        if (!FileManager.default.fileExists(atPath: adPath)) {
            try? FileManager.default.createDirectory(atPath: adPath, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func adPath() -> String? {
        let cacheFileRootPath =  cacheFileRootPath()
        if let _cacheFileRootPath = cacheFileRootPath {
            return "\(_cacheFileRootPath)/ads/sources/"
        }
        return nil
    }
    
    func filePath(_ path: String?) -> String? {
        guard let path = path else {
            return nil
        }

        let subPaths = FileManager.default.subpaths(atPath: path)
        if let _subPaths = subPaths, _subPaths.count > 0 {
            return _subPaths.first!
        }
        return nil
    }
    
    func clearPath(_ path: String) {
        guard let imageFile = filePath(path) else {
            return
        }
        try? FileManager.default.removeItem(atPath: path + imageFile)
    }
    
    /// 缓存路径根目录
    private func cacheFileRootPath() -> String? {
        // ~/Library/Caches/
        let paths =
        NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let cachesFileName = paths.first
        
        if let _cachesFileName = cachesFileName {
            return "\(_cachesFileName)/com.wwj.caches"
        }
        
        return nil
    }
}


