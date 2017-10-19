//
//  DBProvider.swift
//  Snapchat Clone
//
//  Created by Christian Alvarez on 10/10/2017.
//  Copyright © 2017 Christian Alvarez. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBProvider {
    private static let _instance = DBProvider()
    private let USERS = "users"
    private let EMAIL = "email"
    private let PASSWORD = "password"
    private let DATA = "data"
    
    static var instance: DBProvider {
        return _instance
    }
    
    var databaseReference: DatabaseReference {
        return Database.database().reference()
    }
    
    var usersReference: DatabaseReference {
        return databaseReference.child(USERS)
    }
    
    func saveUser(with ID: String, email: String, password: String)  {
        let data: Dictionary<String, String> = [EMAIL: email, PASSWORD: password]
        usersReference.child(ID).child(DATA).setValue(data)
    }
    
}
