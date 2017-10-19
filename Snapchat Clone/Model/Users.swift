//
//  Users.swift
//  Snapchat Clone
//
//  Created by Christian Alvarez on 10/10/2017.
//  Copyright © 2017 Christian Alvarez. All rights reserved.
//

import Foundation

struct User {
    private var _email = String()
    private var _id = String()
    
    init(id: String, email: String) {
        _id = id
        _email = email
    }
    
    var id: String {
        return _id
    }
    
    var email: String {
        get {
            return _email
        }
    }
    
    
}
