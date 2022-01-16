//
//  BlockLogItem.swift
//  tunnel
//
//  Created by Arjun Singh on 10/2/21.
//

import Foundation
import RealmSwift

class BlockLogItem: Object {
    @Persisted var url: String = ""
    @Persisted dynamic var timestamp: Date = Date()
}
