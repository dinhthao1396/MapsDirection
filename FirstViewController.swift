//
//  FirstViewController.swift
//  MapsDemo
//
//  Created by Tran Dinh Thao on 8/10/17.
//  Copyright © 2017 Tran Dinh Thao. All rights reserved.
// aaaaaaaaaaaaaaasssssss

import UIKit

class FirstViewController: UIViewController {
    var mapChangedFromUserInteraction = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.isNavigationBarHidden = false
        self.performSegue(withIdentifier: "loginView", sender: self)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        
//        super.viewWillAppear(true)
//        self.navigationController?.isNavigationBarHidden = true
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
