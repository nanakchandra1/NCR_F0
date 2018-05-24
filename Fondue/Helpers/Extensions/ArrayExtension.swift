//
//  ArrayExtention.swift
//  WoshApp
//
//  Created by Saurabh Shukla on 19/09/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//


import Foundation
extension Array where Element : Equatable {
    
    ///Removes a given object from array if present. otherwise does nothing
    mutating func removeObject(_ object : Iterator.Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    ///Removes an array of objects
    mutating func removeObjects(array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
    
    ///Removes all null values present in an Array
    mutating func removeNullValues(){
        self = self.flatMap { $0 }
    }
    
    ///Returns a sub array within the range
    subscript(range: Range<Int>) -> Array {
        
        var array = Array<Element>()

        let min = range.lowerBound
        let max = range.upperBound
        
        for i in min..<max {
            array = array+[self[i]]
        }
        return array
    }
}

