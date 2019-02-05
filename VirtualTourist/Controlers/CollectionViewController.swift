//
//  CollectionViewController.swift
//  VirtualTourist
//
//  Created by  AminSaleh on 13/05/1440 AH.
//  Copyright © 1440 AminTech. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionBtn: UIButton!
    
    var fetchResultsController: NSFetchedResultsController<LocationImages>!
    
    var location : Locations!
    
    var cooords: CLLocationCoordinate2D?
    
    var imagesInCollection : [UIImage] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        fetch()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        newCollectionBtn.isEnabled = false

        ActivityIndicator.aiStart(view: self.view)
        
        let lon = Double(CLLocationDegrees(cooords!.longitude))
        let lat = Double(CLLocationDegrees(cooords!.latitude))
        
        if fetchResultsController.fetchedObjects?.count == 0 {
        
            API.getPhotos(String(lon),String(lat)) { (photos, error) in
                
                if error != nil {
                    
                    ActivityIndicator.aiStop()
                    
                    let errorAlert = UIAlertController(title: "Erorr performing request", message: "There was an error performing your request", preferredStyle: .alert )
                    
                    errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                    return
                }
                
                guard let photosToShow = photos else {
                    
                    ActivityIndicator.aiStop()
                    let locationsErrorAlert = UIAlertController(title: "Erorr loading locations", message: "There was an error loading locations", preferredStyle: .alert )
                    
                    locationsErrorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(locationsErrorAlert, animated: true, completion: nil)
                    return
                    
                }
                
                for photoToShow in photosToShow {
                    
                    let imageToShow = URL(string: photoToShow)
                    if let image = try? Data(contentsOf: imageToShow!){
                        
                        //self.imagesInCollection.append(UIImage(data: image)!)
                        DispatchQueue.main.async {
                            self.saveToCoreData(data: image)
                            self.collectionView.reloadData()
                        }
                        
                        //self.saveToCoreData(data: image)
                        
                        print(self.fetchResultsController.fetchedObjects?.count ?? 10000)
                        print("today 3 gooooooooooooooool")
                        
                    }
                    
                }
                
                //self.reload()
                DispatchQueue.main.async {
                    ActivityIndicator.aiStop()
                    self.newCollectionBtn.isEnabled = true
                    print("collctionView reloaded")
                }
                
        }

        } else {
       
            self.newCollectionBtn.isEnabled = true
            ActivityIndicator.aiStop()
            
            }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try? DataController.shared.viewContext.save()
    }
    
    func saveToCoreData(data: Data) {

        let photo = LocationImages(context: DataController.shared.viewContext)
        
        photo.imageData = data
        photo.creationDate = Date()
        photo.imageURL = ""
        photo.location = self.location
        //fetchResultsController.managedObjectContext.insert(photo)
        try? DataController.shared.viewContext.save()
        
    }
    
    fileprivate func fetch() {

        let fetchRequest: NSFetchRequest<LocationImages> = LocationImages.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let predicate = NSPredicate(format: "location == %@", location)
        fetchRequest.predicate = predicate
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        fetchResultsController.delegate = self

        do {
            try fetchResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }

    }
    
    @IBAction func newCollectionBtn(_ sender: Any) {
        
        newCollectionBtn.isEnabled = false
        
        ActivityIndicator.aiStart(view: self.view)
        
        
            if let result = self.fetchResultsController.fetchedObjects {
                for pin in result {
                    
                    DataController.shared.viewContext.delete(pin)
                    
                    try? DataController.shared.viewContext.save()
                    print("today 4 gooooooooooooooool")
                }
            }
        
        //imagesInCollection.removeAll()
        collectionView.reloadData()
        print("BOOOOOOOOOOOOOOOOM")
        
        let lon = Double(CLLocationDegrees(cooords!.longitude))
        let lat = Double(CLLocationDegrees(cooords!.latitude))
        
        API.getPhotos(String(lon),String(lat)) { (photos, error) in
            
                if error != nil {
                    
                    ActivityIndicator.aiStop()
                    
                    let errorAlert = UIAlertController(title: "Erorr performing request", message: "There was an error performing your request", preferredStyle: .alert )
                    
                    errorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                    return
                }
                
                guard let photosToShow = photos else {
                    
                    ActivityIndicator.aiStop()
                    let locationsErrorAlert = UIAlertController(title: "Erorr loading locations", message: "There was an error loading locations", preferredStyle: .alert )
                    
                    locationsErrorAlert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                        return
                    }))
                    self.present(locationsErrorAlert, animated: true, completion: nil)
                    return
                    
                }
                
                for photoToShow in photosToShow {
                    
                    let imageToShow = URL(string: photoToShow)
                    if let image = try? Data(contentsOf: imageToShow!){
                        
                        //self.imagesInCollection.append(UIImage(data: image)!)
                        DispatchQueue.main.async {
                            self.saveToCoreData(data: image)
                            self.collectionView.reloadData()
                        }
                        
                        //self.saveToCoreData(data: image)
                        print(self.fetchResultsController.fetchedObjects?.count ?? 10000)
                        print("today 3 gooooooooooooooool")
                        
                    }
                    
                }
                
                //self.reload()
            DispatchQueue.main.async {
                ActivityIndicator.aiStop()
                self.newCollectionBtn.isEnabled = true
                print("collctionView reloaded")
            }
            
        }
        
    }
    
}

extension CollectionViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("helllllllo")
        return fetchResultsController.fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? CollectionViewCell else {
            fatalError("error")
        }
        
        cell.ActivityIndicatorController.startAnimating()
    
        let image = UIImage(data: fetchResultsController.object(at: indexPath).imageData!)
        
        cell.image?.image = image
        
        print("cell recreted")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
            //self.imagesInCollection.remove(at: indexPath.row)
            //collectionView.deleteItems(at: [indexPath])
            //collectionView.reloadData()
            let task = fetchResultsController.object(at: indexPath)
            DataController.shared.viewContext.delete(task)
            //try? DataController.shared.viewContext.save()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! CollectionViewCell
        cell.ActivityIndicatorController.stopAnimating()
        cell.ActivityIndicatorController.hidesWhenStopped = true
    }
    
}

extension CollectionViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            
            collectionView.insertItems(at: [newIndexPath!])
            
            print("inserted")
            break
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
            print("deleted")
            break
        case .update:
            collectionView.reloadItems(at: [indexPath!])
            print("update")
        case .move:
            collectionView.moveItem(at: indexPath!, to: newIndexPath!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        try? DataController.shared.viewContext.save()
        //collectionView.reloadData()
    }

}

