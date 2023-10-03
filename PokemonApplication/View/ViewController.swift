//
//  ViewController.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 2.10.23.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var pokemonTable: UITableView!
    
    // MARK: - Properties
    
    var presenter: PokemonPresenterProtocol!
    var viewModels: [Pokemon] = []
    var nextPageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonTable.delegate = self
        pokemonTable.dataSource = self
        
        presenter = PokemonPresenter(interactor: PokemonInteractor(pokemonService: PokemonService()))
            
        presenter.showPokemon(offset: nil) { (viewModels, nextPageUrl) in
            DispatchQueue.main.async {
                self.viewModels = viewModels
                self.nextPageUrl = nextPageUrl
                self.pokemonTable.reloadData()
            }
        }
    }
}

// MARK: - Extensions

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModels.count - 1, let nextPageUrl = nextPageUrl {
            presenter.showPokemon(offset: nil) { (newViewModels, newNextPageUrl) in
                DispatchQueue.main.async {
                    self.viewModels.append(contentsOf: newViewModels)
                    self.nextPageUrl = newNextPageUrl
                    self.pokemonTable.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        let viewModel = viewModels[indexPath.row]
        
        cell.nameLbl.text = viewModel.name
        
        presenter.getPokemonSpriteImage(id: viewModel.id) { image in
            DispatchQueue.main.async {
                if let pokemonImage = image {
                    cell.spriteImg.image = pokemonImage
                } else {
                    print("No image")
                }
            }
        }
        
        return cell
    }
}
