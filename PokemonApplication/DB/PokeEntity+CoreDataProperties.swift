//
//  PokeEntity+CoreDataProperties.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 5.10.23.
//
//

import Foundation
import CoreData


extension PokeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokeEntity> {
        return NSFetchRequest<PokeEntity>(entityName: "PokeEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var url: String?

}

extension PokeEntity : Identifiable {

}
