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
    
    var pokemon: Pokemon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonName.text = "Name: \(pokemon?.name ?? "")"
    }
}

// MARK: - Extensions

extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else { return }
        
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                    self?.image = loadedImage
                }
            }
        }
    }
}
