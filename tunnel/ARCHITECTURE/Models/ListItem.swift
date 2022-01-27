//
//  ListItem.swift
//  tunnel
//
//  Created by Arjun Singh on 7/1/22.
//

import Foundation
import RealmSwift

class ListItem: Object {
    @Persisted(primaryKey: true) var url: String = ""
    @Persisted var userAdded: Bool = true
}

class BlockListItem: ListItem {
}

class AllowListItem: ListItem {
}

// List options
enum TulaList {
    case allow //index 0
    case block //index 1
    case other //index 2
}

