//
//  Item.swift
//  Lost&Found
//
//  Created by Noah on 19.07.25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
