//
//  MeVC.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/12/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    let uploadPhotoPikerController = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadPhotoPikerController.delegate = self
        uploadPhotoPikerController.allowsEditing = true
        loadProfileImageForCurrentUser(atViewController: self, withProfileImage: self.profileImg, andActivityLoader: self.loader)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // If you call this in ViewDidLoad, when you log out, the old user email still stay
        self.emailLbl.text = Auth.auth().currentUser?.email
        
        // This will reload the user profile when log out and then log in right away
        NotificationCenter.default.addObserver(self, selector: #selector(self.userLogin(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        // Observe when user chooses default avatar
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupDefaultAvatar(_:)), name: NOTIF_USER_CHOOSE_DEFAULT_PROFILE, object: nil)
    }
    
    // Reload user profile when log out and then log in right away
    @objc func userLogin(_ notif: Notification) {
        // Clear user profile to default
        self.profileImg.image = UIImage(named: "defaultProfileImage")
        print("notif userDataDidChange in MeVC")
        loadProfileImageForCurrentUser(atViewController: self, withProfileImage: self.profileImg, andActivityLoader: self.loader)
    }
    
    // Set up when user chooses default avatar
    @objc func setupDefaultAvatar(_ notif: Notification) {
        let imageName = DataService.instance.defaultAvatarName
        profileImg.image = UIImage(named: imageName)
        uploadImageDataToFirebase(image: profileImg.image!)
    }
    
    @IBAction func chooseAvatarBtnPressed(_ sender: Any) {
        let chooseAvatarAC = UIAlertController(title: "_ choose Avatar", message: "Make Your Avatar Great Again", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let defaultAvatarPicker = UIAlertAction(title: "Default Avatar", style: .default) { (buttonTapped) in
            guard let chooseAvatarVC = self.storyboard?.instantiateViewController(withIdentifier: "chooseAvatarVC") as? ChooseAvatarVC else { return}
            self.present(chooseAvatarVC, animated: true, completion: nil)
        }
        
        let uploadAvatar = UIAlertAction(title: "Upload Photo", style: .default) { (buttonTapped) in
            self.handleImagePicker()
        }
        
        chooseAvatarAC.addAction(cancelAction)
        chooseAvatarAC.addAction(defaultAvatarPicker)
        chooseAvatarAC.addAction(uploadAvatar)
        
        present(chooseAvatarAC, animated: true, completion: nil)
    }
    
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        // UI Alert Controller
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                UserDefaults.standard.set("", forKey: "userImageUrl")
                UserDefaults.standard.set(nil, forKey: "userImageData")
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                self.present(authVC!, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        logoutPopup.addAction(logoutAction)
        logoutPopup.addAction(cancelAction)
        present(logoutPopup, animated: true, completion: nil)
    }
}

// Handle if user wants to use own image, instead of default image
extension MeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleImagePicker() {
        self.present(uploadPhotoPikerController, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImg.image = selectedImage
        }
        uploadImageDataToFirebase(image: profileImg.image!)
        dismiss(animated: true, completion: nil)
    }
    
}



















