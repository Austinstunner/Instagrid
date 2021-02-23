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
    private var swipeGesture: UISwipeGestureRecognizer!
    // MARK: - @IBOutlet
    @IBOutlet var layouts: [UIButton]!
    @IBOutlet var gridButtons: [UIButton]!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var swipeText: UILabel!
    @IBOutlet weak var grid: UIView!
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        defineLayoutButton(.firstFigure)
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeToShare(_:)))
        grid.addGestureRecognizer(swipeGesture)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeDeviceOrientation),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }
    // MARK: - Enumeration
    enum Layouts {
        case firstFigure, secondFigure, thirdFigure
    }
    // MARK: - DefineLayoutButton
    private func defineLayoutButton(_ layoutDisplay: Layouts) {
        switch layoutDisplay {
        case .firstFigure:
            layouts[0].setImage(UIImage(named: "Selected"), for: .normal)
            layouts[1].setImage(UIImage(named: "Default Image"), for: .normal)
            layouts[2].setImage(UIImage(named: "Default Image"), for: .normal)
            gridButtons[0].isHidden = false
            gridButtons[1].isHidden = true
            gridButtons[2].isHidden = false
            gridButtons[3].isHidden = false
        case .secondFigure:
            layouts[0].setImage(UIImage(named: "Default Image"), for: .normal)
            layouts[1].setImage(UIImage(named: "Selected"), for: .normal)
            layouts[2].setImage(UIImage(named: "Default Image"), for: .normal)
            gridButtons[0].isHidden = false
            gridButtons[1].isHidden = false
            gridButtons[2].isHidden = false
            gridButtons[3].isHidden = true
        case .thirdFigure:
            layouts[0].setImage(UIImage(named: "Default Image"), for: .normal)
            layouts[1].setImage(UIImage(named: "Default Image"), for: .normal)
            layouts[2].setImage(UIImage(named: "Selected"), for: .normal)
            gridButtons[0].isHidden = false
            gridButtons[1].isHidden = false
            gridButtons[2].isHidden = false
            gridButtons[3].isHidden = false
        }
    }
    // MARK: - Photo Module
    // --Loading PhotoLibrary--\\
    func loadPhotos(sender: UIButton) {
        // buttonBuffer = sender
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        // imagePickerController.allowsEditing = true
        imagePickerController.isEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    // --Replace Button's Photo--\\
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
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
        defineLayoutButton(.firstFigure)
    }
    @IBAction func pushSecondLayout(_ sender: UIButton) {
        defineLayoutButton(.secondFigure)
    }
    @IBAction func pushThirdLayout(_ sender: UIButton) {
        defineLayoutButton(.thirdFigure)
    }
    // MARK: - Change Elements With Orientation
    @objc func changeDeviceOrientation() {
        if UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            swipeText.text = "Swipe left to share"
            arrow.image = UIImage(named: "Arrow Left")
            swipeGesture.direction = .left
        } else {
            swipeText.text = "Swipe up to share"
            arrow.image = UIImage(named: "Arrow Up")
            swipeGesture.direction = .up
        }
    }
    // MARK: - Swipe
    @objc private func swipeToShare(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .recognized {
            gridAnimation()
            sharePhotos()
        }
    }
    // MARK: - Transform The Grid Into UIImage
    private func viewToImage(with view: UIView) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
        return image
    }
    // MARK: - Share Image After Conversion
    private func sharePhotos() {
        let sharingImage = viewToImage(with: grid)
        let items = [sharingImage]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(activityVC, animated: true)
        activityVC.completionWithItemsHandler = { (_, _, _, _) in
                    self.reverseGridAnimation()
                }
    }
    // MARK: - Animation of the Grid
    private func gridAnimation() {
        // --decrease of the grid-- \\
        let decreaseGrid = CGAffineTransform(scaleX: 0.4, y: 0.4)
        if UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft {
            // --Combine decreaseGrid and swipe translation-- \\
            let swipeLeftAnimation = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.grid.transform = decreaseGrid.concatenating(swipeLeftAnimation)
            })
            arrow.isHidden = true
            swipeText.isHidden = true
        } else {
            let swipeUpAnimation = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.grid.transform = decreaseGrid.concatenating(swipeUpAnimation)
            })
            arrow.isHidden = true
            swipeText.isHidden = true
        }
    }
    // --Reverse animation--\\
    private func reverseGridAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, animations: {
            self.grid.transform = .identity
        })
        arrow.isHidden = false
        swipeText.isHidden = false
    }

}
