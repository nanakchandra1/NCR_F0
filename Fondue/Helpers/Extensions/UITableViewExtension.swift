//
//  UITableViewExtension.swift
//  WashApp
//
//  Created by Saurabh Shukla on 19/09/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//


import Foundation
import UIKit

//MARK:-
extension UITableView {
    
    ///Returns cell for the given item
    func cell(forItem item: Any) -> UITableViewCell? {
        if let indexPath = self.indexPath(forItem: item){
            return self.cellForRow(at: indexPath)
        }
        return nil
    }
    
    ///Returns the indexpath for the given item
    func indexPath(forItem item: Any) -> IndexPath? {
        let itemPosition: CGPoint = (item as AnyObject).convert(CGPoint.zero, to: self)
        return self.indexPathForRow(at: itemPosition)
    }
    
    ///Registers the given cell
    func registerClass(cellType:UITableViewCell.Type){
        register(cellType, forCellReuseIdentifier: cellType.defaultReuseIdentifier)
    }
    
    ///dequeues a reusable cell for the given indexpath
    func dequeueReusableCellForIndexPath<T: UITableViewCell>(indexPath: NSIndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier , for: indexPath as IndexPath) as? T else {
            fatalError( "Failed to dequeue a cell with identifier \(T.defaultReuseIdentifier). Ensure you have registered the cell." )
        }
        
        return cell
    }
}

extension UITableViewCell{
    public static var defaultReuseIdentifier:String{
        return "\(self)"
    }
}



extension UIView {
    func attributes(font: String, color: UIColor, fontSize: CGFloat, kern: Double) -> [NSAttributedStringKey : Any] {
        let attribute = [
            NSAttributedStringKey.foregroundColor: color,
            NSAttributedStringKey.kern: kern,
            NSAttributedStringKey.font : UIFont(name: font, size: fontSize)!
            ] as [NSAttributedStringKey : Any]
        return attribute
    }
}
