//
//  PokemonInteractor.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 2.10.23.
//

import Foundation
import UIKit
import CoreData

protocol PokemonInteractorProtocol {
    func getPokemons(offset: Int?, completion: @escaping (Result<([Pokemon], String?), Error>) -> Void)
    func getPokemonSpriteURL(id: Int, completion: @escaping (String?) -> ())
    func getDetailedPokemon(id: Int, completion: @escaping (DetailPokemon) -> ())
}

class PokemonInteractor: PokemonInteractorProtocol {
    let pokemonService: PokemonService
    private var hasClearedCache = false
    
    init(pokemonService: PokemonService) {
        self.pokemonService = pokemonService
    }
    
    func getPokemons(offset: Int?, completion: @escaping (Result<([Pokemon], String?), Error>) -> Void) {
        if NetworkUtility.isConnectedToNetwork() {
            if !hasClearedCache {
                clearCachedPokemonData()
                hasClearedCache = true
            }
            
            var apiUrl = "https://pokeapi.co/api/v2/pokemon?limit=20"
            if let offset = offset {
                apiUrl += "&offset=\(offset)"
            }
            
            Bundle.main.fetchData(url: apiUrl, model: PokemonListResponse.self) { response in
                DispatchQueue.main.async {
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    
                    for pokemon in response.results ?? [] {
                        let pokemonEntity = PokeEntity(context: context)
                        pokemonEntity.id = Int32(pokemon.id)
                        pokemonEntity.name = pokemon.name
                        pokemonEntity.url = pokemon.url
                    }
                    
                    do {
                        try context.save()
                    } catch {
                        print("Error saving to CoreData: \(error)")
                    }
                    
                    completion(.success((response.results ?? [], response.next)))
                }
            } failure: { error in
                completion(.failure(error))
            }
        } else {
            loadCachedPokemons(completion: completion)
        }
    }

    func loadCachedPokemons(completion: @escaping (Result<([Pokemon], String?), Error>) -> Void) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PokeEntity> = PokeEntity.fetchRequest()
        
        do {
            let pokemonEntities = try context.fetch(fetchRequest)
            let cachedPokemons = pokemonEntities.map { entity in
                Pokemon(name: entity.name, url: entity.url)
            }
            
            completion(.success((cachedPokemons, nil)))
        } catch {
            print("Error fetching from CoreData: \(error)")
            completion(.failure(error))
        }
    }

    func clearCachedPokemonData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PokeEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print("Error clearing cached data: \(error)")
        }
    }
    
    func getPokemonSpriteURL(id: Int, completion: @escaping (String?) -> ()) {
        pokemonService.fetchSpriteForPokemon(id: id) { spriteURL in
            completion(spriteURL)
        }
    }
    
    func getDetailedPokemon(id: Int, completion: @escaping (DetailPokemon) -> ()) {
        pokemonService.fetchDetailedPokemon(id: id) { detailPokemon in
            completion(detailPokemon)
        }
    }
}
