//
//  AddViewController.swift
//  CoreDataApp
//
//  Created by win on 3/23/19.
//  Copyright © 2019 win. All rights reserved.
//

import UIKit
import CoreData

class AddViewController: UIViewController {
    
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var managerContext : NSManagedObjectContext!
    var coreData : CoreData?
    override func viewDidLoad() {
        super.viewDidLoad()
        //show keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        textView.becomeFirstResponder()
        
        if let coreData = coreData{
            textView.text = coreData.title
            segmentControl.selectedSegmentIndex = Int(coreData.priotity)
        }
    }
    @objc func keyboardWillShow(notification : Notification){
        guard let  keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        
        let keyboardHeigt = keyboardFrame.cgRectValue.height
        self.bottomConstraint.constant    =   keyboardHeigt
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func done(_ sender: Any) {
        guard  let title = textView.text , !title.isEmpty else {
            return
        }
        if let coreData = self.coreData{
            coreData.title = title
            coreData.priotity = Int16(segmentControl.selectedSegmentIndex)
        } else {
            let coreData = CoreData(context: managerContext)
            coreData.title = title
            coreData.priotity = Int16(segmentControl.selectedSegmentIndex)
            coreData.date = Date()
        }
        do {
            try managerContext.save()
            dismiss(animated: true)
            textView.resignFirstResponder()
        } catch {
            print("Error save coreData: \(error)")
        }
        
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        textView.resignFirstResponder()
    }
}
extension AddViewController : UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        if btnDone.isHidden {
            textView.textColor  =   .black
            
            btnDone.isHidden = false
        }
    }
}
