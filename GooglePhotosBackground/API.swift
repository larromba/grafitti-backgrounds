//
//  API.swift
//  GooglePhotosBackground
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Foundation

enum API {
    case photoAlbums

    var url: URL {
        switch self {
        case .photoAlbums:
            return URL(string: "http://larhythmix.com/js/preload.js")!
        }
    }
}
