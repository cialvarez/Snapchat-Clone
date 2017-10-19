//
//  AuthProvider.swift
//  Snapchat Clone
//
//  Created by Christian Alvarez on 10/10/2017.
//  Copyright © 2017 Christian Alvarez. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginHandler = (_ errMSG: String?) -> Void

struct LoginErrorCode {
    static let WRONG_PASSWORD = "Wrong password. Please try again."
    static let INVALID_EMAIL = "That email address is invalid. Please check the email address you entered and try again."
    static let USER_NOT_FOUND = "That email address isn't registered yet! You may use that email address to register. "
    static let PROBLEM_CONNECTING = "We can't seem to connect you to our server. Please try again in a while. "
    static let EMAIL_IN_USE = "Someone's already using that email. Please use another email or log in using this one."
    static let WEAK_PASSWORD = "Your password will be too easy to guess! Try a longer password (at least six characters is good)"
}

class AuthProvider {
    private static let _instance = AuthProvider()
    
    static var instance: AuthProvider {
        return _instance
    }
    
    func isLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil ? true : false
    }
    
    func login(with email: String, password: String, loginHandler: LoginHandler?) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.handleErrors(err: error as NSError, loginHandler: loginHandler)
            } else {
                loginHandler?(nil)
            }
        }
    }
    
    func signUp(with email: String, password: String, loginHandler: LoginHandler?) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.handleErrors(err: error as NSError, loginHandler: loginHandler)
            } else {
               // loginHandler?(nil)
                if user?.uid != nil {
                    //Save to database
                    DBProvider.instance.saveUser(with: (user?.uid)!, email: email, password: password)
                    
                    //Sign in the user
                    self.login(with: email, password: password, loginHandler: loginHandler)
                }
                
            }
        }
    }
    
    
    func logout() -> Bool {
        
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                return true
            } catch {
                print("couldn't log user out")
                return false
            }
        }
        return true
    }
    
    private func handleErrors(err: NSError, loginHandler: LoginHandler?) {
        if let errCode = AuthErrorCode(rawValue: err.code) {
            switch errCode {
            case .wrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORD)
                break
            case .invalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL)
                break
            case .userNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND)
                break
            case .emailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_IN_USE)
                break
            case .weakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD)
                break
            default:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING)
                break
            }
        }
    }
    
}
