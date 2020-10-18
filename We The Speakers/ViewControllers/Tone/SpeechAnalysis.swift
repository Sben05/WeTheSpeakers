//
//  ToneRecordViewController.swift
//  We The Speakers
//
//  Created by Shreeniket Bendre on 10/17/20.
//  Copyright © 2020 Shreeniket Bendre. All rights reserved.
//

import UIKit

class ToneRecordViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var textField2: UITextView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.text = ""
        textField2.isEditable = false
        self.textField.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapAnalyse(sender: Any){
        let model = IMDBReviewClassifier()
        
        if let text = textField.text {
                      do {
                          let prediction = try model.prediction(text: text)
                          if prediction.label == "Positive" {
                            
                            textField2.text = text
                            label.text = prediction.label
                            colorView.backgroundColor = .green
                              
                              //self.newCollection.reloadData()
                          } else {
                              textField2.text = text
                              label.text = prediction.label
                              colorView.backgroundColor = .red
                          }
                      } catch {
                          print(error)
                      }
                  }
    }
    @objc func tapDone(sender: Any) {
          self.view.endEditing(true)
      }
    
    func textField(_ textField: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText:String = textField.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        
        if updatedText.isEmpty {
            
            textField.text = "Please insert teleprompter text here"
            textField.textColor = UIColor.lightGray
            
            textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.beginningOfDocument)
        }
            
        else if textField.textColor == UIColor.lightGray && !text.isEmpty {
            textField.textColor = UIColor.black
            textField.text = text
        }
            
        else {
            return true
        }
        
        return false
    }
    func textFieldDidChangeSelection(_ textField: UITextView) {
        if self.view.window != nil {
            if textField.textColor == UIColor.lightGray {
                textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.beginningOfDocument)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
