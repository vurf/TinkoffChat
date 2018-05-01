//
//  PhotosService.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 5/1/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

protocol IPhotosService {
    
    func loadYellowFlowersPhoto(completionHandler: @escaping ([PhotoModel]?, String?) -> Void)
    
    func loadImage(urlString: String, completionHandler: @escaping (ImageModel?, String?) -> ())
}

class PhotosService: IPhotosService {
    
    private let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func loadYellowFlowersPhoto(completionHandler: @escaping ([PhotoModel]?, String?) -> Void) {
        let requestConfig = RequestsFactory.ImagesRequests.photoYellowFlowersConfig()
        
        self.requestSender.send(requestConfig: requestConfig) { (result: Result<[PhotoModel]>) in
            switch result {
            case .success(let photos):
                completionHandler(photos, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    func loadImage(urlString: String, completionHandler: @escaping (ImageModel?, String?) -> ()) {
        let requestConfig = RequestsFactory.ImagesRequests.generateImageConfig(urlString: urlString)
        self.requestSender.send(requestConfig: requestConfig) { (result: Result<ImageModel>) in
            switch result {
            case .success(let photos):
                completionHandler(photos, nil)
            case .error(let error):
                completionHandler(nil, error)
            }
        }
    }
}
