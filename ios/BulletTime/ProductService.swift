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
    
    dynamic var uuid: String = UUID().uuidString
    dynamic var imageIds: String = ""
    dynamic var timeCreated = Date()
    
    lazy var images: [UIImage] = { [unowned self] in
        let ids = self.imageIds.components(separatedBy: ",")
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
            .objects(Product.self)
            .sorted(byProperty: "timeCreated", ascending: false)
            .flatMap({ e in e })
    }
    
    func createProduct(withImages images: [UIImage]) -> Product {
        let product = Product()
        var imageIds:[String] = []
        for image in images {
            let uuid = UUID().uuidString
            let _ = fileManager.writeObject(image, toRelativePath: basePath, fileName: "\(uuid).jpg")
            imageIds.append(uuid)
        }
        product.imageIds = imageIds.joined(separator: ",")
        try! realm.write {
            realm.add(product, update: true)
        }
        return product
    }
    
    
    func deleteProduct(_ product: Product) {
        let ids = product.imageIds.components(separatedBy: ",")
        for id in ids {
            let path = FileManager.sharedInstance.absolutePath("\(basePath)/\(id).jpg")
            FileManager.sharedInstance.removeFileAtPath(path)
        }
        try! realm.write {
            realm.delete(product)
        }
    }
}

