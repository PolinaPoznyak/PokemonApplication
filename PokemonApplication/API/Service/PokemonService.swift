//
//  PokemonService.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 2.10.23.
//

import Foundation
import UIKit

struct PokemonService {
    private let router = Router<PokemonApi>()
    
    func getListOfPokemons(offset: Int, limit: Int, completion: @escaping (_ pokemonList: PokemonListResponse?, _ error: String?) -> ()) {
        router.request(.pokemonsList(offset: offset, limit: limit)) { data, response, error in
            if let error = error {
                completion(nil, "Please check your network connection. Error: \(error)")
            } else if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(for: response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkError.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(PokemonListResponse.self, from: responseData)
                        completion(apiResponse, nil)
                    } catch {
                        completion(nil, NetworkError.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError.rawValue)
                }
            } else {
                completion(nil, "Invalid response from the server")
            }
        }
    }
    
    func fetchDetailedPokemon(id: Int, completion: @escaping (Result<DetailPokemon, Error>) -> Void) {
        router.request(.detailedPokemon(id: id)) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(for: response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(NetworkError.noData))
                        return
                    }
                    do {
                        let detailPokemon = try JSONDecoder().decode(DetailPokemon.self, from: responseData)
                        completion(.success(detailPokemon))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let networkFailureError):
                    completion(.failure(networkFailureError))
                }
            } else {
                completion(.failure(NetworkError.invalidResponse))
            }
        }
    }

    func fetchSpriteForPokemon(id: Int, completion: @escaping (Result<String, Error>) -> Void) {
        router.request(.detailedPokemon(id: id)) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(for: response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(NetworkError.noData))
                        return
                    }
                    do {
                        let detailPokemon = try JSONDecoder().decode(DetailPokemon.self, from: responseData)
                        if let spriteURL = detailPokemon.sprites.frontDefault {
                            completion(.success(spriteURL.absoluteString))
                        } else {
                            completion(.failure(NetworkError.spriteNotFound))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let networkFailureError):
                    completion(.failure(networkFailureError))
                }
            } else {
                completion(.failure(NetworkError.invalidResponse))
            }
        }
    }

}

fileprivate func handleNetworkResponse(for response: HTTPURLResponse?) -> Result<String, NetworkError>{

    guard let response = response else { return Result.failure(NetworkError.noResponse)}

    switch response.statusCode {
    case 200...299: return .success(NetworkError.success.rawValue)
    case 401...500: return .failure(NetworkError.authenticationError)
    case 501...599: return .failure(NetworkError.badRequest)
    case 600: return .failure(NetworkError.outdated)
    default: return .failure(NetworkError.failed)
    }
}
