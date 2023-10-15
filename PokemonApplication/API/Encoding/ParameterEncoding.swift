//
//  ParameterEncoding.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 15.10.23.
//

import Foundation

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
 static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}
