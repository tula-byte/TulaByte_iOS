//
//  PacketTunnelProvider.swift
//  TulaByte Tunnel Provider
//
//  Created by Arjun Singh on 29/1/21.
//
import Foundation
import NetworkExtension
import CocoaLumberjackSwift
import CocoaLumberjackSwiftLogBackend

class TulaByteTunnelObserverFactory: ObserverFactory {
    
    override func getObserverForProxySocket(_ socket: ProxySocket) -> Observer<ProxySocketEvent>? {
        return TunnelProxySocketObserver();
    }
    
    class TunnelProxySocketObserver: Observer<ProxySocketEvent> {
        override func signal(_ event: ProxySocketEvent) {
            switch event {
            case .receivedRequest(let session, let socket):
                if (session.host == testFirewallDomain) {
                    NSLog("TBT BLOCKER:" + session.host + "BLOCKED")
                    socket.forceDisconnect()
                    return
                }
                
                /*
                for domain in allowlistDomains {
                    if (session.host.hasSuffix("." + domain) || session.host == domain) {
                        print("TBT ALLOWED:" + session.host)
                        return
                    }
                }
                 */
                
                if isDomainInList(url: session.host, list: .allow) {
                    return
                }
                
                if (defaults.value(forKey: "userEnabledFirewall") != nil) == true {
                    if isDomainInList(url: session.host, list: .block) {
                        addBlockLogItem(url: session.host)
                        NSLog("TBT BLOCKER:" + session.host + "BLOCKED")
                        socket.forceDisconnect()
                        return
                    }
                }
                print("TBT BLOCKER: \(session.host) ALLOWED")
                return
                
            default:
                break
            }
        }
        
    }
    
}


class PacketTunnelProvider: NEPacketTunnelProvider {
    
    let proxyServerPort: UInt16 = 9090;
    let proxyServerAddress = "127.0.0.1";
    var proxyServer: GCDHTTPProxyServer!
    
    override func startTunnel(options: [String : NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        if proxyServer != nil {
            proxyServer.stop()
        }
        
        proxyServer = nil
        
        NSLog("TBT: startTunnel called")
        
        self.connect(options: options, completionHandler: completionHandler)
    }
    
    private func connect(options: [String: NSObject]?, completionHandler: @escaping (Error?) -> Void) {
        
        let settings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: proxyServerAddress)
        settings.mtu = NSNumber(value: 1500)
        
        let proxySettings = NEProxySettings()
        proxySettings.httpEnabled = true
        proxySettings.httpServer = NEProxyServer(address: proxyServerAddress, port: Int(proxyServerPort))
        proxySettings.httpsEnabled = true
        proxySettings.httpsServer = NEProxyServer(address: proxyServerAddress, port: Int(proxyServerPort))
        proxySettings.excludeSimpleHostnames = false
        proxySettings.exceptionList = []
        
        /*
        var combinedList: Array<String> = getListArray(list: .block) + [testFirewallDomain] + [""] 
        combinedList = combinedList + getListArray(list: .allow)
         */
        let combinedList: Array<String> = [testFirewallDomain, ""]
        
        if combinedList.count <= 1 {
            NSLog("TBT: There wasn't anything in the blocklist or allowlist, so tunnel couldnt be established.")
            print("Combined list empty")
            completionHandler(NEVPNError(.configurationInvalid))
            return
        }
        
        proxySettings.matchDomains = combinedList
        
        settings.dnsSettings = NEDNSSettings(servers: ["127.0.0.1"])
        settings.proxySettings = proxySettings;
        
        RawSocketFactory.TunnelProvider = self
        ObserverFactory.currentFactory = TulaByteTunnelObserverFactory()
        
        self.setTunnelNetworkSettings(settings, completionHandler: { error in
            guard error == nil else {
                NSLog("TBT: Error setting tunnel network settings \(error as Any)")
                completionHandler(error)
                return
            }
            self.proxyServer = GCDHTTPProxyServer(address: IPAddress(fromString: self.proxyServerAddress), port: Port(port: self.proxyServerPort))
            do {
                try self.proxyServer.start()
                NSLog("TBT: Proxy server started")
                completionHandler(nil)
            } catch let proxyError {
                NSLog("TBT: Error starting proxy server \(proxyError)")
                completionHandler(proxyError)
            }
        })
    }
    
    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        DNSServer.currentServer = nil
        RawSocketFactory.TunnelProvider = nil
        ObserverFactory.currentFactory = nil
        proxyServer.stop()
        proxyServer = nil
        NSLog("TBT: TulaByte Tunnel: error on stopping: \(reason.debugDescription)")
        
        completionHandler()
        exit(EXIT_SUCCESS)
    }
    
    override func cancelTunnelWithError(_ error: Error?) {
        super.cancelTunnelWithError(error)
        NSLog("TBT: Packet tunnel provider cancelled with error: \(error as Any)")
    }
    
}

extension NEProviderStopReason: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        switch self {
        case .none:
            return "none"
        case .userInitiated:
            return "userInitiated"
        case .providerFailed:
            return "providerFailed"
        case .noNetworkAvailable:
            return "noNetworkAvailable"
        case .unrecoverableNetworkChange:
            return "unrecoverableNetworkChange"
        case .providerDisabled:
            return "providerDisabled"
        case .authenticationCanceled:
            return "authenticationCanceled"
        case .configurationFailed:
            return "configurationFailed"
        case .idleTimeout:
            return "idleTimeout"
        case .configurationDisabled:
            return "configurationDisabled"
        case .configurationRemoved:
            return "configurationRemoved"
        case .superceded:
            return "superceded"
        case .userLogout:
            return "userLogout"
        case .userSwitch:
            return "userSwitch"
        case .connectionFailed:
            return "connectionFailed"
        case .sleep:
            return "sleep"
        case .appUpdate:
            return "appUpdate"
        @unknown default:
            return "UNKNOWN - PLEASE CHECK APPLE DOCUMENTATION"
        }
    }
}
