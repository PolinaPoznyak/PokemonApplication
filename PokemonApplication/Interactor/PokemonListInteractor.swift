//
//  PokemonListInteractor.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 2.10.23.
//

import Foundation
import UIKit
import CoreData

protocol PokemonListInteractorProtocol {
    func getPokemons(offset: Int?, completion: @escaping (Result<([Pokemon], Int?), Error>) -> Void)
    func getPokemonSpriteURL(id: Int, completion: @escaping (String?) -> ())
}

final class PokemonListInteractor: PokemonListInteractorProtocol {
    let pokemonService: PokemonService
    let databaseService: PokemonDBServiceProtocol
    private var hasClearedCache = false
    private let limit: Int = 20
    
    init(pokemonService: PokemonService, databaseService: PokemonDBServiceProtocol) {
        self.pokemonService = pokemonService
        self.databaseService = databaseService
    }
    
    func getPokemons(offset: Int?, completion: @escaping (Result<([Pokemon], Int?), Error>) -> Void) {
        let newOffset = offset ?? 0

        if NetworkUtility.isConnectedToNetwork() {
            if !hasClearedCache {
                databaseService.clearCachedPokemonData()
                hasClearedCache = true
            }
            
            pokemonService.getListOfPokemons(offset: newOffset, limit: limit) { response, error in
                if error != nil {
                    completion(.failure(NetworkError.failed))
                } else if let pokemonList = response?.results {
                    
                    self.databaseService.savePokemons(pokemonList)
                    completion(.success((pokemonList, response?.nextOffset)))
                } else {
                    completion(.failure(NetworkError.failed))
                }
            }
        } else {
            let cachedPokemons = databaseService.loadCachedPokemons()
            completion(.success((cachedPokemons, nil)))
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
