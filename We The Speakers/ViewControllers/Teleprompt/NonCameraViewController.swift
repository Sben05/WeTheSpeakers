//
//  NonCameraViewController.swift
//  We The Speakers
//
//  Created by Shreeniket Bendre on 10/17/20.
//  Copyright © 2020 Shreeniket Bendre. All rights reserved.
//

import UIKit

class NonCameraViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIButton!
    
    var secondContent = ""
    let tempTF = UITextField()
    var numIn = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tempTF.text = secondContent
        
        view.addSubview(doneButton)
        
        // Do any additional setup after loading the view.
    }
    

 

}
