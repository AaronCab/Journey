//
//  ReviewDetailController.swift
//  Journey
//
//  Created by Aaron Cabreja on 2/13/19.
//  Copyright © 2019 Aaron Cabreja. All rights reserved.
//

import UIKit

private enum EditingState {
  case authorizedForEditing
  case notAuthorizedForEditing
}

class ReviewDetailController: UIViewController {
  
  @IBOutlet var detailView: DetailView!
  
  public var journeyReview: JourneyReview!
  
  private var editingState = EditingState.notAuthorizedForEditing
  private var usersession: UserSession!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    usersession = (UIApplication.shared.delegate as! AppDelegate).usersession
    if let user = usersession.getCurrentUser() {
      editingState = user.uid == journeyReview.reviewerId ? .authorizedForEditing : .notAuthorizedForEditing
    }
    updateDetailView()
    queryForReviewer()
  }
  
  private func queryForReviewer() {
    let query = DatabaseManager.firebaseDB.collection(DatabaseKeys
      .UsersCollectionKey).whereField("userId", isEqualTo: journeyReview.reviewerId)
    query.getDocuments { (snapshot, error) in
      if let error = error {
        self.showAlert(title: "Network Error", message: error.localizedDescription, actionTitle: "Try Again")
      } else if let snapshot = snapshot {
        guard let firstDocument = snapshot.documents.first else {
          print("no document found")
          return
        }
        let reviewer = JRUser(dict: firstDocument.data())
        DispatchQueue.main.async {
          self.detailView.usernameLabel.text = "reviewed by @\(reviewer.username ?? "no ussername")"
        }
        
        guard let imageURL = reviewer.imageURL,
         !imageURL.isEmpty else {
          print("no imageURL")
          return
        }
        if let image = ImageCache.shared.fetchImageFromCache(urlString: imageURL) {
          self.detailView.reviewersProfileImageView.image = image
        } else {
          ImageCache.shared.fetchImageFromNetwork(urlString: imageURL) { (appError, image) in
            if let appError = appError {
              self.showAlert(title: "Fetching Image Error", message: appError.errorMessage(), actionTitle: "Ok")
            } else if let image = image {
              self.detailView.reviewersProfileImageView.image = image
            }
          }
        }
        
      }
    }
  }
  
  private func updateDetailView() {
    detailView.usernameLabel.text = ""
    detailView.journeyNameLabel.text = journeyReview.name
    detailView.journeyReviewTextView.text = journeyReview.review
    detailView.dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    detailView.deleteButton.addTarget(self, action: #selector(deleteJourneyReview), for: .touchUpInside)
    
    // only show the delete button if it the reviewerId == current userId 
    detailView.deleteButton.isHidden = editingState == .authorizedForEditing ? false : true
  }
  
  @objc private func dismissView() {
    dismiss(animated: true)
  }
  
  @objc private func deleteJourneyReview() {
    showDestructionAlert(title: "Confirm Delete", message: "Please confirm that you want to delete your created journey review. This action cannot be undone", style: .actionSheet) { (action) in
      self.executeDeletion()
    }
  }
  
  private func executeDeletion() {
    DatabaseManager.firebaseDB
      .collection(DatabaseKeys.JourneyReviewCollectionKey)
      .document(journeyReview.dbReferenceDocumentId).delete { (error) in
        if let error = error {
          self.showAlert(title: "Deleting Error", message: error.localizedDescription, actionTitle: "Try Again")
        } else {
          self.showAlert(title: nil, message: "Location Review was deleted successfully", style: .alert, handler: { (action) in
            self.dismiss(animated: true)
          })
        }
    }
  }
}
