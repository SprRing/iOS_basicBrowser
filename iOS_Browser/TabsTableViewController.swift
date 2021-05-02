//
//  TabsTableViewController.swift
//  iOS_Browser
//
//  Created by Yen Shou on 3/20/21.
//

import UIKit
import RealmSwift

class TabsTableViewController: UITableViewController {
    
    var tabs = [Tab]()
    var delegate: ViewController!
    var selectTab: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func addTab(_ sender: UIButton) {
        let realm = try! Realm()
        let newTab: Tab = Tab()
        try! realm.write {
            realm.add(newTab)
        }
        print(newTab)
        tabs.append(newTab)
        selectTab = tabs.count - 1
        tableView.reloadData()
        delegate.addTab(newTab)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tabs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tab", for: indexPath) as! TabsTableViewCell
        
        let tab: Tab = tabs[indexPath.row]
        if (tab.title.isEmpty) {
            cell.title.text = "New Tab"
            cell.url.text = ""
        }
        else {
            cell.title.text = tab.title
            cell.url.text = tab.url
        }
        if (indexPath.row == selectTab) {
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.blue.cgColor
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row != selectTab) {
            delegate.selectedTab = indexPath.row
            delegate.loadWebView()
        }
        navigationController?.popViewController(animated: true)
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.row > 0) {
            return true
        }
        return false
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedTab: Tab = tabs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            delegate.deleteTab(deletedTab, indexPath.row)
        }
    }
    

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
