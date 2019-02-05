//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by  AminSaleh on 13/05/1440 AH.
//  Copyright © 1440 AminTech. All rights reserved.
//

import UIKit
import MapKit
import CoreData


class MapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var fetchResultsController: NSFetchedResultsController<Locations>!
    
    var annotations = [MKPointAnnotation]()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let uilg = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        mapView.gestureRecognizers = [uilg]
        fetch()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func fetch() {
        
        let fetchRequest: NSFetchRequest<Locations> = Locations.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "latitude", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchResultsController.delegate = self
        
        do {
            try fetchResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print(fetchResultsController.sections?.count ?? 0)
        print(fetchResultsController.fetchedObjects?.count ?? 1000)
        
        let tempLocations = fetchResultsController.fetchedObjects
        
        for location in tempLocations! {
            print(location.longitude)
            let long = CLLocationDegrees(location.longitude)
            let lat = CLLocationDegrees(location.latitude)
            
            let coords = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coords
            
            annotations.append(annotation)

        }
        
        self.mapView.addAnnotations(annotations)
        
        //UserDefaults.standard.setValue(1.2222, forKey: "long")
        
        
        if let long = UserDefaults.standard.value(forKey: "long") {
            if let lat = UserDefaults.standard.value(forKey: "lat") {
                let coords = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees , longitude: long as! CLLocationDegrees)
                //mapView.centerCoordinate = coords
                //mapView.setCenter(coords, animated: true)
                //print(lonDelta)
                if let latD = UserDefaults.standard.value(forKey: "spanLatit") {
                    
                    if let longD = UserDefaults.standard.value(forKey: "spanLongt") {
                        
                        
                        let span = MKCoordinateSpan(latitudeDelta: latD as! Double, longitudeDelta: longD as! Double)
                        let region = MKCoordinateRegion(center: coords, span: span)
                        
                        self.mapView.setRegion(region, animated: true)
                        
                        
                    }
                    
                }
                
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let long = Double(CLLocationDegrees(mapView.centerCoordinate.longitude))
        let lat = Double(CLLocationDegrees(mapView.centerCoordinate.latitude))
        
        let span = mapView.region.span
        let spanLat = Double(span.latitudeDelta)
        let spanLon = Double(span.longitudeDelta)
        
        print(spanLat)
        UserDefaults.standard.setValue(long, forKey: "long")
        UserDefaults.standard.setValue(lat, forKey: "lat")
        UserDefaults.standard.setValue(spanLat, forKey: "spanLatit")
        UserDefaults.standard.setValue(spanLon, forKey: "spanLongt")
    }
    
    
    
    @objc func addAnnotation(gestureReconizer: UIGestureRecognizer) {
        
        if gestureReconizer.state == .began {
            let touchPoint = gestureReconizer.location(in: mapView)
            let coords = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            print("gooooool")
            
            let pinAnnotation = MKPointAnnotation()
            
            pinAnnotation.coordinate = coords
            //pinAnnotation.title = "Virtual tourist"
            
            print(coords.longitude)
            
            annotations.append(pinAnnotation)
            createNewLocation(withLat: coords.latitude, withLong: coords.longitude)
            
            self.mapView.addAnnotation(pinAnnotation)
        }
        
    }
    
    func createNewLocation(withLat lat: Double, withLong long: Double) {
        let location = Locations(context: DataController.shared.viewContext)
        location.latitude = lat
        location.longitude = long
        try? DataController.shared.viewContext.save()
    }
    
    func getCoords() -> CLLocationCoordinate2D {
        return self.mapView.centerCoordinate
    }

}

extension MapViewController {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            //pinView!.canShowCallout = true
            //pinView!.pinTintColor = .red
            pinView!.image = UIImage(named: "a")
            //pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionViewController
        
        vc.cooords = view.annotation?.coordinate
        
        let annotation = view.annotation
        let annotationLat = annotation?.coordinate.latitude
        let annotationLong = annotation?.coordinate.longitude
        if let result = fetchResultsController.fetchedObjects {
            for pin in result {
                if pin.latitude == annotationLat && pin.longitude == annotationLong {
                    vc.location = pin
                    break
                }
            }
        }
        
        navigationController?.show(vc, sender: self)
        
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        
    }
    
}

extension MapViewController {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
    }
    
}
