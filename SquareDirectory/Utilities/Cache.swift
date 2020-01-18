
//  Created by Dylan  on 1/17/20.
//  Copyright © 2020 Dylan . All rights reserved.
//

import Foundation
import UIKit

final class Cache<Key: Hashable, Value> {
    private let wrapped = NSCache<WrappedKey, Entry>()
    
    func insert(_ value: Value, forKey key: Key) {
        let entry = Entry(value: value)
        wrapped.setObject(entry, forKey: WrappedKey(key))
    }
    
    func value(forKey key: Key) -> Value? {
        let entry = wrapped.object(forKey: WrappedKey(key))
        return entry?.value
    }
    
    func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: WrappedKey(key))
    }
    
}

extension Cache {
    subscript(key: Key) -> Value? {
        get {
            return value(forKey: key)
        }
        
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }
            insert(value, forKey: key)
        }
    }
}

//Private Extensions
private extension Cache {
    final class Entry {
        let value: Value
        
        init(value: Value) {
            self.value = value
        }
    }
}

private extension Cache {
    /* Wrap the Key values in order to make them NSCache compatible. Making the key Hashable*/
    final class WrappedKey: NSObject {
        let key: Key
        
        init(_ key: Key) {
            self.key = key
        }
        
        override var hash: Int {
            return key.hashValue
        }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            return value.key == key
        }
    }
}
