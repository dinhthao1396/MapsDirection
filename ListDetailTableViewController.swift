//
//  ListDetailTableViewController.swift
//  MapsDemo
//
//  Created by Tran Dinh Thao on 7/27/17.
//  Copyright © 2017 Tran Dinh Thao. All rights reserved.
//
// ok ok ok
import UIKit
import Alamofire
class ListDetailTableViewController: UITableViewController {
    
    @IBOutlet var listDetailJSON: UITableView!
    @IBOutlet weak var indicatorJSON: UIActivityIndicatorView!
    
    var dataFromListType = Int()
    var tempStar = 0
    var tempEnd = 4
    var listJSONDetail = [ModelOfDirec]()
    var urlString = ""
    var dataToSendLat = Float()
    var dataToSendLng = Float()
    var dataRadius = ""
    var listAlamoClosure = [ModelLocation]()
    var refreshControlJSON : UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listDetailJSON.delegate = self
        listDetailJSON.dataSource = self
        listDetailJSON.estimatedRowHeight = 44.0
        listDetailJSON.rowHeight = UITableViewAutomaticDimension
        listDetailJSON.addSubview(refreshControlJSON)
        refreshControlJSON.tintColor = UIColor.orange
        refreshControlJSON.backgroundColor = UIColor.black
        
        refreshControlJSON.attributedTitle = NSAttributedString(string: "Load more information", attributes: [NSForegroundColorAttributeName : UIColor.red])
        refreshControlJSON.addTarget(self, action: #selector(ListDetailTableViewController.refreshData), for: UIControlEvents.valueChanged)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func loadDataToShowAlamo(){
            switch dataFromListType {
            case 0:
                urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=\(dataRadius)&type=restaurant&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
            case 1:
                urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=\(dataRadius)&type=hospital&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
            case 2:
                urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=\(dataRadius)&type=school&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
            case 3:
                urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=\(dataRadius)&type=hotel&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
            case 4:
                urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=\(dataRadius)&type=museum&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
            case 5:
                urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=\(dataRadius)&type=atm&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
            case 6:
                urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=\(dataRadius)&type=gas_station&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
            default:
                urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=10.7657374,106.67110279999997&radius=\(dataRadius)&type=restaurant&key=AIzaSyAIi4TJkiMAfZR3vUk_mptHDbB2QQboEAg"
                
            }
        print("I am printing from loadDataAlamo")
        print(urlString)
        //loadDataAlamo(url: urlString)
        getDataAlamofireClosure(url: urlString) { (listData) in
            self.listAlamoClosure = listData
        }
    }
    
    func refreshData(){
        self.tempStar = 0
        self.tempEnd = 4
        self.listAlamoClosure.removeAll()
        loadDataToShowAlamo()
        listDetailJSON.reloadData()
        refreshControlJSON.endRefreshing()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "connectToDirection"){
            let thirdViewController = segue.destination as! DirectionViewController
            thirdViewController.latDirection = Double(dataToSendLat)
            thirdViewController.lngDirection = Double(dataToSendLng)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset < -100 {
            refreshControlJSON.attributedTitle = NSAttributedString(string: "OK, Done", attributes: [NSForegroundColorAttributeName : UIColor.red])
        }else{
            refreshControlJSON.attributedTitle = NSAttributedString(string: "Load more information", attributes: [NSForegroundColorAttributeName : UIColor.red])
        }
        refreshControlJSON.tintColor = UIColor.orange
        refreshControlJSON.backgroundColor = UIColor.black
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOfSet = scrollView.contentOffset.y
        let maxOfset = scrollView.contentSize.height - scrollView.frame.size.height // wrong
        if maxOfset - currentOfSet <= 10 {
            print("load more data")
            indicatorJSON.startAnimating()
            self.loadDataToShowAlamo()
        }
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
        //print(self.listJSON.count)
        return listAlamoClosure.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellJSON", for: indexPath) as! ListDetalCellTableViewCell
        let element = listAlamoClosure[indexPath.row]
        dataToSendLat = Float(element.lat)!
        dataToSendLng = Float(element.lng)!
        cell.setDataDetailForCell(name: element.name, address: element.address)
        // Configure the cell...
        return cell
        
        
        
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
