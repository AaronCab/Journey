//
//  JourneyReviewsController.swift
//  Journey
//
//  Created by Aaron Cabreja on 2/12/19.
//  Copyright © 2019 Aaron Cabreja. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore

class JourneyReviewsController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  private var longPress: UILongPressGestureRecognizer!
  private var journeyReviews = [JourneyReview]() {
    didSet {
      DispatchQueue.main.async {
        self.makeAnnotations()
      }
    }
  }
  private var annoations = [MKAnnotation]()
  private var listener: ListenerRegistration! // detach listener when no longer needed
  private var locationResultsController: LocationsResultsController = {
    let storyboard = UIStoryboard(name: "LocationResults", bundle: nil)
    let locationController = storyboard.instantiateViewController(withIdentifier: "LocationsResultsController") as! LocationsResultsController
    return locationController
  }()
  private lazy var searchController: UISearchController = {
    let sc = UISearchController(searchResultsController: locationResultsController)
    sc.searchResultsUpdater = locationResultsController
    sc.hidesNavigationBarDuringPresentation = false
    sc.searchBar.placeholder = "search for location"
    sc.dimsBackgroundDuringPresentation = false
    sc.obscuresBackgroundDuringPresentation = false
    definesPresentationContext = true
    sc.searchBar.autocapitalizationType = .none
    return sc
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = #colorLiteral(red: 0.5742103457, green: 1, blue: 0.722725153, alpha: 1)
    configureLongPress()
    mapView.delegate = self
    configureNavBar()
    
    locationResultsController.delegate = self
    
    fetchJourneyReviews()
  }
  
  private func configureNavBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .automatic
    navigationItem.searchController = searchController
    navigationController?.title = "Journey"
  }
  
  private func fetchJourneyReviews() {
    // add a listener to observe changes to the firestore database
    journeyReviews.removeAll()
    listener = DatabaseManager.firebaseDB.collection(DatabaseKeys.JourneyReviewCollectionKey).addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
      if let error = error {
        self.showAlert(title: "Network Error", message: error.localizedDescription, actionTitle: "Ok")
      } else if let snapshot = snapshot {
        var reviews = [JourneyReview]()
        for document in snapshot.documents {
          let journeyReview = JourneyReview(dict: document.data())
          reviews.append(journeyReview)
        }
        self.journeyReviews = reviews
      }
    }
  }
  
  private func configureLongPress() {
    longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
    longPress.minimumPressDuration = 0.5 // default is 0.5
    mapView.addGestureRecognizer(longPress)
  }
  
  private func makeAnnotations() {
    mapView.removeAnnotations(annoations)
    annoations.removeAll()
    for specificReview in journeyReviews {
      let annotation = MKPointAnnotation()
      annotation.coordinate = specificReview.coordinate
      annotation.title = specificReview.name
      annoations.append(annotation)
    }
    mapView.showAnnotations(annoations, animated: true)
  }
  
  @objc private func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
    // get the CGPoint at which the long press was done
    let point = gestureRecognizer.location(in: mapView)
    let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
    var isDone = false
    if !isDone {
      switch gestureRecognizer.state {
      case .began:
        presentAddJourneyReview(coordinate: coordinate)
        isDone = true
        break
      default:
        break
      }
    }
  }
  
  private func presentAddJourneyReview(coordinate: CLLocationCoordinate2D) {
    let tabStoryboard = UIStoryboard(name: "JourneyReviewsTab", bundle: nil)
    let addReviewsNavController = tabStoryboard.instantiateViewController(withIdentifier: "AddJourneyReviewNavController") as! UINavigationController
    guard let addJourneyReviewsController = addReviewsNavController.viewControllers.first as? AddJourneyReviewController else {
      fatalError("AddJourneyReviewController is nil")
    }
    addJourneyReviewsController.coordinate = coordinate
    present(addReviewsNavController, animated: true)
  }
}

extension JourneyReviewsController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    let detailStoryboard = UIStoryboard(name: "ReviewDetail", bundle: nil)
    guard let reviewDetailController = detailStoryboard.instantiateViewController(withIdentifier: "ReviewDetailController") as? ReviewDetailController else {
      fatalError("ReviewDetailController is nil")
    }
    guard let annotation = view.annotation else {
      fatalError("annotation nil")
    }
    let index = journeyReviews.index { $0.coordinate.latitude == annotation.coordinate.latitude
      && $0.coordinate.longitude == $0.coordinate.longitude
    }
    
    if let reviewIndex = index {
      let journeyReview = journeyReviews[reviewIndex]
      reviewDetailController.journeyReview = journeyReview
      reviewDetailController.modalPresentationStyle = .overFullScreen
      reviewDetailController.modalTransitionStyle = .crossDissolve
      present(reviewDetailController, animated: true)
    } 
    mapView.deselectAnnotation(annotation, animated: true)
  }





}
extension JourneyReviewsController: LocationResultsControllerDelegate {
    func didSelectCoordinate(_ locationResultsController: LocationsResultsController, coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1_000, longitudinalMeters: 1_000)
        mapView.setRegion(region, animated: true)
    }
    
    func didScrollTableView(_ locationResultsController: LocationsResultsController) {
        searchController.searchBar.resignFirstResponder()
    }
}

