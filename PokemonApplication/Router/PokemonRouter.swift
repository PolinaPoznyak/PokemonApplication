//
//  Router.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 3.10.23.
//

import Foundation
import UIKit

protocol PokemonRouterProtocol {
    func showPokemonDetails(for viewModels: Pokemon)
}

final class PokemonRouter: PokemonRouterProtocol {
    
    let presentingViewController: UIViewController
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    func showPokemonDetails(for viewModel: Pokemon) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailedPokemon") as? DetailedPokemonViewController {
            detailViewController.pokemon = viewModel
            presentingViewController.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
