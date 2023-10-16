//
//  PokemonEndPoint.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 13.10.23.
//

import Foundation

public enum PokemonApi {
    case pokemonsList(offset: Int, limit: Int)
    case detailedPokemon(id: Int)
}

extension PokemonApi: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: "https://pokeapi.co/api/v2/") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .pokemonsList:
            return "pokemon"
        case .detailedPokemon(let id):
            return "pokemon/\(id)"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .pokemonsList(let offset, let limit):
            return .requestParameters(bodyParameters: nil,
                                      urlParameters: ["offset": offset, "limit": limit])
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}


