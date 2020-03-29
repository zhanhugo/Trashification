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
    let db = Firestore.firestore()
    
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
    
    func fetchNameData(completion: @escaping (String) -> Void) {
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        docRef.getDocument{(document, error) in
            let username = (document!.get("firstName") as! String) + " " + (document!.get("lastName") as! String)
            completion(username)
        }
    }
    
    func setData(completion: @escaping ([Double]) -> Void) {
        var dataArray = [Double]()
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        docRef.getDocument{(document, error) in
            if let error = error {
                print(error)
                completion(dataArray)
                return
            }
            for i in 0...4 {
                let count = document!.get(cat[i]) as! Double
                dataArray.append(count + data[i])
            }
            completion(dataArray)
        }
    }
       
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
                self.fetchNameData() { name in
                    userName = name
                    userEmail = email
                    let userViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.userViewController) as? UserViewController
                    loggedIn = true
                    self.setData { dataArray in
                        data = dataArray
                        self.db.collection("users").document(Auth.auth().currentUser!.uid).setData([cat[scan.firstIndex(of: scan.max()!)!]: data[scan.firstIndex(of: scan.max()!)!]], merge: true)
                        self.view.window?.rootViewController = userViewController
                        self.view.window?.makeKeyAndVisible()
                    }
                }
            }
        }
    }
}

