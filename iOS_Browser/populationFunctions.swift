//
//  populationFunctions.swift
//  iOS_Browser
//
//  Created by Yen Shou on 3/20/21.
//

import Foundation
import RealmSwift

func isRealmPopulatedWithDefaultTab() -> Bool {
    let realm = try! Realm()
    if (realm.objects(Tab.self).count > 0) {
        return true
    }
    return false
}

func populateRealmWIthDefaultTab() {
    let realm = try! Realm()
    let defaultTab: Tab = Tab(value: ["url": "https://www.apple.com", "initialURL": "https://www.apple.com", "title": "Apple.com"])
    try! realm.write {
        realm.add(defaultTab)
    }
}
