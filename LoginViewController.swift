//
//  LoginViewController.swift
//  MapsDemo
//
//  Created by Tran Dinh Thao on 8/10/17.
//  Copyright © 2017 Tran Dinh Thao. All rights reserved.
//

import UIKit
import CoreData
class LoginViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [UserInformations] = []
    var filteredData: [UserInformations] = []
    var flag = 0
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!

    @IBAction func loginButton(_ sender: Any) {
        checkTextFieldIsEmpty()
        checkAccount()
        fetchData()
        for value in items[0..<items.count] {
            print("aaaaaaaaaaaaaaaaaaaaaa")
            print(value.name!)
            print(value.pass!)
            print("bbbbbbbbbbbbbbbbbbbbbbbbbb")
        }
        //filteredData = items.filter { ($0.name?.lowercased().contains(searchText.lowercased()))! }

    }
    
    func checkTextFieldIsEmpty(){
        let userEmail = self.userNameTextField.text
        let firstPass = self.passTextField.text
        //let secondPass = self.secondPassTextFeld.text
        if (userEmail! == "" || firstPass! == "" ) {
            showAlertWarning(title: "OMG", content: "Pls, enter your account")
        }
    }
    
    func checkAccount(){
        
        let userEmail = self.userNameTextField.text
        let userPass = self.passTextField.text
        print("CCCCCCCCCCCCCCCCCC")
        print(userEmail!)
        print(userPass!)
         print("CCCCCCCCCCCCCCCCCC")
        //filteredData = items.filter { ($0.name?.lowercased().contains((userEmail?.lowercased())!))! }
            for value in items[0..<items.count] {
                if value.name == userEmail! {
                    if value.pass == userPass!{
                        flag = flag + 1
                    }
                }
            }
        
        if flag == 1 {
            self.navigationController?.isNavigationBarHidden = true
            performSegue(withIdentifier: "loginSuccess", sender: self)
            flag = 0
        }else{
            showAlertWarning(title: "Login Fail", content: "Pass or user name is wrong")
            flag = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAroundInView()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        self.navigationController?.isNavigationBarHidden = true
        //self.navigationController!.navigationBar.isHidden = true
    }
    
    

    
    func fetchData() {
        
        do {
            items = try context.fetch(UserInformations.fetchRequest())
            //filteredData = items
            DispatchQueue.main.async {
                self.view.reloadInputViews()
            }
        } catch {
            print("Couldn't Fetch Data")
            print("Maybe No data to fetch")
        }
        
    }
    
    func showAlertWarning(title: String, content: String){
        let alert = UIAlertController(title: title, message: content , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
            print("User Click Ok To Choice Again")
        }))
        self.present(alert, animated:  true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
