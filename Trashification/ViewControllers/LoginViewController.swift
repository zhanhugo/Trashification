//
//  LoginViewController.swift
//  Trashification
//
//  Created by Hugo Zhan on 3/28/20.
//  Copyright © 2020 Tim's Apples. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
     override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
            
            setUpElements()
        }
        
        func setUpElements() {
            
            // Hide the error label
            errorLabel.alpha = 0
            
            // Style the elements
            Utilities.styleTextField(emailTextField)
            Utilities.styleTextField(passwordTextField)
            Utilities.styleFilledButton(loginButton)
            
        }
        
//    func fetchData(completion: @escaping (String) -> Void) {
//                let db = Firestore.firestore()
//                let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
//                docRef.getDocument{(document, error) in
//                    guard let name = (document?.get("firstName") as? String) + (document?.get("firstName") as? String) else {
//                        print("could not get name")
//                        return
//                    }
//                    completion(name)
//                }
//            }
//
        
    @IBAction func loginTapped(_ sender: Any) {
        // TODO: Validate Text Fields

        // Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        //Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                userEmail = email
            let userViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.userViewController) as? UserViewController
            loggedIn = true
            self.view.window?.rootViewController = userViewController
            self.view.window?.makeKeyAndVisible()
                
            }
    }
}
}
