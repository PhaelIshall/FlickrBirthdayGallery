//
//  Photo.swift
//  Test
//
//  Created by Wiem Ben Rim on 9/10/16.
//  Copyright © 2016 Wiem Ben Rim. All rights reserved.
//

import Foundation
import UIKit

struct Photo {
    var id: String
    var title: String
    var farm: String
    var secret: String
    var server: String
    var imageURL: URL {
        get {
            let url = URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
            return url
        }
    }
}

