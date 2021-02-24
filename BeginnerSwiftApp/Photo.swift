//
//  Photo.swift
//  BeginnerSwiftApp
//
//  Created by Akdag on 24.02.2021.
//

import Foundation
struct Photo : Codable {
    var fileName : String
    var caption : String
    
    init(fileName : String , caption : String ){
        self.fileName = fileName
        self.caption = caption
    }
}
