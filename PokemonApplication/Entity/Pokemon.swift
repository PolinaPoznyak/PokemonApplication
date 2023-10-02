//
//  Pokemon.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 2.10.23.
//

import Foundation

// MARK: - PokemonListResponse
struct PokemonListResponse: Codable {
    let count: Int?
    let next: String?
    let results: [Pokemon]?
    
    var nextOffset: Int? {
        guard let nextUrl = next,
              let urlComponents = URLComponents(string: nextUrl),
              let offsetItem = urlComponents.queryItems?.first(where: { $0.name == "offset" }),
              let offsetValue = offsetItem.value else {
            return nil
        }
        return Int(offsetValue)
    }
}

// MARK: - Pokemon
struct Pokemon: Codable, Identifiable, Equatable {
    var id: Int {
        if let urlString = url, let url = URL(string: urlString) {
            let components = url.pathComponents
            if let idString = components.last, let id = Int(idString) {
                return id
            }
        }
        return 0
    }
    let name: String?
    let url: String?
    
    static var samplePokemon = Pokemon(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/ ")
}

// MARK: - DetailPokemon
struct DetailPokemon: Codable {
    let id: Int
    let height: Int
    let weight: Int
    let types: String
}
