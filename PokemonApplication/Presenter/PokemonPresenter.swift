//
//  PokemonPresenter.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 2.10.23.
//

import Foundation

protocol PokemonPresenterProtocol {
    
}

class PokemonPresenter: PokemonPresenterProtocol {
    
    let interactor: PokemonInteractorProtocol
    
    init(interactor: PokemonInteractorProtocol) {
        self.interactor = interactor
    }
}
