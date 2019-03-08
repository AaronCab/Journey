//
//  PhotosLibraryViewController.swift
//  Journey
//
//  Created by Aaron Cabreja on 3/8/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit
import AVFoundation
class PhotosLibraryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var photosButton: UIButton!
    private var imagePickerViewController: UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePickerViewController()
        // Do any additional setup after loading the view.
    }
    private func showImagePickerController(){
        present(imagePickerViewController, animated: true, completion: nil)
    }
    private func setupImagePickerViewController(){
        imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        
    }
    @IBAction func photosActionButton(_ sender: UIButton) {
        showImagePickerController()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photosButton.setImage(image, for: .normal)
        } else {
            print("original image is nil")
        }
        dismiss(animated: true, completion: nil)
    }
}
