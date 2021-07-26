//
//  ViewController.swift
//  tunnel
//
//  Created by Arjun Singh on 2/2/21.
//

import UIKit
import WidgetKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("TBT: Tunnel State - \(TunnelController.shared.tunnelStatus())")
        
        
        // update all the labels
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.refreshTable()
            self.updateLabels()
        }
        
        timeFormatter.timeStyle = .medium
        
        self.tblBlockLog.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        tblBlockLog.delegate = self
        tblBlockLog.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector:#selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: Notification.Name("BlockLogCleared"), object: nil)
    }
    
    
    //MARK: - VARIABLES
    let cellReuseIdentifier = "blockCell"
    var logData = [retrieveGroupedCount(), retrieveGroupedCountToday()]
    var countData = [retrieveBlockLog(), retrieveBlockLogToday()]
    let timeFormatter = DateFormatter()
    var statsMode = 0
    var statusText: NSMutableAttributedString {
        let greenAttr = [NSAttributedString.Key.foregroundColor: UIColor(named: "TulabyteGreen"), NSAttributedString.Key.font: UIFont.init(name: "Helvetica Neue Bold", size: 34.0)]
        let redAttr = [NSAttributedString.Key.foregroundColor: UIColor(named: "TulabyteRed"), NSAttributedString.Key.font: UIFont.init(name: "Helvetica Neue Bold", size: 34.0)]
        
        switch TunnelController.shared.tunnelStatus() {
        case .disconnected, .disconnecting:
            return NSMutableAttributedString(string: "Off", attributes: redAttr)
        case .connected, .connecting, .reasserting:
            return NSMutableAttributedString(string: "On", attributes: greenAttr)
        case .invalid:
            return NSMutableAttributedString(string: "Error", attributes: redAttr)
        @unknown default:
            return NSMutableAttributedString(string: "Unknown", attributes: redAttr)
        }}
    
    
    
    //MARK: - OUTLETS
    @IBOutlet weak var tglFirewallEnabled: UISwitch!
    @IBOutlet weak var tblBlockLog: UITableView!
    @IBOutlet weak var lblTrackerCount: UILabel!
    @IBOutlet weak var outShareView: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblTrackerCountHeader: UILabel!
    
    
    //MARK: - ACTIONS
    
    @IBAction func btnFirewallEnabled(_ sender: Any) {
        let toggleState = tglFirewallEnabled.isOn
        
        if (defaults.value(forKey: nwConnectedKey) as! Bool) == true {
            TunnelController.shared.enableTunnel(toggleState, isUserExplicitToggle: true)
            present(showLoadingIndicator(), animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.dismiss(animated: true, completion: nil)
                self.refreshTable()
                self.updateLabels()
            }
        } else {
            let ac = UIAlertController(title: "No Connection", message: "You need to enable either Wi-Fi or Mobile Data to change TulaByte's state. Please try again when you have a valid connection.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func scStatsMode(_ sender: TulaSC) {
        statsMode = sender.selectedSegmentIndex
        refreshTable()
        updateLabels()
    }
    
    
    //MARK:- TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if logData[statsMode].count == 0 {
            let message = """
                Nothing's been blocked yet!
                Start browsing and items
                will appear here.
                
                You can edit the Blocklist and Allowlist
                in Settings -> Modify Lists
                """
            self.tblBlockLog.setEmptyTableView(message: message)
        } else {
            self.tblBlockLog.restore()
        }
        
        return logData[statsMode].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = (self.tblBlockLog.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        cell = UITableViewCell(style: .value1, reuseIdentifier: cellReuseIdentifier)
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor(named: "TulabyteGreen")
        
        cell.textLabel?.text = self.logData[statsMode][indexPath.row].url
        cell.detailTextLabel?.text = "\(self.logData[statsMode][indexPath.row].count)"
        
        return cell
    }
    
    /*
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     let label = ["since startup", "today"]
     return "\(countData[statsMode].count) trackers blocked \(label[statsMode])"
     }
     */
    
    //MARK: - FUNCTIONS
    func updateLabels() {
        if ((defaults.value(forKey: "tunnelEnabled") != nil) == true) && ((TunnelController.shared.tunnelStatus() == .connected) || (TunnelController.shared.tunnelStatus() == .connecting))  {
            self.tglFirewallEnabled.isOn = true
        } else {
            self.tglFirewallEnabled.isOn = false
        }
        
        //lblFirewallStatus.text = statusText
        //lblFirewallStatus.textColor = statusColor
        
        let whiteAttr = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.init(name: "Helvetica Neue Bold", size: 34.0)]
        
        let titleString = NSMutableAttributedString(string: "TulaByte - ", attributes: whiteAttr)
        
        titleString.append(statusText)
        
        self.lblHeader.attributedText = titleString
        
        lblTrackerCount.text = countData[statsMode].count.roundedWithAbbreviations
        switch statsMode {
        case 0:
            lblTrackerCountHeader.text = "Trackers Blocked - All Time"
        case 1:
            lblTrackerCountHeader.text = "Trackers Blocked - Today"
        default:
            break
        }
    }
    
    func refreshTable(){
        logData = [retrieveGroupedCount(), retrieveGroupedCountToday()]
        tblBlockLog.reloadData()
    }
    
    @objc func applicationWillEnterForeground(_ application: UIApplication) {
        refreshTable()
        updateLabels()
    }
    
}

