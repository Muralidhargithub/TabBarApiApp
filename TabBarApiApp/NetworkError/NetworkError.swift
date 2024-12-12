//
//  NetworkError.swift
//  TabBarApiApp
//
//  Created by Muralidhar reddy Kakanuru on 12/11/24.
//


enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingFailed(Error)
    case invvalidImageData
    case invalidResponse
    case invalidData
    case invalidJSON
}
