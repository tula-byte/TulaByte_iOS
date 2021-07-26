//
//  TunnelController.swift
//  TulaByteiOS
//
//  Created by Arjun Singh on 28/1/21.
//  Modified from Lockdown Privacy -> FirewallController.swift by Confirmed, Inc.
//

import Foundation
import NetworkExtension
import CocoaLumberjackSwift

let tunnelLocalizedDescription = "TulaByte"

class TunnelController: NSObject {
    
    static let shared = TunnelController()
    
    var manager:NETunnelProviderManager?
    
    private override init() {
        super.init()
        refreshManager()
    }
    
    // flush manager reference and reset to managers[0]
    func refreshManager(completion: @escaping (_ error: Error?) -> Void = {_ in }) {
        // access all current managers
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            // if there are existing managers
            if let managers = managers, managers.count > 0 {
                // if the current manager is the same as the existing manager
                if self.manager == managers[0] {
                    // Don't delete the existing manager
                    DDLogInfo("Existing manager is the same as the one being created. Not Replacing.")
                    completion(nil)
                }
                // get rid of any preexisting reference to any managers for the manager variable
                self.manager = nil
                
                // tell it to reference the one that is already operational
                self.manager = managers[0]
            }
            // handle an error after doing all that
            completion(error)
        }
    }
    
    // get the current status of the VPN tunnel
    func tunnelStatus() -> NEVPNStatus {
        refreshManager()
        // if a manager exists
        if manager != nil {
            // return its current status
            return (manager?.connection.status)!
        } else {
            // return invalid
            return .invalid
        }
    }
    
    // delete the currently established tunnel manager and reset a new one
    func resetManager() {
        //refresh manager reference
        refreshManager { (error) in
            // set firewall installed value to false if any errors happen
            defaults.setValue(false, forKey: "firewallInstalled")
            defaults.synchronize()
            // remove the existing manager from settings
            self.manager?.removeFromPreferences(completionHandler: { (removalError) in
                // wait a second
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    // re-enable and thus reinstall profile
                    self.enableTunnel(true, isUserExplicitToggle: true)
                }
            })
        }
    }
    
    // delete the currently established tunnel manager and reset a new one
    func deleteManager() {
        //refresh manager reference
        refreshManager { (error) in
            // set firewall installed value to false if any errors happen
            defaults.setValue(false, forKey: "firewallInstalled")
            defaults.synchronize()
            // remove the existing manager from settings
            self.manager?.removeFromPreferences(completionHandler: { (removalError) in
                if removalError != nil {
                    NSLog("TBT: Error while deleting manager. \(String(describing: removalError))")
                } else {
                    NSLog("TBT: Manager Deleted.")
                }
            })
        }
    }
    
    // turn off the current connection, wait, and then turn it on again
    func restartTunnel(completion: @escaping (_ error: Error?) -> Void = {_ in }) {
        // disable tunnel
        TunnelController.shared.enableTunnel(false) { (disableError) in
            // if theres an error...
            if disableError != nil {
                // ...log it
                DDLogError("There was error disabling the tunnel and IDK what to do about it: \(disableError!)")
            }
            // wait to ensure that tunnel is actually closed
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                // then reenable
                TunnelController.shared.enableTunnel(true) { (enableError) in
                    // if theres an error...
                    if enableError != nil {
                        // ...log it
                        DDLogError("There was error enabling the tunnel and IDK what to do about it: \(enableError!)")
                    }
                    completion(enableError)
                }
            }
        }
    }
    
    // enable the firewall and establish all the settings that go with that
    func enableTunnel(_ enabled: Bool, isUserExplicitToggle: Bool = false, completion: @escaping (_ error: Error?) -> Void = {_ in }) {
        DDLogInfo("Firewall tunnel status: \(enabled)")
        
        defaults.setValue(true, forKey: "tunnelEnabled")
        
        // check if firewall profile has been installed
        if (defaults.value(forKey: "firewallInstalled") == nil) || (((defaults.value(forKey: "firewallInstalled")) != nil) == false) {
            defaults.setValue(true, forKey: "firewallInstalled")
            defaults.synchronize()
        }
        
        // check if user wanted change or if its software driven
        if isUserExplicitToggle {
            DDLogInfo("User requested tunnel state change to \(enabled)")
            // user wanted firewall enabled
            defaults.setValue(enabled, forKey: "userEnabledFirewall")
            defaults.synchronize()
        }
        
        //get list of current managers
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) in
            // if managers already exist
            if let managers = managers, managers.count > 0 {
                // set the manager reference to managers[0]
                self.manager = nil
                self.manager = managers[0]
            } else {
                // create a new reference and point it to the NETunnelProviderProtocol to handle configuration
                self.manager = nil
                self.manager = NETunnelProviderManager()
                self.manager!.protocolConfiguration = NETunnelProviderProtocol()
            }
            
            // set the tunnel description for setting to string from above
            self.manager!.localizedDescription = tunnelLocalizedDescription
            // the manager requires a server address to function, however this simply needs to be a dummy string since we're using the loopback IP address
            self.manager!.protocolConfiguration?.serverAddress = tunnelLocalizedDescription
            self.manager!.isEnabled = enabled // set status of tunnel based on the function variable
            self.manager!.isOnDemandEnabled = enabled // set background enable based on the function variable
            
            // establish the on demand connect rule. this allows tunnel to run regardless of network interface changes
            let connectRule = NEOnDemandRuleConnect()
            connectRule.interfaceTypeMatch = .any // connect to tunnel regardless of network type
            self.manager!.onDemandRules = [connectRule] // add this rule to the current manager
            
            // save config to system
            self.manager!.saveToPreferences { (error) in
                // check if there is an error specifically of the NEVPNError class
                if let e = error as? NEVPNError {
                    DDLogError("Error in the VPN manager while changing state to \(enabled): \(e)")
                    // if any of the following are found, break the switch
                    switch e.code {
                    case .configurationDisabled:
                        break;
                    case .configurationInvalid:
                        break;
                    case .configurationReadWriteFailed:
                        break;
                    case .configurationStale:
                        break;
                    case .configurationUnknown:
                        break;
                    case .connectionFailed:
                        break;
                    }
                }
                // if its a regular error, then just log it
                else if let e = error {
                    DDLogError("There was error saving the VPN config when changing state to \(enabled): \(e)")
                }
                // if nothing goes wrong
                else {
                    DDLogInfo("Succesfully saved the VPN state change to \(enabled)")
                    
                    // wait 1.5s
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        do {
                            // manually start the tunnel
                            try self.manager!.connection.startVPNTunnel()
                            let config = URLSessionConfiguration.default
                            config.requestCachePolicy = .reloadIgnoringLocalCacheData
                            config.urlCache = nil
                            let session = URLSession.init(configuration: config)
                            let url = URL(string: "https://example.com")
                            //connect to a dummy URL and see what happens
                            let task = session.dataTask(with: url!) { (data, response, error) in
                                return
                            }
                            task.resume()
                        }
                        // if there is an error then log it and go on your merry way
                        catch {
                            DDLogError("Unable to start the tunnel after saving: " + error.localizedDescription)
                        }
                    }
                    
                }
                // for good measure refresh manager references once more
                self.refreshManager(completion: { error in
                    completion(nil)
                })
            }
        }
    }
}
