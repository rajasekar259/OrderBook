//
//  ProductListView.swift
//  OrderBook
//
//  Created by rajasekar.r on 20/04/24.
//

import SwiftUI

struct ProductListItemView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservableModel var product: Product
    @State var isMarked: Bool
   
    @State var isAlertPresented = false
    var onDeleteClick: ((Product) -> Void)?
    
    var body: some View {
        Stepper(
            label: {
                HStack {
                    Toggle(isOn: $isMarked, label: {
                        VStack(alignment: .leading) {
                            Text(product.name)
                                .fontWeight(.semibold)
                                .font(.title3)
                                .foregroundStyle(.primary)
                            Text(product.detail)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    })
                    .toggleStyle(.button)
                    .onChange(of: isMarked, { product.isDone = isMarked })
                    
                    Spacer()
                    
                    Text("\(product.count)")
                        .fontWeight(.semibold)
                        .font(.title2)
                        .foregroundStyle(.primary)
                        .contentTransition(.numericText(value: Double(product.count)))
                        .animation(.spring, value: product.count)
                }
            },
            onIncrement: { product.count = min(Int.max, product.count + 1) },
            onDecrement: {
                let newCount = max(0, product.count - 1)
                if newCount <= 0 {
                    isAlertPresented = true
                } else {
                    product.count = newCount
                }
                
            }
        )
        .alert("Are you sure to remove this item?", isPresented: $isAlertPresented, actions: {
            
            Button("Yes", role: .destructive, action: {
               onDeleteClick?(product)
            })
        })
    }
}

#Preview {
    ProductListItemView(product: Product(purchaseList: .init(id: "PurchaseListID", name: "List Name"), id: "id", name: "Name", detail: "Detail"), isMarked: false)
}
