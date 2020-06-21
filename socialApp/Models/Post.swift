//
//  Post.swift
//  socialApp
//
//  Created by Mohammed Alshulah on 18/06/2020.
//  Copyright © 2020 Mohammed Alshulah. All rights reserved.
//

import Foundation

class Post {
    
    private var _id: String?
    private var _caption: String?
    private var _imageUrl: String?
    private var _likes: Int?
    private var _comments: Int?
    
    var id: String {
        return _id!
    }
    var caption: String {
        return _caption!
    }
    var imageUrl: String {
        return _imageUrl!
    }
    var likes: Int {
        return _likes!
    }
    var comments: Int {
        return _comments!
    }
    
    init(caption: String, imageUrl:String, likes: Int, comments: Int){
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
        self._comments = comments
    }
    
    /*
     initilizer to create instance of post as dictionary id and other info
     */
    
    init(id: String, postData: Dictionary<String, AnyObject>){
        self._id = id
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        if let comments = postData["comments"] as? Int {
            self._comments = comments
        }
    }
    
    
}
