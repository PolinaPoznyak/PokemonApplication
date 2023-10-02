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
}

// MARK: - Pokemon
struct Pokemon: Codable, Identifiable, Equatable {
    var id: Int
    let name: String?
    let url: String?
}

// MARK: - DetailPokemon
struct DetailPokemon: Codable {
    let id: Int
    let height: Int
    let weight: Int
    let types: String
}
