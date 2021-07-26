//
//  DirectoryViewController.swift
//  tunnel
//
//  Created by Arjun Singh on 30/3/21.
//

import UIKit

class DirectoryViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
       
        self.tableView.dequeueReusableCell(withIdentifier: cellId)
        self.tableView.register(UITableViewHeaderFooterView.self,
               forHeaderFooterViewReuseIdentifier: "sectionHeader")
    }
    //variables
    var madeByUsArray = directoryItems.filter { $0.madeByUs == true }
    var friendsArray = directoryItems.filter { $0.madeByUs == false }
    let cellId = "directoryCell"
    
    //table view sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return madeByUsArray.count
        case 1:
            return friendsArray.count
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let s = indexPath.section
        let r = indexPath.row
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17.0)
        cell.detailTextLabel?.textColor = UIColor.white.withAlphaComponent(0.8)
        cell.detailTextLabel?.numberOfLines = 3
        cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: 15.0)
        cell.imageView?.image = UIImage(systemName: "link")
        
        switch s {
        case 0:
            cell.textLabel?.text = madeByUsArray[r].title
            cell.detailTextLabel?.text = madeByUsArray[r].description
        case 1:
            cell.textLabel?.text = friendsArray[r].title
            cell.detailTextLabel?.text = friendsArray[r].description
        default:
            cell.textLabel?.text = "error"
            cell.detailTextLabel?.text = "houston we have a problem"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = indexPath.section
        let r = indexPath.row
        
        switch s {
        case 0:
            UIApplication.shared.open(madeByUsArray[r].url)
        case 1:
            UIApplication.shared.open(friendsArray[r].url)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var title: String {
            switch section {
            case 0:
                return "Made By Us"
            case 1:
                return "What We Use"
            default:
                return "Error"
            }
        }
        
        /*
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 3, y: 3, width: headerView.frame.width - 6, height: headerView.frame.height - 6)
        label.text = title.uppercased()
        label.font = UIFont(name: "Helvetica Neue Medium", size: 15.0)
        label.textColor = UIColor(named: "TulabyteGreen")
        
        headerView.addSubview(label)
        */
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader")
        headerView?.textLabel?.textColor = UIColor.lightGray
        headerView?.textLabel?.text = title
        
        return headerView
    }
    
}
