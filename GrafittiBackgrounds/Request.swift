//
//  Request.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Foundation

protocol Request {
    var url: URL { get }
    var httpVerb: HTTPVerb { get }

    func createResponse(with data: Data) throws -> Response
}
