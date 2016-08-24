//
//  ProductService.swift
//  BulletTime
//
//  Created by leo on 16/8/18.
//  Copyright © 2016年 ltebean. All rights reserved.
//

import UIKit
import RealmSwift


class Product: Object {
    
    dynamic var uuid: String = NSUUID().UUIDString
    dynamic var imageIds: String = ""
    dynamic var timeCreated = NSDate()
    
    lazy var images: [UIImage] = { [unowned self] in
        let ids = self.imageIds.componentsSeparatedByString(",")
        return ids.map {
            let path = FileManager.sharedInstance.absolutePath("photo/\($0).jpg")
            return UIImage(contentsOfFile:path)!
        }
    }()
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["images"]
    }
    
}


class ProductService: NSObject {

    static let sharedInstance = ProductService()
    let fileManager = FileManager.sharedInstance
    let basePath = "photo"
    
    let realm = try! Realm()
    
    func loadAll() -> [Product] {
        return realm
            .objects(Product)
            .sorted("timeCreated", ascending: false)
            .flatMap({ e in e })
    }
    
    func createProduct(withImages images: [UIImage]) -> Product {
        let product = Product()
        var imageIds:[String] = []
        for image in images {
            let uuid = NSUUID().UUIDString
            fileManager.writeObject(image, toRelativePath: basePath, fileName: "\(uuid).jpg")
            imageIds.append(uuid)
        }
        product.imageIds = imageIds.joinWithSeparator(",")
        try! realm.write {
            realm.add(product, update: true)
        }
        return product
    }
    
    
    func deleteProduct(product: Product) {
        let ids = product.imageIds.componentsSeparatedByString(",")
        for id in ids {
            let path = FileManager.sharedInstance.absolutePath("\(basePath)/\(id).jpg")
            FileManager.sharedInstance.removeFileAtPath(path)
        }
        try! realm.write {
            realm.delete(product)
        }
    }
}

