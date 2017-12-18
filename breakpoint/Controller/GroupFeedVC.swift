//
//  GroupFeedVC.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/17/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var membersLbl: UILabel!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var messageTextField: InsetTextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var group: Group?
    var groupMessageArray = [Message]()
    
    func initData(forGroup group: Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        
        sendView.bindToKeyboard()
        messageTextField.delegate = self
        self.sendBtn.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        groupTitleLbl.text = group?.groupTitle
        DataService.instance.getEmails(forGroup: group!) { (returnedEmailArray) in
            self.membersLbl.text = returnedEmailArray.joined(separator: ", ")
        }
        
        // Real-time observe events changing in Firebase
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllGroupMessages(forDesiredGroup: self.group!, handler: { (returnedGroupMessageArray) in
                self.groupMessageArray = returnedGroupMessageArray
                self.tableView.reloadData()
                
                // Scroll to the bottom of the tableView
                if self.groupMessageArray.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: self.groupMessageArray.count - 1, section: 0), at: .none, animated: true)
                }
            })
        }
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        if messageTextField.text != "" {
            // Make sure users don't send multiple messages
            messageTextField.isEnabled = false
            sendBtn.isEnabled = false
            
            DataService.instance.uploadPost(withMessage: messageTextField.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: group?.key) { (success) in
                self.sendBtn.isEnabled = true
                if success {
                    self.messageTextField.isEnabled = true
                    self.sendBtn.isEnabled = true
                    self.messageTextField.text = ""
                } else {
                    print("Unable to send message in \(String(describing: self.group?.groupTitle))")
                }
            }
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        guard let groupsVC = storyboard?.instantiateViewController(withIdentifier: "groupsVC") as? GroupsVC else { return}
        dismissDetail(groupsVC)
    }
    
    @IBAction func addMemberBtnPressed(_ sender: Any) {
        guard let groupMemberVC = storyboard?.instantiateViewController(withIdentifier: "addGroupMemberVC") as? GroupMemberVC else { return}
        groupMemberVC.group = self.group
        presentDetail(groupMemberVC)
    }
    
    
}

extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell") as? GroupFeedCell else { return UITableViewCell()}
        let image = UIImage(named: "defaultProfileImage")
        let message = groupMessageArray[indexPath.row]
        DataService.instance.getUsername(forUID: message.senderID) { (returnedUsername) in
            cell.configureCell(image: image!, email: returnedUsername, content: message.content)
        }
        return cell
    }
}

extension GroupFeedVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.sendBtn.isEnabled = true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.sendBtn.isEnabled = false
    }
}








