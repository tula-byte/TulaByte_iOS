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
