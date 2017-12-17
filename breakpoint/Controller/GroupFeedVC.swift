//
//  GroupFeedVC.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/17/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class GroupFeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var membersLbl: UILabel!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var messageTextField: InsetTextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var group: Group?
    
    func initData(forGroup group: Group) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendView.bindToKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        groupTitleLbl.text = group?.groupTitle
        DataService.instance.getEmails(forGroup: group!) { (returnedEmailArray) in
            self.membersLbl.text = returnedEmailArray.joined(separator: ", ")
        }
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
