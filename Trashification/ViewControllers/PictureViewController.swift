//
//  PictureViewController.swift
//  Hangman
//
//  Created by Hugo Zhan on 3/28/20.
//  Copyright © 2020 Tim's Apples. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class PictureViewController: UIViewController {

    var image: UIImage?
    @IBOutlet weak var chosenImage: UIImageView!
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var catLabel: UILabel!
    
    override func viewDidLoad() {
        self.finishedButton.layer.cornerRadius = 10
        catLabel.text! += cat[scan.firstIndex(of: scan.max()!)!]
        catLabel.text! += message[scan.firstIndex(of: scan.max()!)!]
        chosenImage.image = image
        super.viewDidLoad()
    }
      
    @IBAction func finishedButtonPressed(_ sender: Any) {
        data[scan.firstIndex(of: scan.max()!)!] += 1
        if (loggedIn) {
            let db = Firestore.firestore()
            db.collection("users").document(Auth.auth().currentUser!.uid).setData([cat[scan.firstIndex(of: scan.max()!)!]: data[scan.firstIndex(of: scan.max()!)!]], merge: true)
            dismiss(animated: true, completion: nil)
        } else {
             let viewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
                       self.view.window?.rootViewController = viewController
                       self.view.window?.makeKeyAndVisible()
        }
    }
}
