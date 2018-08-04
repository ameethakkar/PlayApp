//
//  Utilies.swift
//  PlayApp
//
//  Created by ameethakkar on 8/3/18.
//  Copyright © 2018 ameethakkar. All rights reserved.
//

import UIKit

class Utilies: NSObject {

    static var page = -1
    static func createAlert(title:String,message:String,style:UIAlertControllerStyle = .alert) -> UIAlertController{
        let ac = UIAlertController(title: title,message: message,preferredStyle: style)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        return ac
    }    
}
