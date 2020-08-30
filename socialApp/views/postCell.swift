//
//  postCell.swift
//  socialApp
//
//  Created by Mohammed Alshulah on 12/06/2020.
//  Copyright © 2020 Mohammed Alshulah. All rights reserved.
//

import UIKit
import Firebase

class postCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var liked: UIButton!
    
    var post: Post!
    
    //REFLIKES
    let likesRef = DataService.dataService.REF_CURRENT_USER.child("likes")

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.likeTapped))
        tap.numberOfTapsRequired = 1
        liked.addGestureRecognizer(tap)
        liked.isUserInteractionEnabled = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
     function to initialize the cells with content
     */
    func configureCell (post: Post, img: UIImage? = nil ) {
        self.post = post
        self.caption.text = post.caption
        //self.postImage = post.imageUrl
        self.likes.text = "\(post.likes)"
        self.comments.text = "\(post.comments)"
        
        if img != nil {
            self.postImage.image = img
        } else {
            let PostImageRef = Storage.storage().reference(forURL: post.imageUrl)
            PostImageRef.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("STORAGE: unable to download image")
                } else {
                    print("image downloaded")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImage.image = img
                            FeedVC.imgCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
                        
            likesRef.observeSingleEvent(of: .value) { (snapshot) in
                if let _ = snapshot.value as? NSNull {
                    self.liked.imageView?.image = UIImage(named: "heart")
                } else {
                    self.liked.imageView?.image = UIImage(named: "heart.fill")
                }
            }
        }
        
    }
    
    @objc func likeTapped(sender: UIGestureRecognizer) {
        likesRef.observeSingleEvent(of: .value) { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.liked.imageView?.image = UIImage(named: "heart.fill")
                self.post.adjustLike(addLike: true)
                self.likesRef.child(self.post.id).setValue(true)
            } else {
                self.liked.imageView?.image = UIImage(named: "heart")
                self.post.adjustLike(addLike: false)
                self.likesRef.child(self.post.id).removeValue()
            }
        }
        
    }

}
