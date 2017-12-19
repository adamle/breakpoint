//
//  AuthVC.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/10/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class AuthVC: UIViewController {
    
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
//        let loginBtn = FBSDKLoginButton()
//        view.addSubview(loginBtn)
//        loginBtn.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func emailSignInPressed(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func googleSignInPressed(_ sender: Any) {
    }
    
    @IBAction func facebookSignInPressed(_ sender: Any) {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print("Login Facebook failed:", error!)
                return
            }
        }
        AuthService.instance.loginUserWithFacebook { (success, error) in
            if success {
                print("Successfully loggin to Firebase with Facebook credentials ")
            } else {
                print("Failed to sign in to Firebase with Facebook credentials: ", error ?? "")
            }
        }
    }
    
}







