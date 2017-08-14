//
//  RegisterViewController.swift
//  MapsDemo
//
//  Created by Tran Dinh Thao on 8/10/17.
//  Copyright © 2017 Tran Dinh Thao. All rights reserved.
// aaaaaaaaaaa

import UIKit
import CoreData

class RegisterViewController: UIViewController, UITextFieldDelegate {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var items: [UserInformations] = []
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var secondPassTextFeld: UITextField!
    @IBOutlet weak var firstPassTextField: UITextField!
    
    
    @IBAction func registerButton(_ sender: Any) {
        checkTextFieldIsEmpty()
        checkPassWord()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate  = self
        secondPassTextFeld.delegate = self
        firstPassTextField.delegate = self
       // hideKeyboardWhenTappedAroundInView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkTextFieldIsEmpty(){
        let userEmail = self.userNameTextField.text
        let firstPass = self.firstPassTextField.text
        let secondPass = self.secondPassTextFeld.text
        if (userEmail! == "" || firstPass! == "" || secondPass! == "") {
            showAlertWarning(title: "OMG", content: "Email or Pass is empty")
        }
    }
    
    func checkPassWord(){
        let firstPass = self.firstPassTextField.text
        let secondPass = self.secondPassTextFeld.text
        let userName = self.userNameTextField.text
        var flag = 0
        for value in items[0..<items.count] {
            if value.name == userName! {
                flag = flag + 1
            }
        }
        
        if ((userName?.characters.count)! < 6){
            showAlertWarning(title: "User name incorrect", content: "User name must be at least 6 characters")
        }
        if (firstPass != secondPass){
            showAlertWarning(title: "Your passwords don't match", content: "Enter your password carefully")
        }
        if ((firstPass?.characters.count)! < 8 || (secondPass?.characters.count)! < 8){
            showAlertWarning(title: "Password incorrect", content: "Your password must be at least 8 characters")
        }
        if userName == firstPass {
            showAlertWarning(title: "OMG!!!", content: "User name and password need different")
        }
        if (firstPass! == secondPass! && (userName?.characters.count)! >= 6 && (firstPass?.characters.count)! >= 8 && (secondPass?.characters.count)! >= 8 && flag >= 1) {
            showAlertWarning(title: "OPPS!!!", content: "User name have been exist \n Please choice another name")
            print("Tai khoan co roi")
        }
        if (firstPass! == secondPass! && (userName?.characters.count)! >= 6 && (firstPass?.characters.count)! >= 8 && (secondPass?.characters.count)! >= 8 && flag == 0) {
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    let newUser = UserInformations(context: context)
                    newUser.name = userName
                    newUser.pass = firstPass
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    dismiss(animated: true, completion: nil )
            
                            //showWhenUserTapRegisterButton(title: "Are you sure register with your information")
                            
            
            // call some func to register
            
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showAlertWarning(title: String, content: String){
        let alert = UIAlertController(title: title, message: content , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
            print("User Click Ok To Enter Again")
        }))
        self.present(alert, animated:  true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userNameTextField.resignFirstResponder()
        firstPassTextField.resignFirstResponder()
        secondPassTextFeld.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func showWhenUserTapRegisterButton(title: String){
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Register", style: .default, handler: registerNow))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: cancelToCheck))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
//        }))
        self.present(alert, animated:  true, completion: nil)
    }
    
    func registerNow(alert: UIAlertAction){
        performSegue(withIdentifier: "loginViewAfterRegister", sender: self)
    }
    
    func cancelToCheck(alert: UIAlertAction){
        print("User check information again")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //            let newEntry = Item(context: context)
    //            newEntry.name = itemEntryTextView?.text!
    //
    //            (UIApplication.shared.delegate as! AppDelegate).saveContext()
    //
    //            dismiss(animated: true, completion: nil)
    
    // or
    //            var newUser = NSEntityDescription.insertNewObjectForEntityForName("Users", inManagedObjectContext: context) as NSManagedObject
    //
    //            newUser.setValue(userEmail, forKey: "name")
    //
    //            newUser.setValue(userPassword, forKey: "password")
    //
    //            context.save(nil)

}
