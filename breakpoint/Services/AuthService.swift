//
//  AuthService.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/12/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit

class AuthService {
    static let instance = AuthService()
    
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping(_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                userCreationComplete(false, error)
                return
            }
            
            // providerID can be Facebook, Google, Firebase, or email
            let userData = [
                "provider": user.providerID,
                "email": user.email
            ]
            DataService.instance.createDBUser(uid: user.uid, userData: userData)
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping(_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
        }
    }
    
    func loginUserWithFacebook(userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start { (connection, result, error) in
            if error != nil {
                print("Failed to start graph request:", error ?? "")
                return
            }
        }
        
        guard let accessTokenString = FBSDKAccessToken.current().tokenString else {
            print("FB BUG")
            print(FBSDKAccessToken.current().tokenString)
            return
        }
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        
        Auth.auth().signIn(with: credentials) { (user, error) in
            guard let user = user else {
                userCreationComplete(false, error)
                return
            }
            let userData = [
                "provider": "Facebook",
                "email": user.email
            ]
            DataService.instance.createDBUser(uid: user.uid, userData: userData)
            userCreationComplete(true, nil)
        }
    
    }
    
}














