//
//  ViewController.swift
//  Instagrid
//
//  Created by ANTHONY TUFFERY on 09/02/2021.
//

import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Private var
    private var buttonBuffer: UIButton = UIButton()
    private var swipe: UISwipeGestureRecognizer!
    
    // MARK: - @IBOutlet
    
    @IBOutlet var layouts: [UIButton]!
    @IBOutlet var gridButtons: [UIButton]!
    @IBOutlet weak var Arrow: UIImageView!
    @IBOutlet weak var swipeText: UILabel!
    @IBOutlet weak var grid: UIView!
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defineLayoutButton(.layout1)
        swipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        grid.addGestureRecognizer(swipe)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changingOrientation),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }
    
    // MARK: - Enumeration
    
    enum Layout {
        case layout1, layout2, layout3
    }
    
    // MARK: - DefineLayoutButton
    
    private func defineLayoutButton(_ layoutDisplay: Layout) {
        switch layoutDisplay {
        case .layout1:
            layouts[0].setImage(UIImage(named: "Selected"), for: .normal)
            layouts[1].setImage(UIImage(named: "Layout 2"), for: .normal)
            layouts[2].setImage(UIImage(named: "Layout 3"), for: .normal)
            layouts[0].isHidden = false
            layouts[1].isHidden = false
            layouts[2].isHidden = false
            gridButtons[0].isHidden = false
            gridButtons[1].isHidden = true
            gridButtons[2].isHidden = false
            gridButtons[3].isHidden = false
        
        case .layout2:
            layouts[1].setImage(UIImage(named: "Selected"), for: .normal)
            layouts[0].setImage(UIImage(named: "Layout 1"), for: .normal)
            layouts[2].setImage(UIImage(named: "Layout 3"), for: .normal)
            gridButtons[0].isHidden = false
            gridButtons[1].isHidden = false
            gridButtons[2].isHidden = false
            gridButtons[3].isHidden = true
        
        case .layout3:
            layouts[2].setImage(UIImage(named: "Selected"), for: .normal)
            layouts[0].setImage(UIImage(named: "Layout 1"), for: .normal)
            layouts[1].setImage(UIImage(named: "Layout 2"), for: .normal)
            gridButtons[0].isHidden = false
            gridButtons[1].isHidden = false
            gridButtons[2].isHidden = false
            gridButtons[3].isHidden = false
        }
    }
    
    // MARK: - Photo Module
    
    //--Loading PhotoLibrary--\\
    
    func loadPhotos(sender: UIButton) {
        // buttonBuffer = sender
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        // imagePickerController.allowsEditing = true
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
    
    // MARK: - Push Photolibrary's Buttons
    
    @IBAction func pushTopLeftButton(_ sender: UIButton) {
        buttonBuffer = gridButtons[0]
        loadPhotos(sender: gridButtons[0])
    }
    
    @IBAction func pushTopRightButton(_ sender: UIButton) {
        buttonBuffer = gridButtons[1]
        loadPhotos(sender: gridButtons[1])
    }
    
    @IBAction func pushBottomLeftButton(_ sender: UIButton) {
        buttonBuffer = gridButtons[2]
        loadPhotos(sender: gridButtons[2])
    }
    
    @IBAction func pushBottomRightButton(_ sender: UIButton) {
        buttonBuffer = gridButtons[3]
        loadPhotos(sender: gridButtons[2])
    }
    
    // MARK: - Push Layout's Buttons
    
    @IBAction func pushFirstLayout(_ sender: UIButton) {
        defineLayoutButton(.layout1)
    }
    
    @IBAction func pushSecondLayout(_ sender: UIButton) {
        defineLayoutButton(.layout2)
    }
    
    @IBAction func pushThirdLayout(_ sender: UIButton) {
        defineLayoutButton(.layout3)
    }
    
    // MARK: - Change Elements With Orientation
    
    @objc func changingOrientation() {
        if UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            swipeText.text = "Swipe left to share"
            Arrow.image = UIImage(named: "Arrow Left")
            swipe.direction = .left
        } else {
            swipeText.text = "Swipe up to share"
            Arrow.image = UIImage(named: "Arrow Up")
            swipe.direction = .up
        }
    }
    
    // MARK: - Swipe
    
    @objc private func didSwipe(_ sender: UISwipeGestureRecognizer) {
        gridAnimation()
        if sender.state == .recognized {
            share()
        }
    }
    
    // MARK: - Transform The Grid Into UIImage
    
    private func viewToImage(with view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    // MARK: - Share Image After Conversion
    
    private func share() {
        let sharingImage = viewToImage(with: grid)
        let items = [sharingImage]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityVC, animated: true)
        activityVC.completionWithItemsHandler = { (activity, success, items, error) in
                    self.reverseGridAnimation()
                }
        
        
    }
    
    // MARK: - Animation of the Grid
    
    private func gridAnimation() {
        //--decrease of the grid--\\
        let decreaseGrid = CGAffineTransform(scaleX: 0.4, y: 0.4)
        if UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            //--Combine decreaseGrid and swipe translation--\\
            let swipeLeftAnimation = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.grid.transform = decreaseGrid.concatenating(swipeLeftAnimation)
            })
            Arrow.isHidden = true
            swipeText.isHidden = true
        } else {
            let swipeUpAnimation = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.grid.transform = decreaseGrid.concatenating(swipeUpAnimation)
            })
            Arrow.isHidden = true
            swipeText.isHidden = true
        }
    }
    
    //--Reverse animation--\\
    private func reverseGridAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.grid.transform = .identity
            
        })
        Arrow.isHidden = false
        swipeText.isHidden = false
    }

}


