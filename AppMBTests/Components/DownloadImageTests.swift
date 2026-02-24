//
//  DownloadImageTests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 23/02/26.
//

import XCTest
@testable import AppMB

final class DownloadImageTests: XCTestCase {
    private var session: URLSession!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        session = URLSession(configuration: config)
    }

    override func tearDown() {
        URLProtocolMock.reset()
        session.invalidateAndCancel()
        session = nil
        super.tearDown()
    }

    func testLoadDataUsesCache() async throws {
        var requestCount = 0
        URLProtocolMock.requestHandler = { request in
            requestCount += 1
            let response = try XCTUnwrap(HTTPURLResponse(
                url: try XCTUnwrap(request.url),
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ))
            return (response, Data([0x01, 0x02]))
        }

        let cache = NSCache<NSURL, NSData>()
        let sut = DownloadImage(session: session, cache: cache)
        let url = try XCTUnwrap(URL(string: "https://example.com/image.png"))

        _ = try await sut.loadData(url: url)
        _ = try await sut.loadData(url: url)

        XCTAssertEqual(requestCount, 1)
    }
    
    func testLoadDataInvalidResponseThrows() async throws {
        URLProtocolMock.requestHandler = { request in
            let response = try XCTUnwrap(HTTPURLResponse(
                url: try XCTUnwrap(request.url),
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            ))
            return (response, Data())
        }
        
        let sut = DownloadImage(session: session, cache: .init())
        let url = try XCTUnwrap(URL(string: "https://example.com/image.png"))
        
        do {
            _ = try await sut.loadData(url: url)
            XCTFail("Expected error")
        } catch {
            guard case NetworkError.invalidResponse = error else {
                return XCTFail("Expected NetworkError.invalidResponse")
            }
        }
    }
}
