//
//  ProductListView.swift
//  OrderBook
//
//  Created by rajasekar.r on 20/04/24.
//

import SwiftUI

@propertyWrapper @Observable class ObservableModel<T> {
    var wrappedValue: T
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}

struct ProductListView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservableModel var purchaseList: PurchaseList
    
    @State var isCreateFormPresented = false
    
    @State var newProductName = ""
    @State var newProductDescription = ""
    
    var body: some View {
        List {
            ForEach(purchaseList.products.sorted(by: {
                if $0.isDone != $1.isDone {
                    return $1.isDone
                }
                return $0.name < $1.name
            }), id: \.self, content: { product in
                ProductListItemView(product: product, isMarked: product.isDone) { product in
                    purchaseList.products.removeAll(where: { $0.id == product.id })
                    modelContext.delete(product)
                    try? modelContext.save()
                }
            }).onDelete(perform: deleteItems)
        }
        .navigationTitle(purchaseList.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button(action: { isCreateFormPresented = true }) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .alert("Create a product", isPresented: $isCreateFormPresented) {
            TextField("Enter Product Name", text: $newProductName)
            TextField("Enter Detail", text: $newProductDescription)
            Button("Save", action: addItem)
            Button("Cancel", role: .cancel, action: {})
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            purchaseList.products.enumerated()
                .sorted(by: {
                    if $0.element.isDone != $1.element.isDone {
                        return $1.element.isDone
                    }
                    return $0.element.name < $1.element.name
                })
                .enumerated().filter { offsets.contains($0.offset) }
                .map { $0.element }
                .sorted(by:  { $0.offset > $1.offset })
                .forEach {
                    purchaseList.products.remove(at: $0.offset)
                    modelContext.delete($0.element)
                }
            
            try? modelContext.save()
        }
    }
    
    private func addItem() {
        guard !newProductName.isEmpty else { return }
        
        withAnimation {
            let product = Product(purchaseList: purchaseList, id: UUID().uuidString, name: newProductName, detail: newProductDescription)
            newProductName = ""
            newProductDescription = ""
            purchaseList.products.append(product)
            try? modelContext.save()
        }
    }
}

#Preview {
    ProductListView(purchaseList: .init(id: "Id", name: "List Name"))
}
