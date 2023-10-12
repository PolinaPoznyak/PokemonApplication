//
//  PokemonListViewController.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 2.10.23.
//

import UIKit

class PokemonListViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var pokemonTable: UITableView!
    
    // MARK: - Properties
    
    var presenter: PokemonPresenterProtocol!
    var viewModels: [Pokemon] = []
    var selectedPokemon: Pokemon?
    var nextPageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonTable.delegate = self
        pokemonTable.dataSource = self
        
        presenter = PokemonPresenter(interactor: PokemonInteractor(pokemonService: PokemonService()), router: PokemonRouter(presentingViewController: self))
            
        if !presenter.isInternetAvailable() {
            showNoInternetConnectionAlert()
        }
        
        presenter.showPokemon(offset: nil) { (viewModels, nextPageUrl) in
            DispatchQueue.main.async {
                self.viewModels = viewModels
                self.nextPageUrl = nextPageUrl
                self.pokemonTable.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = pokemonTable.indexPathForSelectedRow {
            pokemonTable.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    public func showNoInternetConnectionAlert() {
        let alertController = UIAlertController(title: "No Internet Connection", message: "You are in online mode, and cached data is available. Please check your internet connection to access updated information.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }

}

// MARK: - Extensions

extension PokemonListViewController: UITableViewDelegate {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPokemon = viewModels[indexPath.row]
        presenter.showPokemonDetails(for: viewModels[indexPath.row])
    }
}


extension PokemonListViewController: UITableViewDataSource {
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
                    cell.spriteImg.image = UIImage(named: "pokemon-logo")
                }
            }
        }
        
        return cell
    }
}
