//
//  PokemonDBService.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 13.10.23.
//

import Foundation
import CoreData
import UIKit

protocol PokemonDBServiceProtocol {
    func savePokemons(_ pokemons: [Pokemon])
    func getPokemon(byId id: Int) -> Pokemon?
    func loadCachedPokemons() -> [Pokemon]
    func clearCachedPokemonData()
    func getPokemonCount() -> Int
}

final class PokemonDBService: PokemonDBServiceProtocol {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func savePokemons(_ pokemons: [Pokemon]) {
        let context = appDelegate.persistentContainer.viewContext
        
        for pokemon in pokemons {
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
    }


    func getPokemon(byId id: Int) -> Pokemon? {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<PokeEntity>(entityName: "PokeEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let result = try context.fetch(fetchRequest)
            if let pokeEntity = result.first {
                return Pokemon(name: pokeEntity.name, url: pokeEntity.url)
            }
        } catch {
            print("Error fetching Pokemon from Core Data: \(error)")
        }

        return nil
    }

    func loadCachedPokemons() -> [Pokemon] {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<PokeEntity>(entityName: "PokeEntity")

        do {
            let entities = try context.fetch(fetchRequest)
            let pokemons = entities.map { Pokemon(name: $0.name, url: $0.url) }
            return pokemons
        } catch {
            print("Error fetching all Pokemon from Core Data: \(error)")
        }

        return []
    }
    
    func clearCachedPokemonData() {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PokeEntity.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print("Error clearing cached data: \(error)")
        }
    }
    
    func getPokemonCount() -> Int {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PokeEntity.fetchRequest()

        do {
            let count = try context.count(for: fetchRequest)
            return count
        } catch {
            print("Error counting cached data: \(error)")
            return 0
        }
    }
}
