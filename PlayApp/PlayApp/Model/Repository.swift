//
//  Repository.swift
//  PlayApp
//
//  Created by ameethakkar on 8/3/18.
//  Copyright © 2018 ameethakkar. All rights reserved.
//

import Foundation

class Repository {
    private var name = ""
    private var description = ""
    private var created_at = ""
    private var license:NSDictionary?
    
//    static func inflateClass(response:NSDictionary) -> Repository? {
//        let mirror = Mirror(reflecting: self)
//        for (_,var attr) in mirror.children.enumerated() {
//            guard let val = response.value(forKey: attr.label!) else {
//                return nil
//            }
//            attr.value = val
//        }
//        return self.init()
//    }
    
    init(name:String?,description:String?,created_at:String?,license:NSDictionary?) {
        
        self.name = name ?? ""
        self.description = description ?? ""
        self.created_at = created_at ?? ""
        self.license = license
    }
    
    func getName() -> String {
        return name
    }
    func getDescription() -> String {
        return description
    }
    func getCreatedAt() -> String {
        return created_at
    }
    func getLicense() -> String {
        guard let val = license?.value(forKey: "name") as? String else {
            return ""
        }
        return val
    }
}

