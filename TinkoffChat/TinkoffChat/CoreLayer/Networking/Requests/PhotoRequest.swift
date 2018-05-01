//
//  PhotoRequest.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 5/1/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

class PhotoRequest: IRequest {
    private let baseUrl: String = "https://pixabay.com/"
    private let apiVersion: String = "api/"
    private let search: String = "yellow+flowers"
    private let perPage: String = "150"
    private let imageType: String = "photo"
    private let apiKey: String
    
    private var urlString: String {
        let params = "key=\(self.apiKey)&q=\(self.search)&image_type=\(self.imageType)&pretty=true&per_page=\(self.perPage)"
        return self.baseUrl + self.apiVersion + "?" + params
    }
    
    var urlRequest: URLRequest? {
        get {
            
            if let url = URL(string: self.urlString) {
                return URLRequest(url: url)
            }
            
            return nil
        }
    }
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
}
