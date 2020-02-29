//
//  FileManagerExtension.swift
//  Metrum
//
//  Created by Jonas Jonas on 29.02.20.
//  Copyright © 2020 Jonas Jonas. All rights reserved.
//

import Foundation

extension FileManager {
    /// Copies file from main bundle to user document directory
    ///
    /// - Parameters:
    ///   - name: name of file that shall be copied
    ///   - ext: type of file that shall be copied
    func copyfileToUserDocumentDirectory(forResource name: String,
                                         ofType ext: String) throws
    {
        if let bundlePath = Bundle.main.path(forResource: name, ofType: ext),
            let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                            .userDomainMask, true).first {
            let fileName = "\(name).\(ext)"
            let fullDestPath = URL(fileURLWithPath: destPath).appendingPathComponent(fileName)
            let fullDestPathString = fullDestPath.path
            
            if !self.fileExists(atPath: fullDestPathString) {
                try self.copyItem(atPath: bundlePath, toPath: fullDestPathString)
            }
        }
    }
}
