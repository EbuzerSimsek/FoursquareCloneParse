//
//  MapVC.swift
//  FourSquareClone
//
//  Created by Ebuzer Şimşek on 4.05.2023.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var LocationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action:#selector(BackButtonClicked))
        
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action:#selector(SaveButtonClicked))
        
        mapView.delegate = self
        LocationManager.delegate = self
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
        LocationManager.requestWhenInUseAuthorization()
        LocationManager.startUpdatingLocation()
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        
        let Recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation))
        Recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(Recognizer)
        
        
    }
         
        @objc func chooseLocation(gestureRecognizer : UIGestureRecognizer){
            if gestureRecognizer.state == UIGestureRecognizer.State.began{
                let touches = gestureRecognizer.location(in: self.mapView)
                let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                annotation.title = PlaceModel.sharedInstanse.placeName
                annotation.subtitle = PlaceModel.sharedInstanse.placeType
                self.mapView.addAnnotation(annotation)
                PlaceModel.sharedInstanse.placeLatitude = String(coordinates.latitude)
                PlaceModel.sharedInstanse.placeLongitude = String(coordinates.longitude)
            }
        }
      
     
        @objc func SaveButtonClicked() {
            
            let PlaceModel = PlaceModel.sharedInstanse
            let object = PFObject(className: "Places")
            object["name"] = PlaceModel.placeName
            object["type"] = PlaceModel.placeType
            object["comment"] = PlaceModel.placeComment
            object["latitude"] = PlaceModel.placeLatitude
            object["longitude"] = PlaceModel.placeLongitude
            
            if let imageData = PlaceModel.placeImage.jpegData(compressionQuality: 0.5){
                object["image"] = PFFileObject(name: "image.jpg", data:imageData )
            }
            object.saveInBackground { succes, error in
                if error != nil{
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                    alert.addAction(okButton)
                    self.present(alert,animated: true)
                    
                } else {
                    self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
                }
            }
            
        }
        
        @objc func BackButtonClicked(){
            self.dismiss(animated: true)
        }
    
}
