//
//  Log.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 02/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Foundation

func log(_ msg: String) {
    #if DEBUG
        print(msg)
    #endif
}
