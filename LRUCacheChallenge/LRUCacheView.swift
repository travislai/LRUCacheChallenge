//
//  LRUCacheView.swift
//  LRUCacheChallenge
//
//  Created by Travis Lai on 29/4/2025.
//

// LRUCacheView.swift
import SwiftUI

struct LRUCacheView: View {
    @StateObject private var viewModel: LRUCacheViewModel
    @State private var keyInput: String = ""
    @State private var valueInput: String = ""
    
    // Modified initializer to accept optional viewModel
    init(capacity: Int = 4, viewModel: LRUCacheViewModel? = nil) {
        if let viewModel = viewModel {
            _viewModel = StateObject(wrappedValue: viewModel)
        } else {
            _viewModel = StateObject(wrappedValue: LRUCacheViewModel(capacity: capacity))
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("LRU Cache (Capacity: \(viewModel.capacity))")
                .font(.title)
            
            HStack {
                TextField("Key", text: $keyInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Value", text: $valueInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Put") {
                    viewModel.put(key: keyInput, value: valueInput)
                    keyInput = ""
                    valueInput = ""
                }
                .disabled(keyInput.isEmpty || valueInput.isEmpty)
            }
            .padding()
            
            Button("Get Random Item") {
                viewModel.getRandomItem()
            }
            .padding()
            
            List {
                ForEach(viewModel.cacheItems, id: \.0) { key, value in
                    HStack {
                        Text("\(key)")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(value)")
                    }
                }
            }
            
            Text("Operations: \(viewModel.operationLog)")
                .font(.caption)
                .foregroundColor(.gray)
                .padding()
        }
        .padding()
    }
}


// Preview Provider
struct LRUCacheView_Previews: PreviewProvider {
    static var previews: some View {
        // Preview with empty cache
//        LRUCacheView()
        
        // Preview with pre-filled cache
        let viewModelWithData = LRUCacheViewModel(capacity: 4)
        viewModelWithData.put(key: "1", value: "One")
        viewModelWithData.put(key: "2", value: "Two")
        viewModelWithData.put(key: "3", value: "Three")
        viewModelWithData.put(key: "4", value: "Four")
        
        return LRUCacheView(viewModel: viewModelWithData)
            .previewDisplayName("With Prefilled Data")
    }
}
