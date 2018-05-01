//
//  ImageRequst.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 5/1/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

class ImageRequest: IRequest {
    
    var urlString: String
    
    var urlRequest: URLRequest? {
        get {
            if let url = URL(string: self.urlString) {
                return URLRequest(url: url)
            }
            
            return nil
        }
    }
    
    init(urlString: String) {
        self.urlString = urlString
    }
}
