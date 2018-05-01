//
//  IPhotosViewControllerDelegate.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 5/1/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit

protocol IPhotosViewControllerDelegate: class {
    
    func collectionPickerController(_ picker: PhotosViewController, didFinishPickingImage image: UIImage)
}
