//
//  LRUCacheTests.swift
//  LRUCacheChallengeTests
//
//  Created by Travis Lai on 29/4/2025.
//

// LRUCacheTests.swift
import XCTest
@testable import LRUCacheChallenge

class LRUCacheTests: XCTestCase {
    
    func testBasicOperations() {
        // Given
        let cache = LRUCache<String, Int>(capacity: 2)
        
        // When
        cache.put("A", value: 1)
        cache.put("B", value: 2)
        
        // Then
        XCTAssertEqual(cache.get("A"), 1)
        XCTAssertEqual(cache.get("B"), 2)
        XCTAssertNil(cache.get("C"))
    }
    
    func testEvictionWhenCapacityExceeded() {
        // Given
        let cache = LRUCache<String, Int>(capacity: 2)
        cache.put("A", value: 1)
        cache.put("B", value: 2)
        
        // When
        cache.put("C", value: 3) // This should evict "A"
        
        // Then
        XCTAssertNil(cache.get("A"))
        XCTAssertEqual(cache.get("B"), 2)
        XCTAssertEqual(cache.get("C"), 3)
    }
    
    func testAccessUpdatesItemPosition() {
        // Given
        let cache = LRUCache<String, Int>(capacity: 2)
        cache.put("A", value: 1)
        cache.put("B", value: 2)
        
        // When
        _ = cache.get("A") // Access "A" to make it most recently used
        cache.put("C", value: 3) // This should now evict "B" instead of "A"
        
        // Then
        XCTAssertEqual(cache.get("A"), 1)
        XCTAssertNil(cache.get("B"))
        XCTAssertEqual(cache.get("C"), 3)
    }
    
    func testGetAllItemsOrder() {
        // Given
        let cache = LRUCache<String, String>(capacity: 3)
        
        // When
        cache.put("1", value: "One")
        cache.put("2", value: "Two")
        cache.put("3", value: "Three")
        
        // Then
        let items = cache.getAllItems()
        XCTAssertEqual(items.count, 3)
        XCTAssertEqual(items[0].0, "3") // Most recent
        XCTAssertEqual(items[1].0, "2")
        XCTAssertEqual(items[2].0, "1") // Least recent
        
        // When - Access "1" to make it most recent
        _ = cache.get("1")
        
        // Then
        let updatedItems = cache.getAllItems()
        XCTAssertEqual(updatedItems[0].0, "1") // Now most recent
        XCTAssertEqual(updatedItems[1].0, "3")
        XCTAssertEqual(updatedItems[2].0, "2") // Now least recent
    }
    
    func testEdgeCaseCapacityOne() {
        // Given
        let cache = LRUCache<Int, String>(capacity: 1)
        
        // When
        cache.put(1, value: "One")
        
        // Then
        XCTAssertEqual(cache.get(1), "One")
        
        // When
        cache.put(2, value: "Two") // Should evict 1
        
        // Then
        XCTAssertNil(cache.get(1))
        XCTAssertEqual(cache.get(2), "Two")
    }
    
    func testEmptyCache() {
        // Given
        let emptyCache = LRUCache<String, Int>(capacity: 2)
        
        // When & Then
        XCTAssertNil(emptyCache.get("A"))
        XCTAssertEqual(emptyCache.getAllItems().count, 0)
    }
}
