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


class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
