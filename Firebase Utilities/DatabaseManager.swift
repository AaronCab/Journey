//
//  DatabaseManager.swift
//  Journey
//
//  Created by Aaron Cabrejaon 2/12/19.
//  Copyright © 2019 Aaron Cabreja. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class DatabaseManager {

  private init() {}

  static let firebaseDB: Firestore = {
    // gets a reference to firestore database
    let db = Firestore.firestore()
    let settings = db.settings
    settings.areTimestampsInSnapshotsEnabled = true
    db.settings = settings

    return db
  }()

  static func postJourneyReviewToDatabase(journeyReview: JourneyReview) {
    var ref: DocumentReference? = nil
    ref = firebaseDB.collection(DatabaseKeys.JourneyReviewCollectionKey).addDocument(data: [
                                                                  "locationName"    : journeyReview.name,
                                                                  "locationReview"  : journeyReview.review,
                                                                  "reviewerId"  : journeyReview.reviewerId,
                                                                  "latitude"    : journeyReview.lat,
                                                                  "longitude"   : journeyReview.lon,
                                                                  "locationType"    : journeyReview.type
      ], completion: { (error) in
      if let error = error {
        print("posing journey failed with error: \(error)")
      } else {
        print("post created at ref: \(ref?.documentID ?? "no doc id")")
        DatabaseManager.firebaseDB.collection(DatabaseKeys.JourneyReviewCollectionKey)
          .document(ref!.documentID)
          .updateData(["dbReference": ref!.documentID], completion: { (error) in
          if let error = error {
            print("error updating field: \(error)")
          } else {
            print("field updated")
          }
        })
      }
    })
  }

}
