//
//  DetailedPokemonInteractor.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 14.10.23.
//

import Foundation
import UIKit
import CoreData

protocol DetailedPokemonInteractorProtocol {
    func getDetailedPokemon(id: Int, completion: @escaping (DetailPokemon) -> ())
    func getPokemonSpriteURL(id: Int, completion: @escaping (String?) -> ())
}

final class DetailedPokemonInteractor: DetailedPokemonInteractorProtocol {
    let pokemonService: PokemonService
    let databaseService: PokemonDBServiceProtocol
    
    init(pokemonService: PokemonService, databaseService: PokemonDBServiceProtocol) {
        self.pokemonService = pokemonService
        self.databaseService = databaseService
    }
    
    func getDetailedPokemon(id: Int, completion: @escaping (DetailPokemon) -> ()) {
        pokemonService.fetchDetailedPokemon(id: id) { detailPokemon in
            completion(detailPokemon)
        }
    }
    
    func getPokemonSpriteURL(id: Int, completion: @escaping (String?) -> ()) {
        pokemonService.fetchSpriteForPokemon(id: id) { spriteURL in
            completion(spriteURL)
        }
    }
}
