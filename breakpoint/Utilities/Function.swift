//
//  Function.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/01/2018.
//  Copyright © 2018 Le Dang Dai Duong. All rights reserved.
//

import UIKit
import Firebase

func uploadImageDataToFirebase(image: UIImage) {
    if let uploadData = UIImagePNGRepresentation(image) {
        DataService.instance.REF_AVATAR.putData(uploadData, metadata: nil, completion: { (metaData, error) in
            if error != nil {
                return
            }
            if let imageURL = metaData?.downloadURL()?.absoluteString {
                DataService.instance.uploadImageToUser(uid: (Auth.auth().currentUser?.uid)!, imageURL: imageURL)
            }
        })
    }
}

func loadProfileImageForCurrentUser(atViewController viewController: UIViewController, withProfileImage profileImg: UIImageView, andActivityLoader loader: UIActivityIndicatorView) {
    
    let uid = Auth.auth().currentUser?.uid
    
    DataService.instance.fetchImageToUser(uid: uid!) { (url) in
        if url == "" {
            profileImg.image = UIImage(named:"defaultProfileImage")
            loader.isHidden = true
            return
        } else {
            let url = URL(string: url)
            
            if url?.absoluteString == USER_IMAGE_URL {
                loader.isHidden = true
                if USER_IMAGE_DATA != nil {
                    profileImg.image = UIImage(data: USER_IMAGE_DATA!)
                    print("Loading profile image from UserDefaults")
                }
            } else {
                loader.isHidden = false
                loader.startAnimating()
                
                let session = URLSession(configuration: .default)
                let getImage = session.dataTask(with: url!) { (data, response, error) in
                    if let error = error {
                        print("URL loading error: \(error)")
                        return
                    } else {
                        if (response as? HTTPURLResponse) != nil {
                            if let imageData = data {
                                let imageFromData = UIImage(data: imageData)
                                DispatchQueue.main.async {
                                    profileImg.image = imageFromData
                                    loader.stopAnimating()
                                    loader.isHidden = true
                                    // Saving image to UserDefaults
                                    UserDefaults.standard.set(url?.absoluteString, forKey: "userImageUrl")
                                    UserDefaults.standard.set(imageData, forKey: "userImageData")
                                }
                                print("Success loading image at \(viewController)")
                            } else {
                                print("No image found")
                            }
                        } else {
                            print("No response from server")
                        }
                    }
                }
                getImage.resume()
            }
        }
    }
}

