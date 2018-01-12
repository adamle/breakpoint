//
//  ChooseAvatarVC.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/19/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class ChooseAvatarVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ChooseAvatarVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell {
            cell.configureCell(index: indexPath.item)
            return cell
        }
        return AvatarCell()
    }
    
    // cell did select
    // send the select cell image to me_VC
    // you can notify profileImgDidChange to the system, so that Me_VC can listen and upload the new data
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let profileImageString = "proLang\(indexPath.item)"
        DataService.instance.setDefaultAvatar(avatarName: profileImageString)
        NotificationCenter.default.post(name: NOTIF_USER_CHOOSE_DEFAULT_PROFILE, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}







