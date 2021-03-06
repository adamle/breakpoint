//
//  FeedVC.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/10/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import UIKit

class PublicFeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var messageArray = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loader.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(0), execute: {
            DataService.instance.getAllFeedMessages { (returnedMessageArray) in
                // Show the most recent message at the top
                self.messageArray = returnedMessageArray.reversed()
                self.tableView.reloadData()
                self.tableView.isHidden = false
                self.loader.stopAnimating()
            }
        })
    }
}

extension PublicFeedVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell else { return UITableViewCell()}
        var image = UIImage(named: "defaultProfileImage")
        let message = messageArray[indexPath.row]
        
        DataService.instance.getUsername(forUID: message.senderID) { (returnedUsername) in
            DataService.instance.fetchImageToUser(uid: message.senderID, handler: { (returnedUrl) in
                
                if returnedUrl == "" {
                    cell.configureCell(profileImage: image!, email: returnedUsername, content: message.content)
                } else {
                    let url = URL(string: returnedUrl)
                    let session = URLSession(configuration: .default)
                    let getImage = session.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if let error = error {
                            print("URL loading error: \(error)")
                            return
                        } else {
                            if (response as? HTTPURLResponse) != nil {
                                if let imageData = data {
                                    let imageFromData = UIImage(data: imageData)
                                    DispatchQueue.main.async {
                                        image = imageFromData
                                        cell.configureCell(profileImage: image!, email: returnedUsername, content: message.content)
                                    }
                                }
                                print("Success loading image PublicFeedVC")
                            }
                        }
                    })
                    getImage.resume()
                }
            })
        }
        return cell
    }
}
