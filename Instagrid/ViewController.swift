//
//  ViewController.swift
//  Instagrid
//
//  Created by Dev on 09/02/2021.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CaseView[0].isHidden = false
        CaseView[1].isHidden = true
        CaseView[2].isHidden = true
        SelectedButton[0].isHidden = false
        SelectedButton[1].isHidden = true
        SelectedButton[2].isHidden = true
    }
    
//----------------VARIABLES-----------------\\
    private var buttonBuffer: UIButton = UIButton()
    
    
//----------------MISCELLANIOUS------------\\
    @IBOutlet weak var instagridTitle: UILabel!
    @IBOutlet weak var swipeTitle: UILabel!
    @IBOutlet weak var arrowUp: UIImageView!
    
//------------------COLLECTIONS----------------\\
//COLLECTION VIEW
    @IBOutlet var CaseView: [UIView]!
    
//COLLECTION FIRST CASE PHOTO BUTTON
    @IBOutlet var FirstCasePhotoButton: [UIButton]!
    
//COLLECTION SECOND CASE PHOTO BUTTON
    @IBOutlet var SecondCasePhotoButton: [UIButton]!
    
//COLLECTION THIRD CASE PHOTO BUTTON
    @IBOutlet var ThirdCasePhotoButton: [UIButton]!
    
//COLLECTION SELECT LAYOUT
    @IBOutlet var SelectLayoutButton: [UIButton]!
    
// COLLECTION SELECTED BUTTON
    @IBOutlet var SelectedButton: [UIImageView]!
//------------------------------------------------
//----------------DEFINE CASE'S LAYOUT-------------\\
    func firstCase() {
        CaseView[0].isHidden = false
        SelectedButton[0].isHidden = false
        CaseView[1].isHidden = true
        SelectedButton[1].isHidden = true
        CaseView[2].isHidden = true
        SelectedButton[2].isHidden = true
    }
    func secondCase() {
        CaseView[0].isHidden = true
        SelectedButton[0].isHidden = true
        CaseView[1].isHidden = false
        SelectedButton[1].isHidden = false
        CaseView[2].isHidden = true
        SelectedButton[2].isHidden = true
    }
    func thirdCase() {
        CaseView[0].isHidden = true
        SelectedButton[0].isHidden = true
        CaseView[1].isHidden = true
        SelectedButton[1].isHidden = true
        CaseView[2].isHidden = false
        SelectedButton[2].isHidden = false
    }
//-------------SELECTING LAYOUT------------\\
    @IBAction func pressingFirstCaseButton(_ sender: UIButton) {
        firstCase()
    }
    @IBAction func pressingSecondCaseButton(_ sender: UIButton) {
        secondCase()
    }
    @IBAction func pressingThirdCaseButton(_ sender: UIButton) {
        thirdCase()
    }
//-------------------ADD THE PHOTO MODULE--------------\\
        //--Loading PhotoLibrary--\\
    func loadPhotos(sender: UIButton) {
       // buttonBuffer = sender
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.isEditing = true
        imagePickerController.delegate = self
           present(imagePickerController, animated: true, completion: nil)
    }
        //--Replace Button's Photo--\\
    func imagePickerController(_ Picker : UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let newPicture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            buttonBuffer.setImage(newPicture, for: .normal)
            buttonBuffer.imageView?.contentMode = .scaleAspectFill
            self.dismiss(animated: true, completion: nil)
        }
    }
//--------------BUTTON'S ACTION OF DIFFERENT LAYOUT--------------\\
    //--First Case--\\
    @IBAction func FirstCaseButton1(_ sender: UIButton) {
        buttonBuffer = FirstCasePhotoButton[0]
        loadPhotos(sender: FirstCasePhotoButton[0])
    }
    @IBAction func FirstCaseButton2(_ sender: UIButton) {
        buttonBuffer = FirstCasePhotoButton[2]
        loadPhotos(sender: FirstCasePhotoButton[2])
    }
    @IBAction func FirstCaseButton3(_ sender: UIButton) {
        buttonBuffer = FirstCasePhotoButton[1]
        loadPhotos(sender: FirstCasePhotoButton[1])
    }
    //--Second Case--\\
    @IBAction func SecondCaseButton1(_ sender: UIButton) {
        buttonBuffer = SecondCasePhotoButton[0]
        loadPhotos(sender: SecondCasePhotoButton[0])
    }
    @IBAction func SecondCaseButton2(_ sender: UIButton) {
        buttonBuffer = SecondCasePhotoButton[1]
        loadPhotos(sender: SecondCasePhotoButton[1])
    }
    @IBAction func SecondCaseButton3(_ sender: UIButton) {
        buttonBuffer = SecondCasePhotoButton[2]
        loadPhotos(sender: SecondCasePhotoButton[2])
    }
    //--Third Case--\\
    @IBAction func ThirdCaseButton1(_ sender: UIButton) {
        buttonBuffer = ThirdCasePhotoButton[0]
        loadPhotos(sender: ThirdCasePhotoButton[0])
    }
    @IBAction func ThirdCaseButton2(_ sender: UIButton) {
        buttonBuffer = ThirdCasePhotoButton[1]
        loadPhotos(sender: ThirdCasePhotoButton[1])
    }
    @IBAction func ThirdCaseButton3(_ sender: UIButton) {
        buttonBuffer = ThirdCasePhotoButton[2]
        loadPhotos(sender: ThirdCasePhotoButton[2])
    }
    @IBAction func ThirdCaseButton4(_ sender: UIButton) {
        buttonBuffer = ThirdCasePhotoButton[3]
        loadPhotos(sender: ThirdCasePhotoButton[3])
    }
    
    
    
    // Swipe
    
    func swipeFirstCase() {
    }

    
    // buttonBuffer = firstCaseRectangle
   // loadPhotos(sender: firstCaseRectangle)
    
   

}
