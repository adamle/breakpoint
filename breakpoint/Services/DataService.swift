//
//  DataService.swift
//  breakpoint
//
//  Created by Le Dang Dai Duong on 12/10/17.
//  Copyright © 2017 Le Dang Dai Duong. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    private var _REF_AVATAR = STORAGE_BASE.child("avatar")
    public private(set) var defaultAvatarName = ""
    
    func setDefaultAvatar(avatarName: String) {
        self.defaultAvatarName = avatarName
    }
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    var REF_AVATAR: StorageReference {
        let imageName = NSUUID().uuidString
        return _REF_AVATAR.child("\(imageName).png")
    }

    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func uploadImageToUser(uid: String, imageURL: String) {
        REF_USERS.child(uid).updateChildValues(["profileImage": imageURL])
    }
    
    func fetchImageToUser(uid: String, handler: @escaping(_ imageUrlString: String) -> ()) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (userSnapshot) in
            let value = userSnapshot.value as? NSDictionary
            let imageUrl = value?["profileImage"] as? String ?? ""
            handler(imageUrl)
        } 
    }
    
    func getUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        // Look at the data once, not continuously
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return}
            for user in userSnapshot {
                // key example: of9BsoGWjGfmfnGR6bLw2RWGX682
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        if groupKey != nil {
        REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content": message, "senderID": uid])
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderID": uid])
        }
        sendComplete(true)
    }
    
    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()) {
        var messageArray = [Message]()
        
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            // DataSnapshot is sent from Firebase, can have 0 - 100 - more elements
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return}
            
            for messageSnapshot in feedMessageSnapshot {
                let content = messageSnapshot.childSnapshot(forPath: "content").value as! String
                let senderID = messageSnapshot.childSnapshot(forPath: "senderID").value as! String
                let message = Message(content: content, senderID: senderID)
                messageArray.append(message)
            }
            handler(messageArray)
        }
    }
    
    func getAllGroupMessages(forDesiredGroup group: Group, handler: @escaping (_ messages: [Message]) -> ()) {
        var messageArray = [Message]()
        REF_GROUPS.child(group.key).child("messages").observeSingleEvent(of: .value) { (groupMessageSnapshot) in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else { return}
            for groupMessageSnap in groupMessageSnapshot {
                let content = groupMessageSnap.childSnapshot(forPath: "content").value as! String
                let senderID = groupMessageSnap.childSnapshot(forPath: "senderID").value as! String
                let message = Message(content: content, senderID: senderID)
                messageArray.append(message)
            }
            handler(messageArray)
        }
        
    }
    
    func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return}
            
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if email.contains(query) && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func getIds(forUserEmail userEmails: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            var idArray = [String]()
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return}
            
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if userEmails.contains(email) {
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
    func getEmails(forGroup group: Group, handler: @escaping (_ emailArray: [String]) -> ()) {
        var emailArray = [String]()
        emailArray.append("you")
        
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnap = userSnapshot.children.allObjects as? [DataSnapshot] else { return}
            for user in userSnap {
                let uid = user.key
                if uid != Auth.auth().currentUser?.uid {
                    if group.members.contains(uid) {
                        let email = user.childSnapshot(forPath: "email").value as! String
                        emailArray.append(email)
                    }
                }
            }
            handler(emailArray)
        }
    }
    
    func createGroup(withTitle title: String, andDescription description: String, forUsersIds ids: [String], handler: @escaping (_ groupCreated: Bool) -> ()) {
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        handler(true)
    }
    
    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        var groupsArray = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return}
            
            for groupSnap in groupSnapshot {
                let members = groupSnap.childSnapshot(forPath: "members").value as! [String]
                // We only download groups that we are in
                if members.contains((Auth.auth().currentUser?.uid)!) {
                    let key = groupSnap.key
                    let title = groupSnap.childSnapshot(forPath: "title").value as! String
                    let description = groupSnap.childSnapshot(forPath: "description").value as! String
                    let group = Group(title: title, description: description, key: key, memberCount: members.count, members: members)
                    groupsArray.append(group)
                }
            }
            handler(groupsArray)
        }
    }
}




















