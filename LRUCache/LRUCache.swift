//
//  LRUCache.swift
//  LRUCacheChallenge
//
//  Created by Travis Lai on 29/4/2025.
//

// LRUCache.swift
import Foundation

final class LRUCache<Key: Hashable, T> {
    private let capacity: Int
    private var cache: [Key: Node<Key, T>] = [:]
    private let head = Node<Key, T>(key: nil, value: nil)
    private let tail = Node<Key, T>(key: nil, value: nil)
    
    init(capacity: Int) {
        self.capacity = capacity
        head.next = tail
        tail.prev = head
    }
    
    func get(_ key: Key) -> T? {
        guard let node = cache[key] else { return nil }
        moveToHead(node)
        return node.value
    }
    
    func put(_ key: Key, value: T) {
        if let node = cache[key] {
            node.value = value
            moveToHead(node)
            return
        }
        
        let newNode = Node(key: key, value: value)
        cache[key] = newNode
        addToHead(newNode)
        
        if cache.count > capacity {
            if let lastNode = removeTail() {
                cache.removeValue(forKey: lastNode.key!)
            }
        }
    }
    
    private func addToHead(_ node: Node<Key, T>) {
        node.prev = head
        node.next = head.next
        head.next?.prev = node
        head.next = node
    }
    
    private func removeNode(_ node: Node<Key, T>) {
        node.prev?.next = node.next
        node.next?.prev = node.prev
    }
    
    private func moveToHead(_ node: Node<Key, T>) {
        removeNode(node)
        addToHead(node)
    }
    
    private func removeTail() -> Node<Key, T>? {
        guard let lastNode = tail.prev, lastNode !== head else { return nil }
        removeNode(lastNode)
        return lastNode
    }
    
    func getAllItems() -> [(Key, T)] {
        var items: [(Key, T)] = []
        var currentNode = head.next
        while currentNode !== tail, let node = currentNode {
            if let key = node.key, let value = node.value {
                items.append((key, value))
            }
            currentNode = node.next
        }
        return items
    }
}

private class Node<Key, T> {
    var key: Key?
    var value: T?
    var prev: Node?
    var next: Node?
    
    init(key: Key?, value: T?) {
        self.key = key
        self.value = value
    }
}
