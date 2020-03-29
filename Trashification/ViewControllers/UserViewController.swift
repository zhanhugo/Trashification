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
    
    @IBOutlet weak var profileImageVIew: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.isHidden = !loggedIn
        emailLabel.isHidden = !loggedIn
        cameraButton.isHidden = !loggedIn
        profileImageVIew.isHidden = !loggedIn
        descriptionLabel.isHidden = !loggedIn
        nameLabel.text! += userName
        emailLabel.text! += userEmail
        self.cameraButton.layer.cornerRadius = 10
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
      }
    
    override func viewDidAppear(_ animated: Bool) {
        if (!loggedIn) {
            present(imagePicker, animated: true, completion: nil)
        } else {
            nameLabel.isHidden = false
            emailLabel.isHidden = false
            cameraButton.isHidden = false
            profileImageVIew.isHidden = false
            descriptionLabel.isHidden = false
        }
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            pickedImage = image
        }
        nameLabel.isHidden = true
        emailLabel.isHidden = true
        cameraButton.isHidden = true
        profileImageVIew.isHidden = true
        descriptionLabel.isHidden = true
        self.imagePicker.dismiss(animated: true) {
            self.performSegue(withIdentifier: "trashification", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? PictureViewController {
            dest.image = pickedImage
          }
      }
}
