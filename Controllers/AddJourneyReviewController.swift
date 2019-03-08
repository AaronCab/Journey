//
//  AddJourneyReviewController.swift
//  Journey
//
//  Created by Aaron Cabreja on 2/13/19.
//  Copyright © 2019 Aaron Cabreja. All rights reserved.
//

import UIKit
import CoreLocation

class AddJourneyReviewController: UIViewController {
  
  @IBOutlet var addJourneyReview: AddJourneyReview!
  
  private var locationTypes = [LocationType]()
  private var journeyReviewPlaceholderText = "enter your location review"
  private var journeyTextFieldPlaceholder = "enter your location"
  private var selectedLocationType = "\(LocationType.allCases[0])"
  private var usersession: UserSession!
  
  public var coordinate: CLLocationCoordinate2D!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addJourneyReview.raceTypePickerView.dataSource = self
    addJourneyReview.raceTypePickerView.delegate = self
    configureTextView()
    configureTextField()
//    addJourneyReview.journeyNameTextField.becomeFirstResponder()
    usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
  }
  
  private func configureTextView() {
    addJourneyReview.reviewTextView.delegate = self
    addJourneyReview.reviewTextView.text = journeyReviewPlaceholderText
    addJourneyReview.reviewTextView.textColor = .lightGray
  }
    
  private func configureTextField(){
        addJourneyReview.journeyNameTextField.delegate = self
        addJourneyReview.journeyNameTextField.text = journeyTextFieldPlaceholder
        addJourneyReview.journeyNameTextField.textColor = .lightGray
    }
  
  @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
    dismiss(animated: true)
  }
  

  @IBAction func addRaceReviewButtonPressed(_ sender: UIBarButtonItem) {
    guard let user = usersession.getCurrentUser() else {
      showAlert(title: "Not Authenticated!", message: "no logged user", actionTitle: "Ok")
      return
    }
    guard let locationName = addJourneyReview.journeyNameTextField.text,
      let review = addJourneyReview.reviewTextView.text,
      !locationName.isEmpty,
      !review.isEmpty else {
        showAlert(title: "Missing Fields", message: "Location Name and Review Required", actionTitle: "Try Again")
        return
    }
    
    let journeyReview = JourneyReview(name: locationName,
                                review: review,
                                type: selectedLocationType,
                                lat: coordinate.latitude,
                                lon: coordinate.longitude,
                                reviewerId: user.uid,
                                dbReference: "") // reference will be set after document is created
    DatabaseManager.postJourneyReviewToDatabase(journeyReview: journeyReview)
    
    showAlert(title: "Journey Review Created", message: "Successfully created \(journeyReview.name) journey review", style: .alert) { (action) in
      self.dismiss(animated: true)
    }
  }
}

extension AddJourneyReviewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return LocationType.allCases.count
  }
}

extension AddJourneyReviewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "\(LocationType.allCases[row])"
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedLocationType = "\(LocationType.allCases[row])"
  }
}

extension AddJourneyReviewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.text == journeyReviewPlaceholderText {
      textView.textColor = .black
      textView.text = ""
    }
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text == "" {
      textView.textColor = .lightGray
      textView.text = journeyReviewPlaceholderText
    }
  }
}
extension AddJourneyReviewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == journeyTextFieldPlaceholder {
          textField.textColor = .black
            textField.text = ""
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.textColor = .lightGray
            textField.text = journeyTextFieldPlaceholder
            
        }

    }
}
