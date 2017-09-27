//
//  ViewController.swift
//  FaceBookIntegration
//
//  Created by Appinventiv Technologies on 26/09/17.
//  Copyright © 2017 Appinventiv Technologies. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Firebase

class ViewController: UIViewController,FBSDKLoginButtonDelegate,GIDSignInUIDelegate {
    
    @IBOutlet weak var logInWithGoogleBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        
        loginButton.frame = CGRect(x: 16, y: 50,
                                   width: view.frame.width - 32,
                                   height: 50)
        
    loginButton.delegate = self
        
        //        For google........
        
        setupGoogleButtons()
        GIDSignIn.sharedInstance().uiDelegate = self
        logInWithGoogleBtn.addTarget(self,
                                     action: #selector(ViewController.handleCustomGoogleSign),
                                     for: .touchUpInside)
        
    }
    
    @IBAction func fbLogIn(_ sender: Any) {
        
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["email"],
                             from: self) { (result, error) in
                                
                                if error == nil {
                                    
                                    if let fbLoginResult = result {
                                        
                                        if fbLoginResult.grantedPermissions != nil && fbLoginResult.grantedPermissions.contains("email"){
                                            self.getFBUserData()
                                            
                                        }
                                    }
                                }
        }
    }
    
    func getFBUserData(){
        
        if((FBSDKAccessToken.current()) != nil){
            
            FBSDKGraphRequest(graphPath: "me",
                              parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection,
                                result,
                                error) -> Void in
                                if (error == nil){
                                    //everything works print the user data
                                    print(result!)
                                }
                              })
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!,
                     didCompleteWith result: FBSDKLoginManagerLoginResult!,
                     error: Error!) {
        
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully logged in with facebook...")
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("Did log out of facebook")
        
    }
    
    fileprivate func setupGoogleButtons() {
        //add google sign in button
        
        let googleButton = GIDSignInButton()
        
        googleButton.frame = CGRect(x: 16,
                                    y: 116 + 66,
                                    width: view.frame.width - 32,
                                    height: 50)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    @objc func handleCustomGoogleSign() {
        
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    
    
}

