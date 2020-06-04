//
//  ViewController.swift
//  socialApp
//
//  Created by Mohammed Alshulah on 30/05/2020.
//  Copyright © 2020 Mohammed Alshulah. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    
    /*
     facebook auth method
     to get the access token and pass it to firebase
     
     **/
    @IBAction func FacebookLoginTapped(_ sender: Any) {
        
        //get the loginManger from FB SDK
        let facebookLogin = LoginManager()
        
        //use the login with email premission and check the error and result
        facebookLogin.logIn(permissions: ["email"], from: self) { (result, error) in
            if error != nil {
                //error during the auth
                print("MSGAuth: unable to authintcate \(String(describing: error))")
            }
            else if result?.isCancelled == true {
                
                //if user cancelled the auth process
                print("MSGAuth: facebook authentication is cancelled")
            }
            else {
                //auth is successful
                print("MSGAuth: successfully authinticated with facebook")
                //get the credential using firebase FacebookAuthProvider with FB SDK AccessToken
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                //pass the credential to the firebase auth method
                self.FirebaseAuth(credential)
            }
        }
        
    }
    
    /*
     authinticate the user throw firebase
     **/
    
    func FirebaseAuth (_ credential: AuthCredential) {
        //use the Auth.auth().signIn and pass the credential
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                //if result an error print it
                print("MSGAuth: unable to auth with firebase \(String(describing: error))")
            }
            else {
                //successful auth print it
                print("MSGAuth: successfully authinticated with firebase")
            }
        }
    }
    


}

