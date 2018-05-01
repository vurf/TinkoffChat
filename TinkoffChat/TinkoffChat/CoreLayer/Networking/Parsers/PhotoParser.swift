//
//  PhotoParser.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 5/1/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

struct PhotoModel {
    let previewURL: String
    let largeImageURL: String
    let webformatURL: String
}

class PhotoParser: IParser {
    typealias Model = [PhotoModel]
    
    func parse(data: Data) -> PhotoParser.Model? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else {
                return nil
            }
            
            guard let hits = json["hits"] as? [[String:Any]] else {
                    return nil
            }
            
            var photos: [PhotoModel] = []
            
            for hit in hits {
                guard let photoPreviewURL = hit["previewURL"] as? String,
                    let photoLargeImageURL = hit["largeImageURL"] as? String,
                    let webformatURL = hit["webformatURL"] as? String
                    else { continue }
                
                photos.append(PhotoModel(previewURL: photoPreviewURL, largeImageURL: photoLargeImageURL, webformatURL: webformatURL))
            }
            
            return photos
            
        } catch  {
            print("error trying to convert data to JSON")
            return nil
        }
    }
    
    
}
