//
//  NSObject.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

// MARK: - NSObject

extension NSObject {
    
    /// String describing the class name.
    public class var className: String {
        return String(describing: self)
    }
}
