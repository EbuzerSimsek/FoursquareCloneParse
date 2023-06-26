//
//  AddPlaceVC.swift
//  FourSquareClone
//
//  Created by Ebuzer Şimşek on 5.05.2023.
//

import UIKit

class AddPlaceVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet var placeNameText: UITextField!
    @IBOutlet var placeTypeText: UITextField!
    @IBOutlet var commentText: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    
    @objc func chooseImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker,animated: true,completion: nil)
        
    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        if placeNameText.text != "" && placeTypeText.text != "" && commentText.text != ""{
            if let chosenImage = imageView.image{
                let placeModel = PlaceModel.sharedInstanse
                placeModel.placeName = placeNameText.text!
                placeModel.placeType = placeTypeText.text!
                placeModel.placeComment = commentText.text!
                placeModel.placeImage = chosenImage
            }
            
            performSegue(withIdentifier:"toMapVC", sender: nil)
        }else{
            let alert = UIAlertController(title: "Error", message: "Place Name?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alert.addAction(okButton)
            present(alert,animated: true)
        }
        
    }
    
    
    
}
