//
//  TeleSettingsViewController.swift
//  We The Speakers
//
//  Created by Shreeniket Bendre on 10/17/20.
//  Copyright © 2020 Shreeniket Bendre. All rights reserved.
//

import UIKit

class TeleSettingsViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var camSwitch: UISegmentedControl!
    @IBOutlet weak var scrollSwitch: UISegmentedControl!
    
    var text = ""
    var num = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.text = "Please insert teleprompter text here"
        textView.textColor = UIColor.lightGray
        //textView.layer.cornerRadius = 10
        textView.isHidden = false
        
        self.textView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        if (scrollSwitch.selectedSegmentIndex == 0){
            num = 0
        }
        else {
            num = 1
        }
    }
    
    
    
    
    @IBAction func clearTapped (){
        textView.text = ""
        textView.text = "Please insert teleprompter text here"
        textView.textColor = UIColor.lightGray
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        
        if updatedText.isEmpty {
            
            textView.text = "Please insert teleprompter text here"
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
            
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }
            
        else {
            return true
        }
        
        return false
    }
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    @IBAction func nextTapped(_ sender: Any) {
        self.text = textView.text
        switch camSwitch.selectedSegmentIndex {
        case 0:
            performSegue(withIdentifier: "CamSeg", sender: self)
        case 1:
            performSegue(withIdentifier: "ncamSeg", sender: self)
        default:
            performSegue(withIdentifier: "CamSeg", sender: self)
            
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch camSwitch.selectedSegmentIndex {
        case 0:
            let vc = segue.destination as! CameraViewController
            vc.content = self.text
           // vc.numIn = self.num
        case 1:
            let vc = segue.destination as! NonCameraViewController
            vc.secondContent = self.text
            vc.numIn = self.num
        default:
            let vc = segue.destination as! CameraViewController
            vc.content = self.text
            //vc.numIn = self.num

        }
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
}

