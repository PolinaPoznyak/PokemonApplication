//
//  PokemonInteractor.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 2.10.23.
//

import Foundation

protocol PokemonInteractorProtocol {
    func getPokemons(offset: Int?, completion: @escaping (Result<([Pokemon], String?), Error>) -> Void)
    func getPokemonSpriteURL(id: Int, completion: @escaping (String?) -> ())
}

class PokemonInteractor: PokemonInteractorProtocol {
    let pokemonService: PokemonService
    
    init(pokemonService: PokemonService) {
        self.pokemonService = pokemonService
    }
    
    func getPokemons(offset: Int?, completion: @escaping (Result<([Pokemon], String?), Error>) -> Void) {
        var apiUrl = "https://pokeapi.co/api/v2/pokemon?limit=20"
        if let offset = offset {
            apiUrl += "&offset=\(offset)"
        }
        
        Bundle.main.fetchData(url: apiUrl, model: PokemonListResponse.self) { response in
            completion(.success((response.results ?? [], response.next)))
        } failure: { error in
            completion(.failure(error))
        }
    }
    
    func getPokemonSpriteURL(id: Int, completion: @escaping (String?) -> ()) {
        pokemonService.fetchSpriteForPokemon(id: id) { spriteURL in
            completion(spriteURL)
        }
    }
}
