//
//  MulticastDelegate.swift
//  Volt
//
//  Created by Vitalii Vynohradov on 13.01.2022.
//  source - https://stackoverflow.com/a/44697868

import Foundation

class MulticastDelegate <T> {
    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    func add(delegate: T) {
        delegates.add(delegate as AnyObject)
    }

    func remove(delegate: T) {
        for oneDelegate in delegates.allObjects.reversed() where oneDelegate === delegate as AnyObject {
            delegates.remove(oneDelegate)
        }
    }

    func invoke(invocation: (T) -> Void) {
        for delegate in delegates.allObjects.reversed() {
            invocation(delegate as! T)
        }
    }
}
