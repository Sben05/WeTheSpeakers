//
//  Model.swift
//  We The Speakers
//
//  Created by Shreeniket Bendre on 10/18/20.
//  Copyright © 2020 Shreeniket Bendre. All rights reserved.
//

import Foundation
import UIKit

struct Model {
    var text: String
    var color: UIColor
    var sentiment: String
    
    init(text: String, color: UIColor, sentiment: String) {
        self.text = text
        self.color = color
        self.sentiment = sentiment
    }
}
