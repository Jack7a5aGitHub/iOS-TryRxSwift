//
//  ImageName.swift
//  iOS-TryRxSwift
//
//  Created by Jack Wong on 2018/12/06.
//  Copyright © 2018 Jack Wong. All rights reserved.
//

import UIKit

enum ImageName: String {
    case
    Amex,
    Discover,
    Mastercard,
    Visa,
    UnknownCard
    
    var image: UIImage {
        guard let image = UIImage(named: self.rawValue) else {
            fatalError("Image not found for name \(self.rawValue)")
        }
        
        return image
    }
}
