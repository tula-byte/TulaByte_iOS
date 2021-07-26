//
//  BlockLogItem.swift
//  tunnel
//
//  Created by Arjun Singh on 10/2/21.
//

import Foundation
import RealmSwift

class BlockLogItem: Object {
    @objc dynamic var url: String = ""
    @objc dynamic var timestamp: Date = Date()
}
