//
//  LRUCacheViewModel.swift
//  LRUCacheChallenge
//
//  Created by Travis Lai on 29/4/2025.
//

import SwiftUI

class LRUCacheViewModel: ObservableObject {
    private var cache: LRUCache<String, String>
    let capacity: Int
    
    @Published var cacheItems: [(String, String)] = []
    @Published var operationLog: String = ""
    
    init(capacity: Int) {
        self.capacity = capacity
        self.cache = LRUCache<String, String>(capacity: capacity)
        updateItems()
    }
    
    func put(key: String, value: String) {
        cache.put(key, value: value)
        updateItems()
        operationLog = "Put (\(key): \(value))"
    }
    
    func getRandomItem() {
        let items = cache.getAllItems()
        guard !items.isEmpty else {
            operationLog = "Cache is empty"
            return
        }
        
        let randomIndex = Int.random(in: 0..<items.count)
        let (key, _) = items[randomIndex]
        
        if let value = cache.get(key) {
            updateItems()
            operationLog = "Get (\(key): \(value))"
        } else {
            operationLog = "Key \(key) not found"
        }
    }
    
    private func updateItems() {
        cacheItems = cache.getAllItems().reversed() // Show most recent first
    }
}
