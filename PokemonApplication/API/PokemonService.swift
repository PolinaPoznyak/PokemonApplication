//
//  PokemonService.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 2.10.23.
//

import Foundation
import UIKit

struct PokemonService {
    
    let apiUrl = "https://pokeapi.co/api/v2/pokemon?limit=20"
    
    func fetchPokemons(completion: @escaping (Result<PokemonListResponse, Error>) -> Void) {
        Bundle.main.fetchData(url: apiUrl, model: PokemonListResponse.self, completion: { (response: PokemonListResponse) in
            completion(.success(response))
        }, failure: { (error: Error) in
            completion(.failure(error))
        })
    }
    
    func fetchSpriteForPokemon(id: Int, _ completion:@escaping (String?) -> ()) {
        Bundle.main.fetchData(url: "https://pokeapi.co/api/v2/pokemon/\(id)/", model: DetailPokemon.self) { detailPokemon in
            if let spriteURL = detailPokemon.sprites.frontDefault {
                completion(spriteURL.absoluteString)
            } else {
                completion(nil)
            }
        } failure: { error in
            print(error)
            completion(nil)
        }
    }
    
    func fetchDetailedPokemon(id: Int, _ completion:@escaping (DetailPokemon) -> ()) {
        Bundle.main.fetchData(url: "https://pokeapi.co/api/v2/pokemon/\(id)/", model: DetailPokemon.self) { data in
            completion(data)
        } failure: { error in
            print(error)
        }
    }
}
