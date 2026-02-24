//
//  EndpointTests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 23/02/26.
//

import XCTest
@testable import AppMB

final class EndpointTests: XCTestCase {
    func testAPIEndpointBuildsURLRequestWithQueryAndHeaders() throws {
        let endpoint = DummyEndpoint()
        let request = try XCTUnwrap(endpoint.urlRequest)
        
        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
        XCTAssertEqual(request.value(forHTTPHeaderField: "X-Test"), "1")
        XCTAssertEqual(request.url?.absoluteString, "https://example.com/v1/test?q=1")
    }
    
    func testMarketEndpointMapQueryItems() {
        let endpoint = MarketEndpoint.map(start: 1, limit: 20)
        let items = endpoint.queryItems ?? []
        XCTAssertTrue(items.contains(URLQueryItem(name: "start", value: "1")))
        XCTAssertTrue(items.contains(URLQueryItem(name: "limit", value: "20")))
    }
    
    func testMarketEndpointInfoQueryItems() {
        let endpoint = MarketEndpoint.info(ids: "1,2")
        let items = endpoint.queryItems ?? []
        XCTAssertTrue(items.contains(URLQueryItem(name: "id", value: "1,2")))
    }
    
    func testMarketEndpointAssetsQueryItems() {
        let endpoint = MarketEndpoint.assets(id: 42)
        let items = endpoint.queryItems ?? []
        XCTAssertTrue(items.contains(URLQueryItem(name: "id", value: "42")))
    }
}

private struct DummyEndpoint: APIEndpoint {
    let baseURL: String = "https://example.com"
    let path: String = "/v1/test"
    let method: HTTPMethod = .get
    let headers: [String: String]? = ["X-Test": "1"]
    let queryItems: [URLQueryItem]? = [URLQueryItem(name: "q", value: "1")]
}
