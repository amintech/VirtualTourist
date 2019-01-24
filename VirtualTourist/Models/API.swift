//
//  API.swift
//  VirtualTourist
//
//  Created by  AminSaleh on 13/05/1440 AH.
//  Copyright © 1440 AminTech. All rights reserved.
//

import Foundation
import UIKit

class API {
    
    struct Constants {
        
        static let apiKey = "d636037e29b6076f222db8696922bdf5"
        
    }
    
    static func getPhotos(_ lon: String, _ lat: String, completion: @escaping ([String]?, Error?) -> ()) {
        
        let request = URLRequest(url: URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.apiKey)&lat=\(lat)&lon=\(lon)&extras=url_m&format=json&nojsoncallback=1")!)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
                return
            }
            
            //print (String(data: data!, encoding: .utf8)!)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                
                completion(nil, statusCodeError)
                return
            }
            
            if statusCode >= 200 && statusCode < 300 {
                
                let jsonObject = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                
//                guard let jsonDictionary = jsonObject as? [String : Any] else {return}
//
//
//                guard let resultsArray = jsonDictionary["photos"] as? [String : Any] else {return}
//
//                guard let photo = resultsArray["photo"] as? [[String : Any]] else {return}
//
//                let photoDictionary = photo[1] as [String: Any]
//
//                let imgURL = photoDictionary["url_m"] as! String
//
//                print(imgURL)
                
                guard let jsonDictionary = jsonObject as? [String : Any] else {return}
                
                guard let resultsArray = jsonDictionary["photos"] as? [String : Any] else {return}
                
                guard let photo = resultsArray["photo"] as? [[String : Any]] else {return}
                
                //guard let image = photo["url_m"] as? [String : Any] else {return}
 //                let photoDictionary = photo[1] as [String: Any]
//
//                let imgURL = photoDictionary["url_m"] as! String
                
                //print(imgURL)
                
                if photo.count == 0 {
                    let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                    completion(nil, statusCodeError)
                    return
                }
                
                var imagesString: [String] = []
                
                for i in 0...photo.count - 1 {
                    let photoDictionary = photo[i] as [String: Any]
                    let imgURL = photoDictionary["url_m"] as! String
                    print(imgURL)
                    
                    imagesString.append(imgURL)
                
                }
                
//
                //let pngData = UIImage()
                
                //let dataObject = try! JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
                //print (dataObject)
                //let LocationsTemp = try! JSONDecoder().decode([Locations].self, from: dataObject)
                
                completion(imagesString, nil)
            }
        }
        
        task.resume()
    }
    
}
