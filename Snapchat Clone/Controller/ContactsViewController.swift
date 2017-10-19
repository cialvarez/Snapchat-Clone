//
//  ContactsViewController.swift
//  Snapchat Clone
//
//  Created by Christian Alvarez on 10/10/2017.
//  Copyright © 2017 Christian Alvarez. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ContactsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var blurViewEffect: UIVisualEffectView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.startLoadingIndicator()
    }
    
    
    
    private func getUsers() {
        DBProvider.instance.usersReference.observeSingleEvent(of: .value) { (snapshot) in
            if let myUsers = snapshot.value as? Dictionary<String, Any>{
                for (key, value) in myUsers {
                    if let userData = value as? Dictionary<String, Any> {
                        if let data = userData["data"] as? Dictionary<String, Any> {
                            if let email = data["email"] as? String {
                                let id = key
                                let newUser = User(id: id, email: email)
                                self.users.append(newUser)
                            }
                        }
                    }
                }
            }
            self.stopLoadingIndicator()
            self.contactsTableView.reloadData()
        }
    }
    
    
    //MARK - UITableViewDataSource Methods
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            print("Error; could not load cell; creating safe cell")
            let defaultCell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            defaultCell.textLabel?.text = "No elements found. I should not be here"
            return defaultCell
        }
        cell.textLabel?.text = users[indexPath.row].email
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 20 , y: cell.bounds.origin.y)
        cell.alpha = 0
        
        UIView.animate(withDuration: 1.0 * Double(indexPath.row)/Double(users.count), animations: {
            cell.transform = CGAffineTransform.identity
            cell.alpha = 1
        })
    }
    
    
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        print("Logout pressed.")
        if AuthProvider.instance.logout() {
            print("logging out...")
            dismiss(animated: true, completion: nil)
        } else {
            print("logout failed")
            showAlert(title: "Logout Failed.", message: "We can't seem to log you out. Please try again in a while.")
        }
    }
    
    
    
    
    
    
    
    @IBAction func galleryButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func takePictureButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func takeVideoButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func sendButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func startLoadingIndicator() {
        self.activityIndicator.startAnimating()
        self.blurViewEffect.effect = UIBlurEffect(style: .extraLight)
        self.blurViewEffect.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.blurViewEffect.effect = UIBlurEffect(style: .light)
        }
        
        
    }
    
    private func stopLoadingIndicator() {
        self.activityIndicator.stopAnimating()
        self.blurViewEffect.effect = UIBlurEffect(style: .light)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.blurViewEffect.effect = nil
        }) { (bool) in
            self.blurViewEffect.isHidden = true
        }
    }
    
    
}
