//
//  ModelDecodingTests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 23/02/26.
//

import XCTest
@testable import AppMB

final class ModelDecodingTests: XCTestCase {
    func testDecodeExchangeMapResponse() throws {
        let json = """
        {
          "data": [{ "id": 1, "is_active": 1 }],
          "status": {
            "timestamp": "2024-01-01T00:00:00.000Z",
            "error_code": 0,
            "error_message": null,
            "elapsed": 1,
            "credit_count": 1
          }
        }
        """
        let data = try XCTUnwrap(json.data(using: .utf8))
        let decoded = try JSONDecoder().decode(ExchangeMapResponse.self, from: data)
        XCTAssertEqual(decoded.data.first?.id, 1)
        XCTAssertEqual(decoded.data.first?.isActive, 1)
        XCTAssertEqual(decoded.status.errorCode, 0)
    }
    
    func testDecodeExchangeInfoResponse() throws {
        let json = """
        {
          "data": {
            "1": {
              "id": 1,
              "name": "Binance",
              "slug": "binance",
              "description": "Desc",
              "date_launched": "2017-07-14",
              "logo": "https://logo",
              "is_active": 1,
              "spot_volume_usd": 123.4,
              "maker_fee": 0.1,
              "taker_fee": 0.2,
              "urls": { "website": ["https://binance.com"] }
            }
          },
          "status": { "timestamp": null, "error_code": 0, "error_message": null, "elapsed": 1, "credit_count": 1 }
        }
        """
        let data = try XCTUnwrap(json.data(using: .utf8))
        let decoded = try JSONDecoder().decode(ExchangeInfoResponse.self, from: data)
        let exchange = decoded.data["1"]
        XCTAssertEqual(exchange?.name, "Binance")
        XCTAssertEqual(exchange?.makerFee, 0.1)
        XCTAssertEqual(exchange?.takerFee, 0.2)
        XCTAssertEqual(exchange?.urls?.website?.first, "https://binance.com")
    }
    
    func testDecodeExchangeAssetResponse() throws {
        let json = """
        {
          "status": { "timestamp": null, "error_code": 0, "error_message": null, "elapsed": 1, "credit_count": 1 },
          "data": [
            {
              "balance": 10,
              "currency": {
                "crypto_id": 1,
                "price_usd": 10.5,
                "symbol": "ABC",
                "name": "Alpha"
              }
            }
          ]
        }
        """
        let data = try XCTUnwrap(json.data(using: .utf8))
        let decoded = try JSONDecoder().decode(ExchangeAssetResponse.self, from: data)
        XCTAssertEqual(decoded.data.first?.currency.symbol, "ABC")
        XCTAssertEqual(decoded.data.first?.currency.priceUSD, 10.5)
    }
}
