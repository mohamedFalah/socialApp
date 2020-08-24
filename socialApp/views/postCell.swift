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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
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
        }
        
    }

}
