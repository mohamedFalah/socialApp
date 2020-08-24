//
//  DataService.swift
//  socialApp
//
//  Created by Mohammed Alshulah on 13/06/2020.
//  Copyright © 2020 Mohammed Alshulah. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    
    //create the singleton - static -> global
    // create instance refrence from the same class
    static let dataService = DataService()
    
    private var _REF_BASE = DATABASE_BASE
    private var _REF_POSTS = DATABASE_BASE.child("posts")
    private var _REF_USERS = DATABASE_BASE.child("users")
    
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_POST_IMAGES: StorageReference {
        return _REF_POST_IMAGES
    }
    
    
    // store info of the users to database
    
    func createUsers (uid: String, userData: Dictionary<String, String>) {
        /*
         Summary(updateChildValues)
         Updates the values at the specified paths in the dictionary without overwriting other keys at this location.
         */
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    
    
    
    
    
    
}
