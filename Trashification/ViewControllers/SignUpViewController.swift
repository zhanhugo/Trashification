//
//  SignUpViewController.swift
//  Trashification
//
//  Created by Hugo Zhan on 3/28/20.
//  Copyright © 2020 Tim's Apples. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
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
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
    func validateFields() -> String? {

        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {

            return "Please fill in all fields."
        }

        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }

        return nil
    }


    @IBAction func signUpTapped(_ sender: Any) {

        // Validate the fields
        let error = validateFields()

        if error != nil {

            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            // Create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            //Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in

                // Check for errors
                if err != nil {

                    // There was an error creating the user
                    self.showError("Error creating user")
                }
                else {
                    // User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()
                    db.collection("users").document(result!.user.uid).setData(["firstName": firstName, "lastName": lastName, "Metal": 0, "Plastic": 0, "Cardboard": 0, "Paper": 0, "Other Trash": 0]) { (error) in
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    db.collection("users").document(Auth.auth().currentUser!.uid).setData([cat[scan.firstIndex(of: scan.max()!)!]: data[scan.firstIndex(of: scan.max()!)!]], merge: true)
                    // Transition to the home screen
                    self.fetchNameData() { name in
                        userName = name
                        userEmail = email
                        let userViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.userViewController) as? UserViewController
                        loggedIn = true
                        self.view.window?.rootViewController = userViewController
                        self.view.window?.makeKeyAndVisible()
                    }
                }
            }
        }
    }
    
    func fetchNameData(completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        docRef.getDocument{(document, error) in
            let username = (document!.get("firstName") as! String) + " " + (document!.get("lastName") as! String)
            completion(username)
        }
    }

    func showError(_ message:String) {

        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
}
