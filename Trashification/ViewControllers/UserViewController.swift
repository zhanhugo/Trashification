//
//  HangmanViewController
//  Hangman
//
//  Created by iOS Decal on Feb 11 2020.
//  Copyright © 2020 iosdecal. All rights reserved.
//

import UIKit

var userEmail: String = ""
var userName: String = ""
var loggedIn: Bool = false;

class UserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePicker: UIImagePickerController = UIImagePickerController()
    var pickedImage: UIImage = UIImage()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text! += userName
        emailLabel.text! += userEmail
        self.cameraButton.layer.cornerRadius = 10
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
      }
    
    override func viewDidAppear(_ animated: Bool) {
        if (!loggedIn) {
            present(imagePicker, animated: false, completion: nil)
            loggedIn = true;
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        present(imagePicker, animated: false, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            pickedImage = image
        }
        self.imagePicker.dismiss(animated: false) {
            self.performSegue(withIdentifier: "trashification", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PictureViewController {
            dest.image = pickedImage
          }
      }
}
