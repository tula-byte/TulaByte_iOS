//
//  TunnelUtilities.swift
//  TulaByteiOS
//
//  Created by Arjun Singh on 1/2/21.
//

import Foundation

//MARK: - GLOBAL
//VARIABLES
let testFirewallDomain = "example.com"
let defaults = UserDefaults.shared

//FUNCTIONS
func clearList(dKey: String) {
    defaults.setValue(Dictionary<String, Bool>(), forKey: dKey)
}

func addCustomList(dKey: String, newDomains: Dictionary<String, Bool>){
    let oldDomains = getAllowlistDict(dKey: dKey)
    
    let domains = oldDomains.merging(newDomains, uniquingKeysWith: { old, _ in old })
    
    defaults.set(domains, forKey: dKey)
    defaults.synchronize()
}

func disableListDomain(dKey: String, domain: String){
    setAllowlistDomain(dKey: dKey, domain: domain, enabled: false)
}

//MARK: - ALLLOWLIST

// CONSTANTS
let tulabyteAllowlistKey = "tulabyteAllowlist"

// FUNCTIONS
func setupTulaByteAllowlist() {
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "aiv-cdn.net")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "akamaihd.net")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "akamaized.net")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "amazon.com") // This domain is not used for tracking (the tracker amazon-adsystem.com is blocked), but it does sometimes stop users from viewing Amazon reviews. Users may un-whitelist this if they wish.
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "api.twitter.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "apple-cloudkit.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "apple.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "apple.news")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "archive.is")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "att.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "att.com.edgesuite.net")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "att.net")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "bamgrid.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "brightcove.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "cbs.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "cbsaavideo.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "cbsi.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "cbsi.video")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "cbsnews.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "cdn-apple.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "cloudfront.net")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "cloudfront.net")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "coinbase.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "comcast.net")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "confirmedvpn.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "creditkarma.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "digicert.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "disney-plus.net")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "disneyplus.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "ebtedge.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "espn.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "fastly.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "fastly.net")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "firstdata.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "gamestop.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "go.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "googlevideo.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "hbc.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "hbo.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "hbomax.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "houzz.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "hulu.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "huluim.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "icloud-content.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "icloud.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "kroger.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "letsencrypt.org")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "lowes.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "lync.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "m.twitter.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "marcopolo.me")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "mbanking-services.mobi")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "microsoft.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "mobile.twitter.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "mzstatic.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "nbcuni.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "netflix.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "nflxvideo.net")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "office.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "office.net")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "office365.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "outlook.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "peacocktv.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "quibi.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "quickplay.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "saks.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "saksfifthavenue.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "skype.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "skypeforbusiness.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "slickdeals.net")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "southwest.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "spotify.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "stan.com.au")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "stan.video")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "syncbak.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "t.co")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "tapbots.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "tapbots.net")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "telegram.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "teslamotors.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "ttvnw.net")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "twimg.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "twitter.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "uplynk.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "usbank.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "verisign.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "vudu.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "xfinity.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "youtube.com")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "zoom.us")
    setAllowlistDomain(dKey: tulabyteAllowlistKey, domain:  "nianticlabs.com")
}

func setAllowlistDomain(dKey: String, domain: String, enabled: Bool = true) {
    var domains = getAllowlistDict(dKey: dKey)
    
    if domains[domain] == nil {
        domains[domain] = enabled
    } else if domains[domain] != nil {
        domains[domain] = enabled
    }
    
    defaults.set(domains, forKey: dKey)
    defaults.synchronize()
}

func getAllowlistDict(dKey: String) -> Dictionary<String, Any> {
    if let domains = defaults.dictionary(forKey: dKey) {
        return domains
    }
    return Dictionary()
}

func getAllowlistArray() -> Array<String> {
    let tulabyteAllowlist = getAllowlistDict(dKey: tulabyteAllowlistKey)
    var domains = Array<String>()
    
    for (key, value) in tulabyteAllowlist {
        if (value as! Int) == 1 {
            domains.append(key)
        }
    }
    
    if domains.count < 1 {
        NSLog("TBT Allowlist: Nothing was added")
    }
    
    return domains
}

//MARK: - BLOCKLIST

//CONSTANTS
let tulabyteBlocklistKey = "tulabyteBlocklist"
let defaultBlockCategories = [clickbait, crypto, trackers, facebookSoft, games, ads, marketing1, marketing2, ransomware]

//block categories
let clickbait = "clickbait"
let crypto = "crypto_mining"
let trackers = "data_trackers"
let email = "email_opens"
let facebookHard = "facebook_inc"
let facebookSoft = "facebook_sdk"
let games = "game_ads"
let ads = "general_ads"
let googleShopping = "google_shopping_ads"
let marketing1 = "marketing"
let marketing2 = "marketing_beta"
let ransomware = "ransomware"
let reporting = "reporting"
let snapchat = "snapchat_analytics"
let master = "blocklist"

//FUNCTIONS
func getBlocklistDomains(filename: String, enabled: Bool = true) -> Dictionary<String, Bool> {
    var domains = [String : Bool]()
    
    guard let path = Bundle.main.path(forResource: filename, ofType: "txt") else {
        return domains
    }
    
    do {
        let contents = try String(contentsOfFile: path)
        let lines = contents.components(separatedBy: "\n")
        for line in lines {
            if (line.trimmingCharacters(in: CharacterSet.whitespaces) != "" && !line.starts(with: "#")) && !line.starts(with: "\n") {
                domains[line] = enabled
                NSLog("TBT DB: \(line) enabled on blocklog")
            }
        }
    }
    catch _ as NSError{
    }
    return domains
}

func setupTulaByteBlocklist() {
    var domains = [String: Bool]()
    
    /*
    for category in defaultBlockCategories {
        let newDomains = getBlocklistDomains(filename: category)
        domains.merge(newDomains){(_, new) in new}
    }
 */
    let newDomains = getBlocklistDomains(filename: master)
    domains.merge(newDomains){(_, new) in new}
    
    defaults.set(domains, forKey: tulabyteBlocklistKey)
    defaults.synchronize()
}

func getBlocklistDict(dKey: String) -> Dictionary<String, Any> {
    if let domains = defaults.dictionary(forKey: dKey) {
        return domains
    }
    return Dictionary()
}

func getBlocklistArray() -> Array<String> {
    let tulabyteBlocklist = getBlocklistDict(dKey: tulabyteBlocklistKey)
    var domains = Array<String>()
    
    for (key, value) in tulabyteBlocklist {
        if (value as! Int) == 1 {
            domains.append(key)
        }
    }
    
    if domains.count < 1 {
        NSLog("TBT Blocklist: Nothing was added")
    }
    
    return domains
}

//MARK:- CLASS EXTENSIONS
extension UserDefaults {
    static var shared: UserDefaults {
        return UserDefaults(suiteName: "group.com.tulabyte.tulabyte")!
    }
}

extension UserDefaults {
    func incrementIntForKey(key:String, by: Int) {
        let int = integer(forKey: key)
        set(int + by, forKey:key)
    }
}

extension UserDefaults {
    func appendToArray(key: String, value: Any) {
        var list = array(forKey: key) ?? []
        set(list.append(value), forKey: key)
    }
}

