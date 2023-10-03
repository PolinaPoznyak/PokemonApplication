//
//  CustomTableViewCell.swift
//  PokemonApplication
//
//  Created by Polina Poznyak on 2.10.23.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var pokemonView: UIView!
    @IBOutlet weak var spriteImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
