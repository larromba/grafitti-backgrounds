//
//  PhotoResourceRequest.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Foundation

struct PhotoResourceRequest: Request {
    let url: URL
    let httpVerb: HTTPVerb = .GET

    func createResponse(with data: Data) throws -> Response {
        return try PhotoResourceResponse(data: data)
    }
}
