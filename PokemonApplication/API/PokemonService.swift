//
//  PokemonService.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 2.10.23.
//

import Foundation

struct PokemonService {
    
    let apiUrl = "https://pokeapi.co/api/v2/pokemon?limit=20"
    
    func fetchPokemons(completion: @escaping (Result<PokemonListResponse, Error>) -> Void) {
        Bundle.main.fetchData(url: apiUrl, model: PokemonListResponse.self, completion: { (response: PokemonListResponse) in
            completion(.success(response))
        }, failure: { (error: Error) in
            completion(.failure(error))
        })
    }
}
