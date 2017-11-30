//
//  HistoryItem.swift
//  ImageSearcher
//
//  Created by Phoenix on 30.11.17.
//  Copyright © 2017 Phoenix_Dev. All rights reserved.
//

import Foundation
import RealmSwift

class HistoryItem: Object {
    dynamic var requestText = ""
    dynamic var imageUrl = ""
    dynamic var searchDate = Date()
}
