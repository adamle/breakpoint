//
//  GroupMemberVC.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/18/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class GroupMemberVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitle: UILabel!
    
    var group: Group!
    var emailArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTitle.text = group.groupTitle
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataService.instance.REF_GROUPS.observe(.value) { (groupSnapshot) in
            DataService.instance.getEmails(forGroup: self.group, handler: { (returnEmailArray) in
                self.emailArray = returnEmailArray
                self.tableView.reloadData()
            })
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        guard let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: "GroupFeedVC") as? GroupFeedVC else { return}
        dismissDetail(groupFeedVC)
    }
    
}

extension GroupMemberVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupMemberCell") as? GroupMemberCell else { return UITableViewCell()}
        let image = UIImage(named: "defaultProfileImage")
        let email = self.emailArray[indexPath.row]
        cell.configureCell(image: image!, email: email)
        return cell
    }
}










