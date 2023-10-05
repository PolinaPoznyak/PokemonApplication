//
//  PokemonServiceTests.swift
//  PokemonApplicationTests
//
//  Created by Polina Poznyak on 5.10.23.
//

import XCTest
@testable import PokemonApplication

final class PokemonServiceTests: XCTestCase {
    func testFetchPokemons() {
        let pokemonService = PokemonService()
        
        let expectation = XCTestExpectation(description: "FetchPokemons")
        
        pokemonService.fetchPokemons { result in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response, "Response should not be nil")
                XCTAssertTrue(response.results?.count ?? 0 > 0, "There should be some Pokémon in the response")
                expectation.fulfill()
                
            case .failure(let error):
                XCTFail("Fetching Pokémon failed with error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFetchDetailedPokemon() {
        let pokemonService = PokemonService()
        let pokemonID = 1

        let expectation = XCTestExpectation(description: "FetchDetailedPokemon")
        
        pokemonService.fetchDetailedPokemon(id: pokemonID) { detailPokemon in
            XCTAssertNotNil(detailPokemon, "Detail Pokemon should not be nil")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
