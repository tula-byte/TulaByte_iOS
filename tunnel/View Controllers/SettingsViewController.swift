//
//  SettingsViewController.swift
//  tunnel
//
//  Created by Arjun Singh on 30/3/21.
//

import UIKit


class SettingsViewController: UITableViewController, UIDocumentPickerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = indexPath.section
        let i = indexPath.row
        
        switch s {
        case 0:
            switch i {
            case 0:
                UIApplication.shared.open(URL(string: "https://apps.apple.com/account/subscriptions")!)
            case 1:
                UIApplication.shared.open(URL(string: "https://tulabyte.com/#donate")!)
            default:
                break
            }
            
        case 1:
            switch i {
            case 0:
                performSegue(withIdentifier: "settingsToAudience", sender: self)
            default:
                break
            }
            
        case 2:
            switch i {
            case 0:
                performSegue(withIdentifier: "showLists", sender: self)
            case 1:
                clearBlockLog()
                NotificationCenter.default.post(name: Notification.Name("BlockLogCleared"), object: nil)
                shortLoad()
            case 2:
                TunnelController.shared.resetManager()
                shortLoad()
            default:
                break
            }
            
        case 3:
            switch i {
            case 0:
                UIApplication.shared.open(URL(string: "https://info.tulabyte.com/faq")!)
            case 1:
                UIApplication.shared.open(URL(string: "https://tulabyte.com/#support")!)
            case 2:
                UIApplication.shared.open(URL(string: "https://info.tulabyte.com/privacy-policy")!)
            default:
                break
            }
            
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 2 {
            return
                """
                Manage Lists allows you to control what domains are blocked and allowed by TulaByte.
                
                Clear Log allows you to clear the URLs that are displayed in the block log. This action is irreversible.

                Reset Tunnel removes and reconfigures the TulaByte tunnel setup on your device. You should try this if the tunnel is behaving erratically.
                """
        } else {
            return ""
        }
    }
    
    //functions
    func shortLoad() {
        present(showLoadingIndicator(), animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    //unwind segue
    @IBAction func unwindToSettings(_ unwindSegue: UIStoryboardSegue) {}

}
