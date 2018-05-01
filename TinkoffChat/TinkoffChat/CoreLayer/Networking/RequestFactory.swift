//
//  RequestFactory.swift
//  TinkoffChat
//
//  Created by Илья Варфоломеев on 5/1/18.
//  Copyright © 2018 TCS. All rights reserved.
//

import Foundation

struct RequestsFactory {
    
    struct ImagesRequests {
        
        static func photoYellowFlowersConfig() -> RequestConfig<PhotoParser> {
            let request = PhotoRequest(apiKey: "8868552-d296293bdcb4bdca2ba7fa783")
            return RequestConfig<PhotoParser>(request:request, parser: PhotoParser())
        }
        
        static func generateImageConfig(urlString: String) -> RequestConfig<ImageParser> {
            let request = ImageRequest(urlString: urlString)
            return RequestConfig<ImageParser>(request: request, parser: ImageParser())
        }
    }
}
