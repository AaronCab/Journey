//
//  AddJourneyReview.swift
//  Journey
//
//  Created by Aaron Cabreja on 2/13/19.
//  Copyright © 2019 Aaron Cabreja. All rights reserved.
//

import UIKit

class AddJourneyReview: UIView {
  
  @IBOutlet var contentView: UIView!
  
    @IBOutlet weak var journeyNameTextField: UITextField!
    @IBOutlet weak var reviewTextView: UITextView!
  @IBOutlet weak var raceTypePickerView: UIPickerView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  private func commonInit() {
    Bundle.main.loadNibNamed("AddJourneyReview", owner: self, options: nil)
    addSubview(contentView)
    contentView.frame = bounds
    contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
  }  
}
