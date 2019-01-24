//
//  ActivityIndicator.swift
//  VirtualTourist
//
//  Created by  AminSaleh on 15/05/1440 AH.
//  Copyright © 1440 AminTech. All rights reserved.
//

import Foundation
import UIKit

struct ActivityIndicator {
    
    private static var ai :UIActivityIndicatorView = UIActivityIndicatorView()
    
    static func aiStart(view: UIView) {
        
        ai.center = view.center
        ai.hidesWhenStopped = true
        ai.style = .gray
        view.addSubview(ai)
        ai.startAnimating()
        
    }
    
    static func aiStop() {
        
        ai.stopAnimating()
        
    }
    
}
