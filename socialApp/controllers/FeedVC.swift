//
//  FeedVC.swift
//  socialApp
//
//  Created by Mohammed Alshulah on 08/06/2020.
//  Copyright © 2020 Mohammed Alshulah. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addImageButton: ImageViewCustomization!
    
    @IBOutlet weak var captionTextField: UITextField!
    
    //array to store the posts
    var posts = [Post]()
    
    //image picker
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    
    //image cache
    static var imgCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //initialize the image picer
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
        //create listener on posts childs
        ///.value -> Any data changes at a location or, recursively, at any child node.  FIRDataEventTypeValue
        DataService.dataService.REF_POSTS.observe(.value) { (snapshot) in
            self.posts.removeAll()
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("FIR: \(snap)")
                    //dictionary the take the posts from database to store in the local variable
                    // it has string id and postdata -> caption image and likes and comments
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let id = snap.key
                        let post = Post(id: id, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            //reload the tableview to show the data
            self.tableView.reloadData()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    /*
     table view func
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? postCell {
            if let img = FeedVC.imgCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return postCell()
        }
    }
    
    
    /*
     image picker function
     when user select an image
     */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print("PICKER: added")
            //view the selected image in the imageview
            addImageButton.image = image
            imageSelected = true
        }else {
            print("PICKER: error")
        }
        //getout of the picker
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    /*
     show picker if clicked on imageview
     */
    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    //upload post 
    @IBAction func postBtnTapped(_ sender: Any) {
        guard let caption = captionTextField.text, caption != "" else {
            print("POSTING: you must have a caption")
            return
        }
        
        guard let image = addImageButton.image, imageSelected == true else {
            print("POSTING: image must be selected")
            return
        }
        
        if let imageData = image.jpegData(compressionQuality: 0.2) {
            
            let imageUId = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let uploadImage = DataService.dataService.REF_POST_IMAGES.child(imageUId)
            uploadImage.putData(imageData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("UPLOADING: error uplaoding the picture")
                } else {
                    print("UPLAODING: image uplaoded")
                    uploadImage.downloadURL { (url, error) in
                        let downloadUrl = url?.absoluteString
                        print("IMAGEURL: \(String(describing: downloadUrl))")
                        self.postToFirebase(imageUrl: downloadUrl!)
                     }
                }
            }
        }
    }
    
    func postToFirebase(imageUrl: String) {
        
        let post: Dictionary<String, Any> = [
            "caption": captionTextField.text!,
            "imageUrl": imageUrl,
            "comments": 0,
            "likes": 0
        ]
       
        //post to firebase
        _ = DataService.dataService.REF_POSTS.childByAutoId().setValue(post)
        
        tableView.reloadData()
        //empty fields
        captionTextField.text = ""
        imageSelected = false
        addImageButton.image = UIImage(named: "camera-1")
    }
    
    /*
     function to sign out the user and delete the keys from keychian
     **/
    @IBAction func logoutButtonTapped(_ sender: Any) {
        //remove the key from keychain
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("MSGAuth: key removed from keychain \(keychainResult)")
        
        
        //return to the sign in screen
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
}
