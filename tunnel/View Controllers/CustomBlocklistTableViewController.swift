//
//  CustomBlocklistTableViewController.swift
//  tunnel
//
//  Created by Arjun Singh on 16/6/21.
//

import UIKit
import UniformTypeIdentifiers
import MobileCoreServices

class CustomBlocklistTableViewController: UITableViewController, UIDocumentPickerDelegate, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", image: nil, primaryAction: nil, menu: editMenu)
        navigationItem.largeTitleDisplayMode = .never
        
        searchBar.delegate = self
        
        filteredListArray = listArray
    }
    
    // MARK: - Variables
    var userSelectedBlockListURL:URL?
    
    var selectedListTitle: String {
        switch scListOption.selectedSegmentIndex {
        case 0:
            return "Block"
        case 1:
            return "Allow"
        default:
            break
        }
        return ""
    }
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Add \(selectedListTitle) URL", image: UIImage(systemName: "plus"), handler: {
                (_) in
                self.addSingleItemToList()
            }),
            UIAction(title: "Add \(selectedListTitle)list File", image: UIImage(systemName: "doc"), handler: {
                (_) in
                self.setupCustomBlocklist()
            }),
            UIAction(title: "Reset \(selectedListTitle)list", image: UIImage(systemName: "arrow.counterclockwise"), handler: {
                (_) in
                self.resetChosenList()
            }),
            UIAction(title: "Clear \(selectedListTitle)list", image: UIImage(systemName: "trash"), attributes: .destructive,  handler: {
                (_) in
                self.clearChosenList()
            }),
            UIAction(title: "Help", image: UIImage(systemName: "questionmark.circle")) { _ in
                UIApplication.shared.open(URL(string: "https://info.tulabyte.com/lists-guide")!)
            }
        ]
    }
    
    var editMenu: UIMenu {
        return UIMenu(title: "Long press any URL in the list to see more options", children: menuItems)
    }
    
    var listArray: [String] {
        switch scListOption.selectedSegmentIndex {
        case 0:
            return getBlocklistArray()
        case 1:
            return getAllowlistArray()
        default:
            return []
        }
    }
    
    var filteredListArray:[String]!
    
    // MARK: - Outlets
    @IBOutlet weak var scListOption: TulaSC!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Actions
    @IBAction func btnSegmentedControlChanged(_ sender: Any) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", image: nil, primaryAction: nil, menu: editMenu)
        filteredListArray = listArray
        tableView.reloadData()
    }
    
    // MARK: - Functions
    
    // handle file picker display and then handoff to document picked function to complete
    @available(iOS 14.0, *)
    func setupCustomBlocklist() {
        let types = UTType.types(tag: "txt", tagClass: UTTagClass.filenameExtension, conformingTo: nil)
        let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: types)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
    }
    
    // add a single domain to the chosen list
    func addSingleItemToList() {
        let ac = UIAlertController(title: "Add \(selectedListTitle) URL", message: "Enter a URL you would like to \(selectedListTitle.lowercased()).", preferredStyle: .alert)
        ac.addTextField { textfield in
            textfield.placeholder = "example.com"
            textfield.keyboardType = .URL
        }
        
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            let newURL = (ac.textFields![0] as UITextField).text
            var key:String = ""
            
            switch self.scListOption.selectedSegmentIndex{
            case 0:
                key = tulabyteBlocklistKey
            case 1:
                key = tulabyteAllowlistKey
            default:
                key = ""
            }
            
            setAllowlistDomain(dKey: key, domain: newURL!)
            
            TunnelController.shared.restartTunnel()
            self.shortLoad()
            
            self.filteredListArray = self.listArray
            self.tableView.reloadData()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true, completion: nil)
    }
    
    // reset the chosen list
    func resetChosenList(){
        let ac = UIAlertController(title: "Reset \(selectedListTitle)list", message: "This will delete all custom URLs and reset the \(selectedListTitle)list to the TulaByte default", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        ac.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { action in
            switch self.scListOption.selectedSegmentIndex {
            case 0:
                clearList(dKey: tulabyteBlocklistKey)
                setupTulaByteBlocklist()
            case 1:
                clearList(dKey: tulabyteAllowlistKey)
                setupTulaByteAllowlist()
            default:
                print("doing nothing")
            }
            TunnelController.shared.restartTunnel()
            self.shortLoad()
            
            self.filteredListArray = self.listArray
            self.tableView.reloadData()
        }))
        
        present(ac, animated: true, completion: nil)
    }
    
    // reset the chosen list
    func clearChosenList(){
        let ac = UIAlertController(title: "Clear \(selectedListTitle)list", message: "This will delete all URLs and completely clear the \(selectedListTitle)list", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        ac.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { action in
            switch self.scListOption.selectedSegmentIndex {
            case 0:
                clearList(dKey: tulabyteBlocklistKey)
            case 1:
                clearList(dKey: tulabyteAllowlistKey)
            default:
                print("doing nothing")
            }
            TunnelController.shared.restartTunnel()
            self.shortLoad()
            
            self.filteredListArray = self.listArray
            self.tableView.reloadData()
        }))
        
        present(ac, animated: true, completion: nil)
    }
    
    func shortLoad() {
        present(showLoadingIndicator(), animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Search Bar Functions
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredListArray = searchText.isEmpty ? listArray : listArray.filter({ (searchTerm: String) -> Bool in
            //check whether an element contains the search term and return a boolean to confirm this
            return searchTerm.range(of: searchText, options: .caseInsensitive) != nil
        })
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.filteredListArray = self.listArray
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.tableView.reloadData()
    }
    
    // MARK: - Document Picker Functions
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        userSelectedBlockListURL = myURL
        
        if self.userSelectedBlockListURL != nil {
            var newDomains = Dictionary<String, Bool>()
            
            do {
                if userSelectedBlockListURL?.startAccessingSecurityScopedResource() == true {
                    let contents = try String(contentsOfFile: self.userSelectedBlockListURL!.path)
                    NSLog("TBT Lists: Selected file - \(contents)")
                    let lines = contents.components(separatedBy: "\n")
                    for line in lines {
                        if (line.trimmingCharacters(in: CharacterSet.whitespaces) != "" && !line.starts(with: "#")) && !line.starts(with: "\n") {
                            newDomains[line] = true
                            NSLog("TBT DB: \(line) enabled on blocklog")
                        }
                    }
                } else {
                    NSLog("TBT Lists ERROR: Permission not received to read file")
                }
                userSelectedBlockListURL?.stopAccessingSecurityScopedResource()
            }
            catch{
                NSLog("TBT Lists ERROR: \(error)")
            }
            NSLog("TBT Lists: \(newDomains)")
            self.shortLoad()
            
                
                switch self.scListOption.selectedSegmentIndex{
                case 0:
                    DispatchQueue.global(qos: .utility).async {
                        addCustomList(dKey: tulabyteBlocklistKey, newDomains: newDomains)
                    }
                case 1:
                    DispatchQueue.global(qos: .utility).async {
                        addCustomList(dKey: tulabyteAllowlistKey, newDomains: newDomains)
                    }
                default:
                    break
                }
                
                DispatchQueue.main.async {
                    TunnelController.shared.restartTunnel()
                    
                    self.filteredListArray = self.listArray
                    self.tableView.reloadData()
                }
        } else {
            NSLog("TBT Lists: User didnt select anything")
        }
    }
    
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view functions
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredListArray.count == 0 {
            let message = """
                Your \(selectedListTitle)list is empty.
                
                You can add domains by pressing
                the Edit button above.
                """
            self.tableView.setEmptyTableView(message: message)
        } else {
            self.tableView.restore()
        }
        
        return filteredListArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = filteredListArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let i = indexPath.row
        let domain = filteredListArray[i]
        
        var key:String {
            switch scListOption.selectedSegmentIndex{
            case 0:
                return tulabyteBlocklistKey
            case 1:
                return tulabyteAllowlistKey
            default:
                return ""
            }
        }
        
        var oppositeKey:String {
            switch scListOption.selectedSegmentIndex{
            case 0:
                return tulabyteAllowlistKey
            case 1:
                return tulabyteBlocklistKey
            default:
                return ""
            }
        }
        
        var oppositeListTitle: String {
            switch scListOption.selectedSegmentIndex {
            case 0:
                return "Allow"
            case 1:
                return "Block"
            default:
                break
            }
            return ""
        }
        
        let id = "\(domain)" as NSString
        
        return UIContextMenuConfiguration (
            identifier: id,
            previewProvider: nil) { _ in
            
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                disableListDomain(dKey: key, domain: self.listArray[self.listArray.firstIndex(of: domain)!])
                
                self.filteredListArray = (self.searchBar.text == "") ? self.listArray : self.listArray.filter({ (searchTerm: String) -> Bool in
                    //check whether an element contains the search term and return a boolean to confirm this
                    return searchTerm.range(of: self.searchBar.text!, options: .caseInsensitive) != nil
                })
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadData()
                TunnelController.shared.restartTunnel()
            }
            
            let swapListAction = UIAction(title: "Move to \(oppositeListTitle)list", image: UIImage(systemName: "arrow.left.arrow.right")) { _ in
                setAllowlistDomain(dKey: oppositeKey, domain: self.listArray[self.listArray.firstIndex(of: domain)!])
                
                disableListDomain(dKey: key, domain: self.listArray[self.listArray.firstIndex(of: domain)!])
                
                self.filteredListArray = (self.searchBar.text == "") ? self.listArray : self.listArray.filter({ (searchTerm: String) -> Bool in
                    //check whether an element contains the search term and return a boolean to confirm this
                    return searchTerm.range(of: self.searchBar.text!, options: .caseInsensitive) != nil
                })
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableView.reloadData()
                TunnelController.shared.restartTunnel()
            }
           
            return UIMenu(title: "", image: nil, children: [swapListAction, deleteAction])
        }
        
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
