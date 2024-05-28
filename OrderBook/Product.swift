//
//  List.swift
//  OrderBook
//
//  Created by rajasekar.r on 20/04/24.
//

import Foundation
import SwiftData

@Model
final class Product {
    var id: String
    var name: String
    var detail: String
    var count: Int
    var isDone = false
    
    @Relationship(deleteRule: .nullify) var list: PurchaseList

    init(purchaseList: PurchaseList, id: String, name: String, detail: String, count: Int = 1) {
        self.id = id
        self.name = name
        self.detail = detail
        self.count = count
        self.list = purchaseList
    }
}
