 //
//  Util.swift
//  MapsDemo
//
//  Created by Tran Dinh Thao on 7/27/17.
//  Copyright © 2017 Tran Dinh Thao. All rights reserved.
//

import UIKit
import Alamofire
class Util: NSObject {

}
extension UIImageView {
    func downLoadFromUrlDemoSimple(urlSimple: String){
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string: urlSimple )!)
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        
    }
}
 
 extension UITableViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UITableViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
 }
 
 extension UITableViewController{
    
 func getDataAlamofireClosure(url: String, completion: @escaping ([ModelLocation]) -> Void){
    
    Alamofire.request(url)
        .validate()
        .responseJSON{ response in
            
            if response.result.isSuccess {
                print("JSON Link Available")
            }else{
                print("Data From Link Not Available")
                print("Error: \(String(describing: response.result.error))")
                completion([ModelLocation]())
                return
            }
            
            guard let jsonData = response.result.value as? [String: Any],
                let results = jsonData["results"] as? [[String: Any]] else {
                    print("Data Not Available")
                    completion([ModelLocation]())
                    return
            }
            
            let list = results.flatMap({ (dict) -> ModelLocation? in
                guard let name = dict["name"] as? String ,
                    let address = dict["vicinity"] as? String ,
                    let urlImage = dict["icon"] as? String ,
                    let arrayLocation = dict["geometry"] as? [String: Any],
                    let location = arrayLocation["location"] as? [String: Double],
                    let lat = location["lat"],
                    let lng = location["lng"] else {return nil}
                return ModelLocation(name: name, address: address, lat: Float(lat), lng: Float(lng), url: urlImage)
                
            })
            completion(list)
            self.tableView.reloadData()
    }
    
 }
 }

 extension UIViewController{
    
    func getDataAlamofireClosureView(url: String, completion: @escaping ([ModelLocation]) -> Void){
        
        Alamofire.request(url)
            .validate()
            .responseJSON{ response in
                
                if response.result.isSuccess {
                    print("JSON Link Available")
                }else{
                    print("Data From Link Not Available")
                    print("Error: \(String(describing: response.result.error))")
                    completion([ModelLocation]())
                    return
                }
                
                guard let jsonData = response.result.value as? [String: Any],
                    let results = jsonData["results"] as? [[String: Any]] else {
                        print("Data Not Available")
                        completion([ModelLocation]())
                        return
                }
                
                let list = results.flatMap({ (dict) -> ModelLocation? in
                    guard let name = dict["name"] as? String ,
                        let address = dict["vicinity"] as? String ,
                        let urlImage = dict["icon"] as? String ,
                        let arrayLocation = dict["geometry"] as? [String: Any],
                        let location = arrayLocation["location"] as? [String: Double],
                        let lat = location["lat"],
                        let lng = location["lng"] else {return nil}
                    return ModelLocation(name: name, address: address, lat: Float(lat), lng: Float(lng), url: urlImage)
                    
                })
                completion(list)
                self.view.reloadInputViews()
        }
        
    }
 }
