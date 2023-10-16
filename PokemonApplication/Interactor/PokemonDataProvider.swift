//
//  PokemonDataProvider.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 14.10.23.
//

import Foundation

class PokemonDataProvider {
    private let pokemonService: PokemonService
    private let databaseService: PokemonDBServiceProtocol
    private let limit: Int = 20
    private var hasClearedCache = false
    
    init(pokemonService: PokemonService, databaseService: PokemonDBServiceProtocol) {
        self.pokemonService = pokemonService
        self.databaseService = databaseService
    }
    
    func fetchPokemonSpriteURL(id: Int, completion: @escaping (String?) -> ()) {
        pokemonService.fetchSpriteForPokemon(id: id) { result in
            switch result {
            case .success(let spriteURL):
                completion(spriteURL)
            case .failure:
                completion(nil)
            }
        }
    }
    
    func fetchPokemons(offset: Int?, completion: @escaping (Result<([Pokemon], Int?), Error>) -> Void) {
        if NetworkUtility.isConnectedToNetwork() {
            databaseService.clearCachedPokemonData()
            fetchPokemonsFromAPI(offset: offset, completion: completion)
        } else {
            fetchPokemonsFromDatabase(completion: completion)
        }
    }
    
    private func fetchPokemonsFromAPI(offset: Int?, completion: @escaping (Result<([Pokemon], Int?), Error>) -> Void) {
        let newOffset = offset ?? 0
        
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
    }
    
    private func fetchPokemonsFromDatabase(completion: @escaping (Result<([Pokemon], Int?), Error>) -> Void) {
        let cachedPokemons = databaseService.loadCachedPokemons()
        completion(.success((cachedPokemons, nil)))
    }
}
