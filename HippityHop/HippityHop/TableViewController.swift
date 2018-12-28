//
//  TableViewController.swift
//  HippityHop
//
//  Created by Kim Do on 11/1/18.
//  Copyright © 2018 Gurpal Bhoot. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
   let context     = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   let saveContext = (UIApplication.shared.delegate as! AppDelegate).saveContext
   
   
   var items : [Record] = []
    override func viewDidLoad() {
        super.viewDidLoad()
      let recordRequest:NSFetchRequest<Record> = Record.fetchRequest()
      do {
            items = try context.fetch(recordRequest)
            items = items.sorted(by: {Int($0.score!)! > Int($1.score!)!})
         
      } catch {
            print(error)
      }
      
    }
   
   

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TaTableViewCell else { return UITableViewCell() }
        
        cell.nameLabel.text = items[indexPath.row].name
        cell.scoreLabel.text = items[indexPath.row].score
        cell.indexLabel.text = "\(indexPath.row+1)"
        
        // Configure the cell...

        return cell
    }
   
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      context.delete(items[indexPath.row])
      items.remove(at: indexPath.row)
      tableView.reloadData()
      saveContext()
   }
   @IBAction func goBackBtnClicked(_ sender: Any) {
      dismiss(animated: true, completion: nil)
   }
   
}
