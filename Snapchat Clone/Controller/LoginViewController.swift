//
//  ViewController.swift
//  Snapchat Clone
//
//  Created by Christian Alvarez on 10/10/2017.
//  Copyright © 2017 Christian Alvarez. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    
    private let CONTACTS_SEGUE_ID = "LogInUser"
    
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    @IBOutlet weak var screenBlurView: UIVisualEffectView!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AuthProvider.instance.isLoggedIn() {
            performSegue(withIdentifier: CONTACTS_SEGUE_ID, sender: nil)
        }
    }
    

    @IBAction func loginButtonPressed(_ sender: CustomButton) {
        //AuthProvider.instance.login(with: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        if emailTextField.text != "" && passwordTextField.text != ""{
            self.startLoadingIndicator()
            AuthProvider.instance.login(with: emailTextField.text!, password: passwordTextField.text!, loginHandler:    { (errorMessage) in
                if errorMessage != nil {
                    self.showAlert(title: "Problem Logging In", message: errorMessage!)
                } else {
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.stopLoadingIndicator()
                    self.performSegue(withIdentifier: self.CONTACTS_SEGUE_ID, sender: nil)
                }
                
            })
        } else {
            showAlert(title: "You missed something!", message: "Please enter your\(emailTextField.text == "" ? " email address" : "")\(emailTextField.text == "" && passwordTextField.text == "" ? " and" : "" )\(passwordTextField.text == "" ? " password" : "")")
        }
        
        
        
    }
    
   
    
    
    @IBAction func registerButtonPressed(_ sender: CustomButton) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            self.startLoadingIndicator()
            AuthProvider.instance.signUp(with: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (errorMessage) in
                if errorMessage != nil {
                    self.showAlert(title: "Problem Creating User Account", message: errorMessage!)
                } else {
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.stopLoadingIndicator()
                    self.performSegue(withIdentifier: self.CONTACTS_SEGUE_ID, sender: nil)
                }
            })
        } else {
            showAlert(title: "You missed something!", message: "Please enter your\(emailTextField.text == "" ? " email address" : "")\(emailTextField.text == "" && passwordTextField.text == "" ? " and" : "" )\(passwordTextField.text == "" ? " password" : "")")
        }
        
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.stopLoadingIndicator()
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func startLoadingIndicator() {
        self.loginActivityIndicator.startAnimating()
        self.screenBlurView.effect = nil
        UIView.animate(withDuration: 0.5) {
            self.screenBlurView.effect = UIBlurEffect(style: .light)
            self.screenBlurView.isHidden = false
        }
        
    }
    
    private func stopLoadingIndicator() {
        self.loginActivityIndicator.stopAnimating()
        self.screenBlurView.effect = UIBlurEffect(style: .extraLight)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.screenBlurView.effect = nil
        }) { (bool) in
            self.screenBlurView.isHidden = true
        }
    }
    
}

