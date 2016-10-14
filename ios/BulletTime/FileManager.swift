//
//  AVCaptureDevice.swift
//  Slowmo
//
//  Created by ltebean on 16/4/16.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import Foundation
import UIKit

open class FileManager: NSObject {
    
    open static let sharedInstance = FileManager()
    
    let fileManager = Foundation.FileManager.default
    let documentPath = try! Foundation.FileManager.default.url(for: Foundation.FileManager.SearchPathDirectory.documentDirectory, in: Foundation.FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: true).path
    
    open func absolutePath(_ path: String) -> String {
        return documentPath + "/" + path
    }
    
    open func fileExistsAtRelativePath(_ path: String) -> Bool {
        return fileManager.fileExists(atPath: absolutePath(path))
    }
    
    open func fileExistsAtPath(_ path: String) -> Bool {
        return fileManager.fileExists(atPath: path)
    }
    
    open func writeObject(_ object: NSObject, toRelativePath relativePath: String, fileName: String) -> Bool {
        return writeObject(object, toPath: absolutePath(relativePath), fileName:fileName)
    }
    
    open func removeFileAtPath(_ path: String) {
        do {
            try fileManager.removeItem(atPath: path)
        } catch {
            return
        }
    }
    
    open func removeFileAtURL(_ url: URL) {
        do {
            try fileManager.removeItem(at: url)
        } catch {
            return
        }
    }
    
    open func writeObject(_ object: NSObject, toPath path: String, fileName: String) -> Bool {
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return false
        }
        let finalPath = "\(path)/\(fileName)"
        if let object = object as? NSArray {
            return object.write(toFile: finalPath, atomically: true)
        }
        else if let object = object as? NSDictionary {
            return object.write(toFile: finalPath, atomically: true)
        }
        else if let object = object as? UIImage {
            return ((try? UIImageJPEGRepresentation(object, 0.8)?.write(to: URL(fileURLWithPath: finalPath), options: [.atomic])) != nil)
        }
        return false
    }
    
    
    open func clearDocDir() {
        do {
            let files = try fileManager.contentsOfDirectory(atPath: documentPath)
            for file in files {
                removeFileAtPath(absolutePath(file))
            }
        } catch {
            return
        }
    }
}
