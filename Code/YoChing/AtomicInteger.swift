//
//  AtomicInteger.swift
//  YoChing
//
//  Created by Wellington Moreno on 5/16/17.
//  Copyright © 2017 YoChing.net. All rights reserved.
//

import Foundation


class AtomicInteger {
    
    private let lock = DispatchSemaphore(value: 1)
    private var value = 0
    
    init() {
        self.value = 0
    }
    
    init(value: Int) {
        self.value = value
    }
    
    func get() -> Int {
        
        lock.wait()
        defer { lock.signal() }
        
        return value
    }
    
    func set(_ newValue: Int) {
        
        lock.wait()
        defer { lock.signal() }
        
        self.value = newValue
    }
    
    func incrementAndGet() -> Int {
        
        lock.wait()
        defer { lock.signal() }
        
        value += 1
        return value
    }
    
    func decrementAndGet() -> Int {
        
        lock.wait()
        defer { lock.signal() }
        
        value -= 1
        return value
    }
    
}
