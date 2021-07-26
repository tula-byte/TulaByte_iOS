//
//  RealmUtilities.swift
//  tunnel
//
//  Created by Arjun Singh on 10/2/21.
//

import Foundation
import RealmSwift
import WidgetKit

let blockCountSinceLastUpdateKey = "blockCountSinceLastUpdate"

//MARK:- CONFIG
let fileURL = FileManager.default
    .containerURL(forSecurityApplicationGroupIdentifier: "group.com.tulabyte.tulabyte")!
    .appendingPathComponent("tulabyte.realm")
let config = Realm.Configuration(fileURL: fileURL)

func addBlockLogItem(url: String, timestamp: Date = Date()) {
    let realm = try! Realm(configuration: config)
    
    let newItem = BlockLogItem()
    newItem.url = url
    newItem.timestamp = timestamp
    
    try! realm.write {
        realm.add(newItem)
        NSLog("TBT REALM: Added \(url) to Realm")
    }
    
    if #available(iOSApplicationExtension 14.0, iOS 14.0, *) {
        WidgetCenter.shared.reloadAllTimelines()
}
}

func retrieveBlockLog() -> Results<BlockLogItem> {
    let realm = try! Realm(configuration: config)
    
    let todayStart = Calendar.current.startOfDay(for: Date())
    
    let blockLog = realm.objects(BlockLogItem.self).sorted(byKeyPath: "timestamp", ascending: false)
    
    NSLog("TBT REALM: There are \(blockLog.count) items in the block log")
    
    return blockLog
}

func retrieveBlockLogToday() -> Results<BlockLogItem> {
    let realm = try! Realm(configuration: config)
    
    let todayStart = Calendar.current.startOfDay(for: Date())
    
    let blockLog = realm.objects(BlockLogItem.self).filter("timestamp >= %@", todayStart).sorted(byKeyPath: "timestamp", ascending: false)
    
    NSLog("TBT REALM: There are \(blockLog.count) items in the block log")
    
    return blockLog
}

func retrieveGroupedCount() -> Array<(url: String, count: Int)> {
    let realm = try! Realm(configuration: config)
    
    let blockLog = realm.objects(BlockLogItem.self).sorted(byKeyPath: "timestamp", ascending: false)
    
    let groupedLog = Dictionary(grouping: blockLog, by: {$0.url})
    
    var groupedLogCount = Array<(url: String, count: Int)>()
    
    for (key, value) in groupedLog {
        groupedLogCount.append((url: key, count: value.count))
    }
    
    groupedLogCount.sort(by: {$0.count > $1.count})
    
    return groupedLogCount
}

func retrieveGroupedCountToday() -> Array<(url: String, count: Int)> {
    let realm = try! Realm(configuration: config)
    
    let todayStart = Calendar.current.startOfDay(for: Date())
    
    let blockLog = realm.objects(BlockLogItem.self).filter("timestamp >= %@", todayStart).sorted(byKeyPath: "timestamp", ascending: false)
    
    let groupedLog = Dictionary(grouping: blockLog, by: {$0.url})
    
    var groupedLogCount = Array<(url: String, count: Int)>()
    
    for (key, value) in groupedLog {
        groupedLogCount.append((url: key, count: value.count))
    }
    
    groupedLogCount.sort(by: {$0.count > $1.count})
    
    return groupedLogCount
}

func clearBlockLog() {
    let realm = try! Realm(configuration: config)
    try! realm.write {
      realm.deleteAll()
    }
}

