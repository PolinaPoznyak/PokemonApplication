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
    let pokemonDataProvider: PokemonDataProvider
    
    init(pokemonDataProvider: PokemonDataProvider) {
        self.pokemonDataProvider = pokemonDataProvider
    }
    
    func getPokemons(offset: Int?, completion: @escaping (Result<([Pokemon], Int?), Error>) -> Void) {
        pokemonDataProvider.fetchPokemons(offset: offset, completion: completion)
    }
    
    func getPokemonSpriteURL(id: Int, completion: @escaping (String?) -> ()) {
        pokemonDataProvider.fetchPokemonSpriteURL(id: id, completion: completion)
    }
}
