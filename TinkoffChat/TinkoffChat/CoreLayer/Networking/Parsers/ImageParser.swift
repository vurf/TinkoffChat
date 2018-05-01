//
//  ImageParser.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 5/1/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation
import UIKit

struct ImageModel {
    let image: UIImage
}

class ImageParser: IParser {    
    typealias Model = ImageModel
    
    func parse(data: Data) -> ImageParser.Model? {
        
        if let image = UIImage(data: data) {
            return ImageModel(image: image)
        }
        
        return nil
    }
}
