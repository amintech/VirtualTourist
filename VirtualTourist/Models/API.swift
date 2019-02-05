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
        
        let request = URLRequest(url: URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Constants.apiKey)&lat=\(lat)&lon=\(lon)&extras=url_m&per_page=100&format=json&nojsoncallback=1")!)
        
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
                
                guard let jsonDictionary = jsonObject as? [String : Any] else {return}
                
                guard let resultsArray = jsonDictionary["photos"] as? [String : Any] else {return}
                
                guard let photo = resultsArray["photo"] as? [[String : Any]] else {return}

                

                if photo.count == 0 {
                    let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                    completion(nil, statusCodeError)
                    return
                }
                
                var imagesString: [String] = []
                
                let loop1 = photo.count - 1
                
                for i in 0...8 {
                    if loop1 > i {
                        let randomPhotoIndex = Int(arc4random_uniform(UInt32(loop1)))
                        print(randomPhotoIndex)
                        let photoDictionary = photo[randomPhotoIndex] as [String: Any]
                        if let imgURL = photoDictionary["url_m"] as? String {
                            imagesString.append(imgURL)
                        }
                        //print(imgURL)
                    } else {
                        
                        break
                        
                    }
                    
                    
                    }
                
                completion(imagesString, nil)
            }
        }
        
        task.resume()
    }
    
    static func downloadImage( imagePath:String, completionHandler: @escaping (_ imageData: Data?, _ errorString: String?) -> Void){
        let session = URLSession.shared
        let imgURL = NSURL(string: imagePath)
        let request: NSURLRequest = NSURLRequest(url: imgURL! as URL)
        
        let task = session.dataTask(with: request as URLRequest) {data, response, downloadError in
            
            if downloadError != nil {
                completionHandler(nil, "Could not download image \(imagePath)")
            } else {
                
                completionHandler(data, nil)
            }
        }
        
        task.resume()
    }
    
}
