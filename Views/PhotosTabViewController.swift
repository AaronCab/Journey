//
//  PhotosTabViewController.swift
//  Journey
//
//  Created by Aaron Cabreja on 3/8/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class PhotosTabViewController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    var views: [UIView]!
    override func viewDidLoad() {
        super.viewDidLoad()
        views = [UIView]()
        views.append(PhotosLibraryViewController().view)
        views.append(CameraViewController().view)
        for v in views{
            viewContainer.addSubview(v)
        }
        viewContainer.bringSubviewToFront(views[0])
    }
    

   
    @IBAction func switchSegmentControl(_ sender: UISegmentedControl) {
        self.viewContainer.bringSubviewToFront(views[sender.selectedSegmentIndex])
    }
    
}
