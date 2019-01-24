//
//  CollectionViewController.swift
//  VirtualTourist
//
//  Created by  AminSaleh on 13/05/1440 AH.
//  Copyright © 1440 AminTech. All rights reserved.
//

import UIKit
import MapKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionBtn: UIButton!
    
    var cooords: CLLocationCoordinate2D?
    
    var imagesInCollection : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    @IBAction func newCollectionBtn(_ sender: Any) {
        
        ActivityIndicator.aiStart(view: self.view)
        
        let lon = Double(CLLocationDegrees(cooords!.longitude))
        let lat = Double(CLLocationDegrees(cooords!.latitude))
        
        API.getPhotos(String(lon),String(lat)) { (photos, error) in
            
            DispatchQueue.main.async {
                
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
                        
                            self.imagesInCollection.append(UIImage(data: image)!)
                            self.collectionView.reloadData()
                            print("today gooooooooooooooool")
                       
                    }
                    
                    
                }
                
                
                
//                for locationStruct in locationsArray {
//
//                    let mediaURL = locationStruct.imageURL ?? " "
//
//                    let studentInfo = StudentInformation.StudentInfo.init(createdAt: created, uniqueKey: "", firstName: first, lastName: last, address: location, url: mediaURL, latitude: lat, longitude: lon)
//
//                    StudentInformation.studentInformation.append(studentInfo)
//
//                }
                
                //self.reload()
                ActivityIndicator.aiStop()
                print("collctionView reloaded")
                
            }
        }
        
    }
    
}

extension CollectionViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesInCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? CollectionViewCell else {
            fatalError("error")
        }
        //let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.image?.image = imagesInCollection[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deleteItems(at: [indexPath])
    }
    
}
