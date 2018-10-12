//
//  DataManager.swift
//  GrafittiBackgrounds
//
//  Created by Lee Arromba on 03/12/2017.
//  Copyright © 2017 Pink Chicken. All rights reserved.
//

import Foundation

// sourcery: name = DataManger
protocol DataManaging: Mockable {
    func save(_ data: Data?, key: String)
    func load(key: String) -> Data?
}

final class DataManger: DataManaging {
    private let db = UserDefaults.standard

    func save(_ data: Data?, key: String) {
        db.set(data, forKey: key)
    }

    func load(key: String) -> Data? {
        return db.object(forKey: key) as? Data
    }
}
