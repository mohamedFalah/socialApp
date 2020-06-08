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
import SwiftKeychainWrapper

class SignInVC: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //method to perform the segue
    override func viewDidAppear(_ animated: Bool) {
        //if there is key saved in the keychain auto sign in autmatically.
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID){
            //got to feed screen
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                //run the funtion completeSignIn to save the key to the kychain
                if let user = user {
                    self.completeSignIn(userId: user.user.uid)
                }
            }
        }
    }
    
    /*
     email and password authintication with firebase
     
     Not all scenarios written.
     **/

    @IBAction func SignInTapped(_ sender: Any) {
        
//        if let email = EmailTextField.text, let password = passwordTextField.text {
//            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//                if error == nil {
//                    print("MSGAuth: user authinticated with email")
//                } else {
//                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//                        if error != nil {
//                            print("MSGAuth: unable to authinticate email with firebase")
//                        } else {
//                            print("MSGAuth: successfully authinticated email with firebase")
//                        }
//                    }
//                }
//
//            }
//        }
        
        //take the text from text field with non empty
        if let email = emailTextField.text, let password = passwordTextField.text{
            
            //call firebase signin with email and password
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                //if the no error
                guard error == nil else {
                    //else create new user
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        //if error
                        guard error == nil else {
                        // print no authintication
                            print("MSGAuth: unable to authinticate email with Firebase")
                            return
                        }
                        //else the email is authinticated
                        print("MSGAuth: successfully authinticated email with Firebase")
                        //run the funtion completeSignIn to save the key to the kychain
                        if let user = user {
                            self.completeSignIn(userId: user.user.uid)
                        }
                    }
                  return
                }
                //authinticated
                print("MSGAuth: user authinticated with email")
                //run the funtion completeSignIn to save the key to the kychain
                if let user = user {
                    self.completeSignIn(userId: user.user.uid)
                }
            }
            
        }
    }
    
    /*
     function to save the key of the user id to keychain to perform auto sign in
     **/
    func completeSignIn (userId: String) {
        //save the key to the keychain
        let keychainResult = KeychainWrapper.standard.set(userId, forKey: KEY_UID)
        print("MSGAuth: data saved to keychain \(keychainResult)")
        //got to the feed screen
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
}

