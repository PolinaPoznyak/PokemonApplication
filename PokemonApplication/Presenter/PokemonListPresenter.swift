//
//  PokemonListPresenter.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 2.10.23.
//

import Foundation
import UIKit

protocol PokemonListPresenterProtocol {
    func isInternetAvailable() -> Bool
    func showPokemon(offset: Int?, _ completion: @escaping ([Pokemon], Int?) -> Void)
    func getPokemonSpriteImage(id: Int, completion: @escaping (UIImage?) -> ())
    func showPokemonDetails(for viewModel: Pokemon)
}

final class PokemonListPresenter: PokemonListPresenterProtocol {
    
    // MARK: - Properties
    
    private var currentPage: Int = -1
    private var isFetchingData: Bool = false
    
    let interactor: PokemonListInteractorProtocol
    let router: PokemonRouterProtocol
    
    // MARK: - init
    
    init(interactor: PokemonListInteractorProtocol, router: PokemonRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func isInternetAvailable() -> Bool {
        return NetworkUtility.isConnectedToNetwork()
    }
    
    // MARK: - Interector
    
    func showPokemon(offset: Int?, _ completion: @escaping ([Pokemon], Int?) -> Void) {
        var nextPageOffset = offset ?? -1
        if isFetchingData {
            return
        }
        isFetchingData = true
        
        currentPage += 1
        nextPageOffset = currentPage * 20
        
        interactor.getPokemons(offset: nextPageOffset) { result in
            switch result {
            case .success(let (pokemons, newOffset)):
                self.isFetchingData = false
                completion(pokemons, nextPageOffset)
            case .failure(_):
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
