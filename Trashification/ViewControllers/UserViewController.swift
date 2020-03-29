//
//  HangmanViewController
//  Hangman
//
//  Created by iOS Decal on Feb 11 2020.
//  Copyright © 2020 iosdecal. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseAuth

//global things
var loggedIn: Bool = false;
var userEmail: String = ""
var userName: String = ""
var data: [Double] = [0, 0, 0, 0, 0]
var scan: [Double] = [0, 0, 0, 0, 0]
let cat: [String] = ["Metal", "Plastic", "Paper", "Cardboard", "Other Trash"]
let message: [String] = [". Recycling scrap metal is vitally important to the environment AND the economy. The U.S. recycles 150 million metric tons of scrap metal annually, and for good reason: scrap metal is one of the most easily refashioned and reused materials we have. - Marck Recycling",
". Six categories of plastic: PS, LDPE, PP, PVC, HDPE, PET. Only the last three of these plastic groupings are currently recycled: PVC, HDPE and PET. The other three varieties tend to be thinner and flimsier. As such, they break down in the machinery and cause it to do the same. That's why lids and caps don't make it into the recycling facility, either. - Environmental Protection",
". Many different kinds of paper can be recycled, including white office paper, newspaper, colored office paper, cardboard, white computer paper, magazines, catalogs, and phone books. Types of paper that are not recyclable are coated and treated paper, paper with food waste, juice and cereal boxes, paper cups, paper towels, and paper or magazine laminated with plastic. - Public Works",
". Cardboard recycling helps to reduce the dumping of cardboard waste in landfills. On this basis, cardboard recycling helps to improve the cleanliness of the environment and promotes healthy human surrounding. Some cardboard is made from almost 100% recycled materials, while the majority are averaged at 70% to 90%. - Conserve Energy Future",
". These are unrecyclable trash that do not belong to other categories."
]


class UserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePicker: UIImagePickerController = UIImagePickerController()
    var pickedImage: UIImage = UIImage()
    var metalDataEntry = PieChartDataEntry(value: 0)
    var plasticDataEntry = PieChartDataEntry(value: 0)
    var paperDataEntry = PieChartDataEntry(value: 0)
    var cardboardDataEntry = PieChartDataEntry(value: 0)
    var otherTrashDataEntry = PieChartDataEntry(value: 0)
    var numberOfDataEntries = [PieChartDataEntry]()
    
    @IBOutlet weak var profileImageVIew: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text! += userName
        emailLabel.text! += userEmail
        nameLabel.isHidden = !loggedIn
        emailLabel.isHidden = !loggedIn
        cameraButton.isHidden = !loggedIn
        profileImageVIew.isHidden = !loggedIn
        pieChartView.isHidden = !loggedIn
        logoutButton.isHidden = !loggedIn
        self.cameraButton.layer.cornerRadius = 10
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
      }
    
    override func viewDidAppear(_ animated: Bool) {
        if (!loggedIn) {
            present(imagePicker, animated: true)
        } else {
            updatePieChart()
            nameLabel.isHidden = false
            emailLabel.isHidden = false
            cameraButton.isHidden = false
            profileImageVIew.isHidden = false
            pieChartView.isHidden = false
            logoutButton.isHidden = false
        }
}
    @IBAction func logoutButtonPressed(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
        data = [0, 0, 0, 0, 0]
        loggedIn = false
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func updatePieChart() {
        metalDataEntry.value = data[0]
        metalDataEntry.label = cat[0]
        plasticDataEntry.value = data[1]
        plasticDataEntry.label = cat[1]
        paperDataEntry.value = data[2]
        paperDataEntry.label = cat[2]
        cardboardDataEntry.value = data[3]
        cardboardDataEntry.label = cat[3]
        otherTrashDataEntry.value = data[4]
        otherTrashDataEntry.label = cat[4]
        numberOfDataEntries = [metalDataEntry, plasticDataEntry, paperDataEntry, cardboardDataEntry, otherTrashDataEntry]
        var i = 0
        while i < numberOfDataEntries.count {
            if (numberOfDataEntries[i].value == 0) {
                numberOfDataEntries.remove(at: i)
            } else {
                i += 1
            }
        }
        let chartDataSet = PieChartDataSet(entries: numberOfDataEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        chartDataSet.colors = [UIColor.gray, UIColor.systemBlue, UIColor.systemGreen, UIColor.brown, UIColor.black]
        pieChartView.data = chartData
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            pickedImage = image
        }
        nameLabel.isHidden = true
        emailLabel.isHidden = true
        cameraButton.isHidden = true
        profileImageVIew.isHidden = true
        pieChartView.isHidden = true
        logoutButton.isHidden = true
        for i in 0...4 {
            scan[i] = Double.random(in: 0...1)
        }
        let sum = scan.reduce(0, +)
        for i in 0...4 {
            scan[i] /= sum
        }
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
