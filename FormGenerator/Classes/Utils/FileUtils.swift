//
//  FileUtils.swift
//  FormGenerator
//
//  Created by Ahmed Tarek on 29/03/2021.
//

import Foundation

class FileUtils {
    static func getFileSizeInMB(filePath: String) throws -> UInt64 {
        var sizeInBytes : UInt64
        let attr = try FileManager.default.attributesOfItem(atPath: filePath)
        sizeInBytes = attr[FileAttributeKey.size] as! UInt64
        return sizeInBytes / (1024 * 1024)
    }
    
    static func getFileSizeFromDataInMB(data: Data?) -> Double {
        guard data != nil else {
            return 0
        }
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB]
        bcf.countStyle = .file
        let sizeAsString = bcf.string(fromByteCount: Int64(data!.count))
        return Double(sizeAsString.split(separator: " ").first ?? "0") ?? 0
    }
}
