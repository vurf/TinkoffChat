//
//  PhotoCollectionViewCell.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 5/1/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let idenfitifier : String = "PhotoCollectionViewCell"
    
    @IBOutlet weak var imageView : UIImageView!
    
    var photoDisplayModel: PhotoDisplayModel?
    
    func configure(image: UIImage, photoDisplayModel: PhotoDisplayModel) {
        self.imageView.image = image
        self.photoDisplayModel = photoDisplayModel
    }
}

