//
//  DetailsVC.swift
//  FourSquareClone
//
//  Created by Ebuzer Şimşek on 4.05.2023.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var DetailsNameLabel: UILabel!
    @IBOutlet var DetailsPlaceTypeLabel: UILabel!
    @IBOutlet var DetailsCommentLabel: UILabel!
    @IBOutlet var DetailsMapView: MKMapView!
    
    var chosenId = ""
    var chosenLatitude = 0.0
    var chosenLongitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the map view delegate
        DetailsMapView.delegate = self
        
        // Fetch data from Parse
        getDataFromParse()
    }
    
    func getDataFromParse() {
        
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenId)
        
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let objects = objects, let chosenPlaceObject = objects.first {
                if let placeName = chosenPlaceObject.object(forKey: "name") as? String {
                    self.DetailsNameLabel.text = placeName
                }
                
                if let placeType = chosenPlaceObject.object(forKey: "type") as? String {
                    self.DetailsPlaceTypeLabel.text = placeType
                }
                
                if let placeComment = chosenPlaceObject.object(forKey: "comment") as? String {
                    self.DetailsCommentLabel.text = placeComment
                }
                
                if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String,
                   let latitude = Double(placeLatitude) {
                    self.chosenLatitude = latitude
                }
                
                if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String,
                   let longitude = Double(placeLongitude) {
                    self.chosenLongitude = longitude
                }
                
                if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject {
                    imageData.getDataInBackground { (data, error) in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        } else if let data = data {
                            self.imageView.image = UIImage(data: data)
                        }
                    }
                }
                
                // Add map annotation and center on the chosen place
                let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                let region = MKCoordinateRegion(center: location, span: span)
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = location
                annotation.title = self.DetailsNameLabel.text
                annotation.subtitle = self.DetailsPlaceTypeLabel.text
                
                self.DetailsMapView.setRegion(region, animated: true)
                self.DetailsMapView.addAnnotation(annotation)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != 0.0 && self.chosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    
                    if placemark.count > 0 {
                        
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.DetailsNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                    
                }
            }
            
        }
    }
    
}
