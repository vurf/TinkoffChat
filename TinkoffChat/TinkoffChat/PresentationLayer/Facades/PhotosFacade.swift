//
//  PhotosFacade.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 5/1/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

struct PhotoDisplayModel {
    let imageUrl: String
    let previewImageUrl: String
    let webformatUrl: String
}

protocol IPhotoModelDelegate: class {
    func setup(dataSource: [PhotoDisplayModel])
    func show(error message: String)
}

protocol IPhotosFacade: class {
    var delegate: IPhotoModelDelegate? { get set }
    func fetchYellowFlowers()
    func fetchImage(urlString: String, completionHandler: @escaping (UIImage?) -> ())
}

class PhotosFacade: IPhotosFacade {
    
    weak var delegate: IPhotoModelDelegate?
    
    private let photosService: IPhotosService
    
    init(photosService: IPhotosService) {
        self.photosService = photosService
    }
    
    func fetchYellowFlowers() {
        self.photosService.loadYellowFlowersPhoto { (photos: [PhotoModel]?, error) in
            
            if let photosUnwrapped = photos {
                let cells = photosUnwrapped.map({PhotoDisplayModel(imageUrl: $0.largeImageURL, previewImageUrl: $0.previewURL, webformatUrl: $0.webformatURL) })
                self.delegate?.setup(dataSource: cells)
            } else {
                self.delegate?.show(error: error ?? "error")
            }
        }
    }
    
    func fetchImage(urlString: String, completionHandler: @escaping (UIImage?) -> ()) {
      
        self.photosService.loadImage(urlString: urlString) { (imageModel: ImageModel?, error) in
            if let imageUnwrapped = imageModel {
                completionHandler(imageUnwrapped.image)
            } else {
                completionHandler(nil)
            }
        }
    }
    
}
