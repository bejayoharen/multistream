//
//  MiscError.swift
//  MultiStream
//
//  Created by Bjorn Roche on 3/17/17.
//  Copyright © 2017 multistream. All rights reserved.
//

import Foundation

// I am probably forgetting something that there isn't an easy built-in way to handle
// simple errors.
class MiscError: LocalizedError {
    let description: String
    init(description:String) {
        self.description=description;
    }
    public var errorDescription: String? {
        return description;
    }
}
