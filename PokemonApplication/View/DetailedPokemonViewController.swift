//
//  DetailedPokemonViewController.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 3.10.23.
//

import UIKit

class DetailedPokemonViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonType: UILabel!
    @IBOutlet weak var pokemonWeight: UILabel!
    @IBOutlet weak var pokemonHeight: UILabel!
    
    // MARK: - Properties
    
    var presenter: PokemonPresenterProtocol!
    var pokemon: Pokemon?
    var detaildPokemon: DetailPokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = PokemonPresenter(interactor: PokemonInteractor(pokemonService: PokemonService()), router: PokemonRouter(presentingViewController: self))
        
        presenter.showDetailedPokemon(for: pokemon!) { [weak self] detailPokemon in
            if let detailPokemon = detailPokemon {
                self?.detaildPokemon = detailPokemon
                self?.updateUI()
            }
        }
    }
    
    private func updateUI() {
        pokemonName.text = "Name: \(pokemon?.name ?? "")"
        
        configureHeight()
        configureWeight()
        configureTypes()
        configureSprite()
    }
    
    // MARK: - Configuration
    
    func configureHeight() {
        if let height = detaildPokemon?.height {
            pokemonHeight.text = "Height: \(height) M"
        } else {
            pokemonHeight.text = "Height: N/A"
        }
    }
    
    func configureWeight() {
        if let weight = detaildPokemon?.weight {
            pokemonWeight.text = "Weight: \(weight) KG"
        } else {
            pokemonWeight.text = "Weight: N/A"
        }
    }
    
    func configureTypes() {
        if let types = detaildPokemon?.types {
            var typeText = "Types: "
            for type in types {
                if let typeName = type.type?.name {
                    typeText += typeName + ", "
                }
            }
            if !types.isEmpty {
                typeText.removeLast(2)
            }
            pokemonType.text = typeText
        }
    }
    
    func configureSprite() {
        presenter.getPokemonSpriteImage(id: pokemon!.id) { image in
            DispatchQueue.main.async { [self] in
                if let pokemonImage = image {
                    pokemonImg.image = pokemonImage
                } else {
                    print("No image")
                }
            }
        }
    }
}
