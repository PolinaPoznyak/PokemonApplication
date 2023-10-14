//
//  DetailedPokemonPresenter.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 14.10.23.
//

import Foundation
import UIKit

protocol DetailedPokemonPresenterProtocol {
    func showDetailedPokemon(for viewModel: Pokemon, completion: @escaping (DetailPokemon?) -> ())
    func getPokemonSpriteImage(id: Int, completion: @escaping (UIImage?) -> ())
}

final class DetailedPokemonPresenter: DetailedPokemonPresenterProtocol {
    
    
    // MARK: - Properties
    
    let interactor: DetailedPokemonInteractorProtocol
    
    // MARK: - init
    
    init(interactor: DetailedPokemonInteractorProtocol) {
        self.interactor = interactor
    }
    
    func showDetailedPokemon(for viewModel: Pokemon, completion: @escaping (DetailPokemon?) -> ()) {
        interactor.getDetailedPokemon(id: viewModel.id) { (detailPokemon: DetailPokemon) in
            DispatchQueue.main.async {
                completion(detailPokemon)
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
}
