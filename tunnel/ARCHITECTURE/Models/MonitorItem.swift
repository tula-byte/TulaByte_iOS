//
//  MonitorItem.swift
//  tunnel
//
//  Created by Arjun Singh on 19/1/22.
//

import Foundation
import RealmSwift

class MonitorItem: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var url: String = ""
    @Persisted var timestamp: Date = Date()
    @Persisted var list: Int = 2
}
