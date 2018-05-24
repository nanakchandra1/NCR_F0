//
//  DictionaryExtension.swift
//  WashApp
//
//  Created by Saurabh Shukla on 19/09/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//


import Foundation
extension Dictionary {
    
    ///Removes all keys having null values
    func removeNullKeys() -> [AnyHashable: Any] {
        var dict: [AnyHashable: Any] = self
        
        let keysToRemove = dict.keys.filter { (dict[$0] is NSNull) || ("\(dict[$0]!)".lowercased() == "<null>") }
        let keysToCheck = dict.keys.filter({ dict[$0] is Dictionary })
        for key in keysToRemove {
            dict.removeValue(forKey: key)
        }
        for key in keysToCheck {
            if let valueDict = dict[key] as? [AnyHashable: Any] {
                dict.updateValue(valueDict.removeNullKeys(), forKey: key)
            }
        }
        return dict
    }
    
    ///Replaces all keys having null values with given default value
    func replaceNullValues(with defaultValue:Any = "") -> [AnyHashable: Any] {
        var dict: [AnyHashable: Any] = self
        
        let keysToRemove = dict.keys.filter { (dict[$0] is NSNull) || ("\(dict[$0]!)".lowercased() == "<null>") }
        let keysToCheck = dict.keys.filter({ dict[$0] is Dictionary })
        for key in keysToRemove {
            dict[key] = defaultValue
        }
        for key in keysToCheck {
            if let valueDict = dict[key] as? [AnyHashable: Any] {
                dict.updateValue(valueDict.replaceNullValues(), forKey: key)
            }
        }
        return dict
    }
    
    /**
     Checks if a key exists in the dictionary.
     
     :param: key Key to check
     :returns: true if the key exists
     */
    func has (key: Key) -> Bool {
        return index(forKey: key) != nil
    }
    /**
     Creates an Array with values of self through the mapFunction.
     :param: mapFunction
     :returns: Mapped array
     */
    func toArray <V> (map: (Key, Value) -> V) -> [V] {
        
        var mapped = [V]()
        
        for (key,value) in self {
            mapped.append(map(key, value))
        }
        return mapped
    }
    /**
     Creates a Dictionary with keys and values generated by running
     each [key: value] of self through the mapFunction.
     
     :param: mapFunction
     :returns: Mapped dictionary
     */
    func map <K, V> (map: (Key, Value) -> (K, V)) -> [K: V] {
        
        var mapped = [K: V]()
        
        for (key,value) in self {
            let (_key, _value) = map(key, value)
            mapped[_key] = _value
        }
        return mapped
    }
    /**
     Creates a Dictionary with keys and values generated by running
     each [key: value] of self through the mapFunction discarding nil return values.
     
     :param: mapFunction
     :returns: Mapped dictionary
     */
    func mapFilter <K, V> (map: (Key, Value) -> (K, V)?) -> [K: V] {
        
        var mapped = [K: V]()
        
        for (key,value) in self {
            if let value = map(key, value) {
                mapped[value.0] = value.1
            }
        }
        return mapped
    }
    
    /**
     Constructs a dictionary containing every [key: value] pair from self
     for which testFunction evaluates to true.
     
     :param: testFunction Function called to test each key, value
     :returns: Filtered dictionary
     */
    func filter (test: (Key, Value) -> Bool) -> Dictionary {
        
        var result = Dictionary()
        
        for (key, value) in self {
            if test(key, value) {
                result[key] = value
            }
        }
        
        return result
        
    }
    
    /**
     Checks if test evaluates true for all the elements in self.
     
     :param: test Function to call for each element
     :returns: true if test returns true for all the elements in self
     */
    func all (test: (Key, Value) -> (Bool)) -> Bool {
        
        for (key, value) in self {
            if !test(key, value) {
                return false
            }
        }
        
        return true
        
    }
    
    /**
     Checks if test evaluates true for any element of self.
     
     :param: test Function to call for each element
     :returns: true if test returns true for any element of self
     */
    func any (test: (Key, Value) -> (Bool)) -> Bool {
        
        for (key, value) in self {
            if test(key, value) {
                return true
            }
        }
        
        return false
        
    }
}
