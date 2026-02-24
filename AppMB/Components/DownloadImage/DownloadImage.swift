//
//  DownloadImage.swift
//  AppMB
//
//  Created by Miguel Lopes on 18/02/26.
//

import Foundation

// MARK: - DownloadImage

actor DownloadImage {
    static let shared = DownloadImage()

    private let session: URLSession
    private let cache: NSCache<NSURL, NSData>

    init(session: URLSession = .shared, cache: NSCache<NSURL, NSData> = .init()) {
        self.session = session
        self.cache = cache
    }

    func loadData(url: URL) async throws -> Data {
        if let cachedData = cache.object(forKey: url as NSURL) {
            return Data(referencing: cachedData)
        }

        try Task.checkCancellation()
        let (data, response) = try await session.data(from: url)
        try Task.checkCancellation()

        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        cache.setObject(data as NSData, forKey: url as NSURL)
        return data
    }
}
