//
//  JourneyReview.swift
//  Journey
//
//  Created by Aaron Cabreja on 2/13/19.
//  Copyright © 2019 Aaron Cabreja. All rights reserved.
//

import Foundation
import CoreLocation

struct JourneyReview {
  let name: String
  let review: String
  let type: String
  let lat: Double
  let lon: Double
  let reviewerId: String
  let dbReferenceDocumentId: String
  
  init(name: String, review: String, type: String, lat: Double, lon: Double, reviewerId: String, dbReference: String) {
    self.name = name
    self.review = review
    self.type = type
    self.lat = lat
    self.lon = lon
    self.reviewerId = reviewerId
    self.dbReferenceDocumentId = dbReference
  }
  
  init(dict: [String: Any]) {
    self.name = dict["locationName"] as? String ?? "no location name"
    self.review = dict["locationReview"] as? String ?? "no location review"
    self.type = dict["locationType"] as? String ?? "other"
    self.lat = dict["latitude"] as? Double ?? 0
    self.lon = dict["longitude"] as? Double ?? 0
    self.reviewerId = dict["reviewerId"] as? String ?? "no reviewerId"
    self.dbReferenceDocumentId = dict["dbReference"] as? String ?? "no dbReference"
  }
  
  public var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2DMake(lat, lon)
  }
}
