//
//  TableViewController.swift
//  FinalTest
//
//  Created by Shirin Mansouri on 2021-12-16.
//

import UIKit

class TableViewController: UITableViewController {
    var datasource : [Bmi] = []
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            
            let decoder = JSONDecoder()
            let temp = UserDefaults.standard.data(forKey: "Bmi")!
            datasource = try decoder.decode([Bmi].self, from: temp)
            tableView.reloadData()
        }
        catch {
            print("Unable to Encode bmi (\(error))")
        }

        
    }
    
    
    @IBAction func btnAdd(_ sender: UIBarButtonItem) {
        
    }
    @IBAction func btnBackPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
        return section == 0 ? datasource.count : 1
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          let headerView = UILabel()
          headerView.text = "   Weight                        BMI                        Date   "
        headerView.font = UIFont(name:"FontAwesome",size:50)
          return headerView
      }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//
                    cell.textLabel?.font = UIFont(name:"FontAwesome",size:15)
            let cellContent = String(datasource[indexPath.row].weight) + "                        " + String(datasource[indexPath.row].calculatedBmi) +
        "               "
            +  datasource[indexPath.row].bmiDate
                    cell.textLabel?.text = cellContent
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                return cell
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    // redirect to the detail screen to edit or delete the Bmi
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let defaults=UserDefaults.standard
        let intIndex = indexPath.row // where intIndex < myDictionary.count
        let index = datasource.index(datasource.startIndex, offsetBy: intIndex)
        do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(datasource[index])
        defaults.set(data, forKey: "selectedBmi")
        }
    catch {
        
    }

        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            
            let refreshAlert = UIAlertController(title: "", message: "Are you Sure to Delete the BMI ? ", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [self] (action: UIAlertAction!) in
                 
                datasource.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .bottom)
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(datasource)
                     UserDefaults.standard.set(data, forKey: "Bmi")
                    if(datasource.count == 0)
                    {
                        self.dismiss(animated: true, completion: nil)
                    }
           
                }
                catch {
                    print("Unable to Encode bmi (\(error))")
                }
                
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in

            }))

            present(refreshAlert, animated: true, completion: nil)
            
        }
    }
 

}
