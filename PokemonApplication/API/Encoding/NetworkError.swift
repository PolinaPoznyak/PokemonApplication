//
//  NetworkError.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 15.10.23.
//

import Foundation

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil"
    case encodingFailed = "Parameter Encoding failed"
    case decodingFailed = "Unable to Decode data"
    case missingURL = "The URL is nil"
    case couldNotParse = "Unable to parse the JSON response"
    case noData = "Data is nil"
    case fragmentResponse = "Response's body has fragments"
    case authenticationError = "You must be authenticated"
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated"
    case unableToDecode = "We coould not decode the response"
    case pageNotFound = "Page not found"
    case spriteNotFound = "Sprite URL not found"
    case invalidResponse = "Invalid response from the server"
    case failed = "Request failed"
    case serverError = "Server error"
    case noResponse = "No response"
    case success = "Success"
}
