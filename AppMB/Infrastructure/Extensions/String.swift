//
//  String.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

// MARK: - String

extension String {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
    
    func convertStringToDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: date)
        }
        return self
    }
    
    func replaceStringToURL(occurrence: String, with replacingString: String) -> URL? {
        return URL(string: self.replacingOccurrences(of: occurrence, with: replacingString))
    }
    
    var cleanedURL: String {
        return self.replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "http://", with: "")
            .trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }
}
