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
    func getPokemons(offset: Int?, completion: @escaping (Result<([Pokemon], String?), Error>) -> Void)
    func getPokemonSpriteURL(id: Int, completion: @escaping (String?) -> ())
}

final class PokemonListInteractor: PokemonListInteractorProtocol {
    let pokemonService: PokemonService
    let databaseService: PokemonDBServiceProtocol
    private var hasClearedCache = false
    
    init(pokemonService: PokemonService, databaseService: PokemonDBServiceProtocol) {
        self.pokemonService = pokemonService
        self.databaseService = databaseService
    }
    
    func getPokemons(offset: Int?, completion: @escaping (Result<([Pokemon], String?), Error>) -> Void) {
        if NetworkUtility.isConnectedToNetwork() {
            if !hasClearedCache {
                databaseService.clearCachedPokemonData()
                hasClearedCache = true
            }
            
            var apiUrl = "https://pokeapi.co/api/v2/pokemon?limit=20"
            if let offset = offset {
                apiUrl += "&offset=\(offset)"
            }
            
            Bundle.main.fetchData(url: apiUrl, model: PokemonListResponse.self) { response in
                DispatchQueue.main.async {
                    self.databaseService.savePokemons(response.results ?? [])
                    
                    completion(.success((response.results ?? [], response.next)))
                }
            } failure: { error in
                completion(.failure(error))
            }
        } else {
            let cachedPokemons = databaseService.loadCachedPokemons()
            completion(.success((cachedPokemons, nil)))
        }
    }
    
    func getPokemonSpriteURL(id: Int, completion: @escaping (String?) -> ()) {
        pokemonService.fetchSpriteForPokemon(id: id) { spriteURL in
            completion(spriteURL)
        }
    }
}
