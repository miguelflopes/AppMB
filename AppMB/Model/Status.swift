//
//  Status.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

struct Status: Decodable {
    let timestamp: String?
    let errorCode: Int?
    let errorMessage: String?
    let elapsed: Int?
    let creditCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case timestamp, elapsed
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case creditCount = "credit_count"
    }
}
