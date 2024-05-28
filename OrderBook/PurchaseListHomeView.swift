//
//  ContentView.swift
//  OrderBook
//
//  Created by rajasekar.r on 20/04/24.
//

import SwiftUI
import SwiftData

struct PurchaseListHomeView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: [SortDescriptor(\PurchaseList.name, order: .forward)], animation: .easeInOut) private var items: [PurchaseList]
    
    @State var isCreateFormPresented = false
    @State var newListName: String = ""

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { list in
                    NavigationLink {
                        ProductListView(purchaseList: list)
                    } label: {
                        Text(list.name)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Purchase List")
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
        } detail: {
            Text("Select an item")
        }
        .alert("Create Purchase List", isPresented: $isCreateFormPresented) {
            TextField("Enter Product Name", text: $newListName)
            Button("Save", action: addItem)
            Button("Cancel", role: .cancel, action: {})
        }
    }
}


extension PurchaseListHomeView {
    private func addItem() {
        guard !newListName.isEmpty else { return }
        withAnimation {
            let newItem = PurchaseList(id: UUID().uuidString, name: newListName)
            modelContext.insert(newItem)
            newListName = ""
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}


#Preview {
    PurchaseListHomeView()
        .modelContainer(for: PurchaseList.self, inMemory: true)
}
