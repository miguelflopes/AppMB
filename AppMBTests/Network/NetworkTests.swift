//
//  NetworkTests.swift
//  AppMBTests
//
//  Created by Miguel Lopes on 23/02/26.
//

import XCTest
@testable import AppMB

final class NetworkTests: XCTestCase {
    private var session: URLSession!
    private var sut: Network!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        session = URLSession(configuration: config)
        sut = Network(session: session)
    }

    override func tearDown() {
        URLProtocolMock.reset()
        session.invalidateAndCancel()
        session = nil
        sut = nil
        super.tearDown()
    }

    func testExecuteSuccessDecodesResponse() async throws {
        let expected = StubResponse(value: "ok")
        let data = try JSONEncoder().encode(expected)
        URLProtocolMock.requestHandler = { request in
            let response = try XCTUnwrap(HTTPURLResponse(
                url: try XCTUnwrap(request.url),
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ))
            return (response, data)
        }

        let result: StubResponse = try await sut.execute(DummyEndpoint())
        XCTAssertEqual(result, expected)
    }

    func testExecuteBadRequestThrows() async {
        URLProtocolMock.requestHandler = { request in
            let response = try XCTUnwrap(HTTPURLResponse(
                url: try XCTUnwrap(request.url),
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil
            ))
            return (response, Data())
        }

        do {
            let _: StubResponse = try await sut.execute(DummyEndpoint())
            XCTFail("Expected error")
        } catch {
            guard case NetworkError.badRequest = error else {
                return XCTFail("Expected NetworkError.badRequest")
            }
        }
    }

    func testExecuteServerErrorThrows() async {
        URLProtocolMock.requestHandler = { request in
            let response = try XCTUnwrap(HTTPURLResponse(
                url: try XCTUnwrap(request.url),
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            ))
            return (response, Data())
        }

        do {
            let _: StubResponse = try await sut.execute(DummyEndpoint())
            XCTFail("Expected error")
        } catch {
            guard case NetworkError.serverError = error else {
                return XCTFail("Expected NetworkError.serverError")
            }
        }
    }

    func testExecuteInvalidURLThrows() async {
        do {
            let _: StubResponse = try await sut.execute(InvalidEndpoint())
            XCTFail("Expected error")
        } catch {
            guard case NetworkError.invalidURL = error else {
                return XCTFail("Expected NetworkError.invalidURL")
            }
        }
    }
}

private struct StubResponse: Codable, Equatable {
    let value: String
}

private struct DummyEndpoint: APIEndpoint {
    let baseURL: String = "https://example.com"
    let path: String = "/test"
    let method: HTTPMethod = .get
    let headers: [String: String]? = ["X-Test": "1"]
    let queryItems: [URLQueryItem]? = [URLQueryItem(name: "q", value: "1")]
}

private struct InvalidEndpoint: APIEndpoint {
    let baseURL: String = ""
    let path: String = ""
    let method: HTTPMethod = .get
    let headers: [String: String]? = nil
    let queryItems: [URLQueryItem]? = nil
    var urlRequest: URLRequest? { nil }
}
