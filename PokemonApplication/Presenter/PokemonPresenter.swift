//
//  PokemonPresenter.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 2.10.23.
//

import Foundation
import UIKit

protocol PokemonPresenterProtocol {
    func showPokemon(offset: Int?, _ completion: @escaping ([Pokemon], String?) -> Void)
    func getPokemonSpriteImage(id: Int, completion: @escaping (UIImage?) -> ())
    func showPokemonDetails(for viewModel: Pokemon)
}

class PokemonPresenter: PokemonPresenterProtocol {
    
    // MARK: - Properties
    
    private var currentPage: Int = -1
    private var isFetchingData: Bool = false
    
    let interactor: PokemonInteractorProtocol
    let router: PokemonRouterProtocol
    
    // MARK: - init
    
    init(interactor: PokemonInteractorProtocol, router: PokemonRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - Interector
    
    func showPokemon(offset: Int?, _ completion: @escaping ([Pokemon], String?) -> Void) {
        var nextPageOffset = offset ?? -1
        if isFetchingData {
            return
        }
        isFetchingData = true
        
        currentPage += 1
        nextPageOffset = currentPage * 20
        
        interactor.getPokemons(offset: nextPageOffset) { result in
            switch result {
            case .success(let (pokemons, nextPageUrl)):
                self.isFetchingData = false
                completion(pokemons, nextPageOffset >= 0 ? "https://pokeapi.co/api/v2/pokemon?offset=\(nextPageOffset)&limit=20" : nil)
            case .failure(let error):
                self.isFetchingData = false
                print("Error fetching pokemons: \(error)")
                completion([], nil)
            }
        }
    }

    func getPokemonSpriteImage(id: Int, completion: @escaping (UIImage?) -> ()) {
        interactor.getPokemonSpriteURL(id: id) { spriteURL in
            if let spriteURL = spriteURL, let url = URL(string: spriteURL) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }.resume()
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    // MARK: - Router
    
    func showPokemonDetails(for viewModel: Pokemon) {
        router.showPokemonDetails(for: viewModel)
    }
}
