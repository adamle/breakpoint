//
//  CreatePostVC.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/12/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit
import Firebase

class CreatePostVC: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        sendBtn.bindToKeyboard()
    }

    @IBAction func sendBtnPressed(_ sender: Any) {
        if textView.text != "" && textView.text != "Say something here ..." {
            sendBtn.isEnabled = false
            DataService.instance.uploadPost(withMessage: textView.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil, sendComplete: { (isComplete) in
                self.sendBtn.isEnabled = true
                if isComplete {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print("There was an error ")
                }
            })
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreatePostVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = #colorLiteral(red: 0.3181318343, green: 0.7672088742, blue: 0.3041909933, alpha: 1)
        sendBtn.backgroundColor = #colorLiteral(red: 0.2033642232, green: 0.2145754993, blue: 0.2726458907, alpha: 1)
    }
}








