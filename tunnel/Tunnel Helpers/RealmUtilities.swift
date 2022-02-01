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

//MARK: - CONFIG
let fileURL = FileManager.default
    .containerURL(forSecurityApplicationGroupIdentifier: "group.com.tulabyte.tulabyte")!
    .appendingPathComponent("tulabyte.realm")
let config = Realm.Configuration(fileURL: fileURL)

//MARK: - Block Log
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
    
    if blockLog.count != 0 {
        let groupedLog = Dictionary(grouping: blockLog, by: {$0.url})
        
        var groupedLogCount = Array<(url: String, count: Int)>()
        
        for (key, value) in groupedLog {
            groupedLogCount.append((url: key, count: value.count))
        }
        
        groupedLogCount.sort(by: {$0.count > $1.count})
        
        return groupedLogCount
    }
    NSLog("TBT: There was nothing in the blocklog, so GROUPED COUNT returned empty")
    return []
}

func retrieveGroupedCountToday() -> Array<(url: String, count: Int)> {
    let realm = try! Realm(configuration: config)
    
    let todayStart = Calendar.current.startOfDay(for: Date())
    
    let blockLog = realm.objects(BlockLogItem.self).filter("timestamp >= %@", todayStart).sorted(byKeyPath: "timestamp", ascending: false)
    if blockLog.count != 0 {
    let groupedLog = Dictionary(grouping: blockLog, by: {$0.url})
    
    var groupedLogCount = Array<(url: String, count: Int)>()
    
    for (key, value) in groupedLog {
        groupedLogCount.append((url: key, count: value.count))
    }
    
    groupedLogCount.sort(by: {$0.count > $1.count})
    
    return groupedLogCount
    }
    NSLog("TBT: There was nothing in the blocklog, so GROUPED COUNT TODAY returned empty")
    return []
}

func clearBlockLog() {
    let realm = try! Realm(configuration: config)
    try! realm.write {
        let blockLog = realm.objects(BlockLogItem.self)
        realm.delete(blockLog)
    }
}


//MARK: - Lists

//userdefaults key for lists engine migration
let listsV2Key = "usesListsV2"

// add a single item to a given list
func addItemToList(url: String, userAdded: Bool = true, list: TulaList){
    var listItem: ListItem?
    
    if list == .allow {
        listItem = AllowListItem()
    } else if list == .block {
        listItem = BlockListItem()
    }
    
    listItem!.url = url
    listItem!.userAdded = userAdded
    
    let realm = try! Realm(configuration: config)
    
    try! realm.write({
        realm.add(listItem!, update: .modified)
    })
}

// add multiple items to a given list
func addItemsToList(urls: [String], userAdded: Bool = true, list: TulaList) {
    var urlList:[ListItem] = []
    
    if list == .allow {
        urlList = urls.map { url in
            var item = AllowListItem()
            item.url = url
            item.userAdded = userAdded
            
            return item
        }
    } else if list == .block {
        urlList = urls.map { url in
            var item = BlockListItem()
            item.url = url
            item.userAdded = userAdded
            
            return item
        }
    }
    
    let realm = try! Realm(configuration: config)
    
    try! realm.write({
        for item in urlList {
            realm.add(item, update: .modified)
        }
    })
}

// delete a specific item from a list
func deleteItemFromList(url: String, list: TulaList){
    let realm = try! Realm(configuration: config)
    
    try! realm.write({
        if list == .allow{
            let item = realm.object(ofType: AllowListItem.self, forPrimaryKey: url)
            
            realm.delete(item!)
        } else if list == .block {
            let item = realm.object(ofType: BlockListItem.self, forPrimaryKey: url)
            
            realm.delete(item!)
        }
    })
}

// clear a list
func clearList(list: TulaList){
    let realm = try! Realm(configuration: config)
    
    try! realm.write({
        if list == .allow {
            let selected = realm.objects(AllowListItem.self)
            realm.delete(selected)
        } else if list == .block {
            let selected = realm.objects(BlockListItem.self)
            realm.delete(selected)
        }
    })
}

// get a list as an array of urls
func getListArray(list: TulaList) -> [String]{
    let startTime = CFAbsoluteTimeGetCurrent()
    let realm = try! Realm(configuration: config)
    
    if list == .allow {
        let urls = realm.objects(AllowListItem.self)
        NSLog("TBT DB: \(urls.count) list items retrived in \(startTime - CFAbsoluteTimeGetCurrent())s")
        return urls.map({ i in
            return i.url
        })
        
    } else if list == .block {
        let urls = realm.objects(BlockListItem.self)
        NSLog("TBT DB: \(urls.count) list items retrived in \(startTime - CFAbsoluteTimeGetCurrent())s")
        return urls.map({ i in
            return i.url
        })
    }
    
    return []
}

// read urls from file in the bundle
func readItemsFromFile(bundlePath: String) -> [String] {
    var domains = [String]()
    
    guard let path = Bundle.main.path(forResource: bundlePath, ofType: "txt") else {
        return domains
    }
    
    do {
        let contents = try String(contentsOfFile: path)
        let lines = contents.components(separatedBy: "\n")
        for line in lines {
            if (line.trimmingCharacters(in: CharacterSet.whitespaces) != "" && !line.starts(with: "#")) && !line.starts(with: "\n") {
                domains.append(line)
                //NSLog("TBT DB: \(line) enabled on blocklog")
            }
        }
    }
    catch _ as NSError{
    }
    return domains
}

// read items from file outside bundle
func readItemsFromFile(fileURL: URL) -> [String] {
    var domains = [String]()
    
    do {
        if fileURL.startAccessingSecurityScopedResource() == true {
            let contents = try! String(contentsOfFile: fileURL.path)
            //NSLog("TBT Lists: Selected file - \(contents)")
            let lines = contents.components(separatedBy: "\n")
            for line in lines {
                if (line.trimmingCharacters(in: CharacterSet.whitespaces) != "" && !line.starts(with: "#")) && !line.starts(with: "\n") {
                    domains.append(line)
                    //NSLog("TBT DB: \(line) enabled on blocklog")
                }
            }
        } else {
            NSLog("TBT Lists ERROR: Permission not received to read file")
        }
        fileURL.stopAccessingSecurityScopedResource()
    }
    catch {
        NSLog("TBT Lists ERROR: \(error)")
    }
    return domains
}

// add items from a file to a list within the bundle
func addFileItemsToList(bundlePath: String, list: TulaList, userAdded: Bool = true, completion: @escaping () -> Void = {}) {
    let startTime = CFAbsoluteTimeGetCurrent()
    let fileItems = readItemsFromFile(bundlePath: bundlePath)
    
    addItemsToList(urls: fileItems, userAdded: userAdded, list: list)
    let time = CFAbsoluteTimeGetCurrent() - startTime
    NSLog("TBT DB: \(fileItems.count) list items added in \(time)s")
    completion()
}

// add items from a file to a list from outside the bundle
func addFileItemsToList(fileURL: URL, list: TulaList, userAdded: Bool = true, completion: @escaping () -> Void = {}) {
    let startTime = CFAbsoluteTimeGetCurrent()
    let fileItems = readItemsFromFile(fileURL: fileURL)
    
    addItemsToList(urls: fileItems, userAdded: userAdded, list: list)
    let time = CFAbsoluteTimeGetCurrent() - startTime
    NSLog("TBT DB: \(fileItems.count) list items added in \(time)s")
}

//setup tulabyte blocklist
func setupTulaByteBlockList() {
    addFileItemsToList(bundlePath: "blocklist", list: .block, userAdded: false)
}

//setup tulabyte allowlist
func setupTulaByteAllowList() {
    addFileItemsToList(bundlePath: "allowlist", list: .allow, userAdded: false)
}

// does domain exist in blocklist
func isDomainInList(url: String, list: TulaList) -> Bool {
    let start = CFAbsoluteTimeGetCurrent()
    
    let realm = try! Realm(configuration: config)
    
    if list == .allow {
        let allowlist = realm.objects(AllowListItem.self)
        
        let value = allowlist.where {
            ($0.url.ends(with: url)) || ($0.url == url)
        }
        
        if value.count >= 1 {
            return true
        }
        
    } else if list == .block {
        let blocklist = realm.objects(BlockListItem.self)
        
        let value = blocklist.where {
            ($0.url.ends(with: url)) || ($0.url == url)
        }
        
        if value.count >= 1 {
            return true
        }
    }
    
    NSLog("TBT DB: Checked \(url) in \(start - CFAbsoluteTimeGetCurrent())s")
    return false
}

//swap list
func swapList(url: String, toList: TulaList){
    if toList == .allow {
        deleteItemFromList(url: url, list: .block)
        addItemToList(url: url, list: .allow)
    } else if toList == .block {
        deleteItemFromList(url: url, list: .allow)
        addItemToList(url: url, list: .block)
    }
}


//MARK: - Monitor List
func addItemToMonitorList(url: String, timestamp: Date = Date(), list: TulaList = .other) {
    
    var listIndex: Int {
        switch list {
        case .allow:
            return 0
        case .block:
            return 1
        case .other:
            return 2
        }
    }
    
    let realm = try! Realm(configuration: config)
    
    let newItem = MonitorItem()
    newItem.url = url
    newItem.timestamp = timestamp
    newItem.list = listIndex
    
    try! realm.write {
        realm.add(newItem)
        NSLog("TBT REALM: Added \(url) to monitor list")
    }
}
