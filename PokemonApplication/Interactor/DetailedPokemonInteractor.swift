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
        pokemonService.fetchDetailedPokemon(id: id) { result in
            switch result {
            case .success(let detailPokemon):
                completion(detailPokemon)
            case .failure:
                completion(DetailPokemon(id: 0, height: 0, weight: 0, types: [], sprites: Sprites(frontDefault: nil)))
            }
        }
    }
    
    func getPokemonSpriteURL(id: Int, completion: @escaping (String?) -> ()) {
        pokemonService.fetchSpriteForPokemon(id: id) { result in
            switch result {
            case .success(let spriteURL):
                completion(spriteURL)
            case .failure:
                completion(nil)
            }
        }
    }
}
