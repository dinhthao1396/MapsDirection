//
//  ListTypeTableViewController.swift
//  MapsDemo
//
//  Created by Tran Dinh Thao on 7/27/17.
//  Copyright © 2017 Tran Dinh Thao. All rights reserved.
//
// ok ok
import UIKit
import Alamofire
class ListTypeTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textFieldRadius: UITextField!
    
    var listType = [ListTypeModel]()
    var urlString = ""
    var dataToSendViaListButton = Int()
    var dataToSend = Int()
    var listCheckBox = [Int]()
    var dataFromButtonCheck  = Int()
    var dataRadius = ""
    var dataRadiusa = ""
    @IBOutlet var listTypeView: UITableView!
    
    
    
    @IBAction func clickToCheck(_ sender: UIButton) {
        dataFromButtonCheck = sender.tag
        
        if (sender.isSelected == true){
            var sum = 0
            sender.setBackgroundImage(UIImage(named: "checkbox12"), for: UIControlState.normal)
            if listCheckBox.count == 0 {
                listCheckBox.append(dataFromButtonCheck)
            }
            else{
                for value in listCheckBox[0..<listCheckBox.count]{
                    if value == dataFromButtonCheck {
                        sum = sum + 1
                    }
                }
                if sum == 0{
                    listCheckBox.append(dataFromButtonCheck)
                }
            }
            sender.isSelected = false
        }else{
            var sum = 0
            sender.setBackgroundImage(UIImage(named: "uncheckbox12"), for: UIControlState.normal)
            if listCheckBox.count > 0 {
                for i in 0..<listCheckBox.count {
                    if dataFromButtonCheck == listCheckBox[i] {
                        sum = sum + i
                    }
                    
                }
                listCheckBox.remove(at: sum)
            }
            sender.isSelected = true //Background
        }
        print(listCheckBox.count)
    }
    
    @IBAction func listButton(_ sender: UIButton) {
        dataToSendViaListButton = sender.tag
        choiceRadius()
    }
    
    @IBAction func maps(_ sender: UIButton) {
        dataToSend = sender.tag
        choiceRadius()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTypeView.delegate = self
        listTypeView.dataSource = self
        textFieldRadius.delegate = self
        let element1 = ListTypeModel(name: "Restaurant", value: 0)
        listType.append(element1)
        let element2 = ListTypeModel(name: "Hopital", value: 1)
        listType.append(element2)
        let element3 = ListTypeModel(name: "School", value: 2)
        listType.append(element3)
        let element4 = ListTypeModel(name: "Hotel", value: 3)
        listType.append(element4)
        let element5 = ListTypeModel(name: "Museum", value: 4)
        listType.append(element5)
        let element6 = ListTypeModel(name: "ATM", value: 5)
        listType.append(element6)
        let element7 = ListTypeModel(name: "Gas Station", value: 6)
        listType.append(element7)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show", style: .plain, target: self, action: #selector(ListTypeTableViewController.showChoice))
        textFieldRadius.resignFirstResponder()
        
        hideKeyboardWhenTappedAround() // keyboard don't hide
        
        textFieldRadius.clearsOnBeginEditing = true
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        textFieldRadius.resignFirstResponder() //don't work
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func testListToShow(title: String, content: String){
        let alert = UIAlertController(title: title, message: content , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
            print("User Click Ok To Choice Again")
        }))
        self.present(alert, animated:  true, completion: nil)
 
    }
    func choiceRadius(){
        textFieldRadius.resignFirstResponder()
        let numInTextField = textFieldRadius.text
        if let dataRadiusInt = Int(numInTextField!){
            if dataRadiusInt >= 5000 || dataRadiusInt <= 200 {
                testListToShow(title: "200 <= Radius <= 5000", content: "Please type again")
            }else{
                dataRadiusa = String(dataRadiusInt) //
            }
        }
        else{
            testListToShow(title: "Radius must to be number", content: "Please enter radius again")
        }
        self.listTypeView.reloadData()
    }
    
    func showChoice(){
        textFieldRadius.resignFirstResponder()
        let numInTextField = textFieldRadius.text
        if let dataRadiusInt = Int(numInTextField!){
            if dataRadiusInt >= 5000 || dataRadiusInt <= 1000 {
                testListToShow(title: "1000 <= Radius <= 5000", content: "Please type again")
            }
            if listCheckBox.count == 0{
                testListToShow(title: "Nothing To Show", content: "Please check some place you want to show")
            }else{
                dataRadius = String(dataRadiusInt) //
                print("data in textfield \(dataRadius)")
                performSegue(withIdentifier: "showChoice", sender: self)
            }
        }
        else{
            testListToShow(title: "Radius must to be number", content: "Please enter radius again")
        }
        self.listTypeView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listType.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellOfListType", for: indexPath) as! ListTypeTableViewCell
        cell.list.tag = indexPath.row
        cell.maps.tag = indexPath.row
        cell.checkBox.tag = indexPath.row
        let nameTypeCell = listType[indexPath.row]
        cell.setDataForCellType(name: nameTypeCell.nameType)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "connectToListDetail"){
            let secondViewController = segue.destination as! ListDetailTableViewController
            secondViewController.dataFromListType = self.dataToSendViaListButton
            secondViewController.dataRadius = self.dataRadiusa
            self.dataRadiusa = ""
        }
        if (segue.identifier == "showMapsNear"){
            let nextViewController = segue.destination as! MapsNearbyViewController
            nextViewController.dataRecevie = self.dataToSend
            nextViewController.dataRadius = self.dataRadiusa
        }
        if (segue.identifier == "showChoice"){
            let nextViewController = segue.destination as! MapsNearbyViewController
            nextViewController.listCheckBox = self.listCheckBox
            nextViewController.dataRadius = self.dataRadius
            self.dataRadius = ""
            self.listCheckBox.removeAll()
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
