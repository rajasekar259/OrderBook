//
//  Item.swift
//  OrderBook
//
//  Created by rajasekar.r on 20/04/24.
//

import Foundation
import SwiftData

@Model
final class PurchaseList: ObservableObject {
    var id: String
    var name: String
    
    @Relationship(deleteRule: .cascade) var products = [Product]()
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
}
