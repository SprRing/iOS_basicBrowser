//
//  Tab.swift
//  iOS_Browser
//
//  Created by Yen Shou on 3/20/21.
//

import Foundation
import RealmSwift

class Tab: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var initialURL: String = ""
    
    
    var tabDescription: String {
        let titleDescription = "Title: \(title)\n"
        let urlDescription = "URL: \(url)\n"
        let initialURLDescription = "Initial URL: \(url)\n"
        return "Tab information: \n\(urlDescription)\(initialURLDescription)\(titleDescription)\n"
    }
}
