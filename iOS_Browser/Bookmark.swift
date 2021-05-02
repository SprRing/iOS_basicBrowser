//
//  Bookmark.swift
//  iOS_Browser
//
//  Created by Yen Shou on 3/19/21.
//

import Foundation
import RealmSwift

class Bookmark: Object {
    
    @objc dynamic var url: String = ""
    @objc dynamic var title: String = ""
    
    override static func primaryKey() -> String? {
        return "url"
    }
    var bookmarkDescription: String {
        let titleDescription = "Title: \(title)\n"
        let urlDescription = "URL: \(url)\n"
        return "Bookmark information: \n\(urlDescription)\(titleDescription)\n"
    }
}
