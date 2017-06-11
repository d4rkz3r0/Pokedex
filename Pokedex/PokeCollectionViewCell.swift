//
//  PokeCollectionViewCell.swift
//  Pokedex
//
//  Created by Steve Kerney on 6/10/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

//Custom Collection View Cell
//Contains a UIImageView and a UILabel

import UIKit

class PokeCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var cellSpriteImage: UIImageView!;
    @IBOutlet weak var cellNameLabel: UILabel!;
    
    var pokemon: Pokemon!;
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
        
        //Rounded Corners on Cell
        layer.cornerRadius = 10.0;
        
    }
    
    func initCell(pokemon: Pokemon) -> Void
    {
        self.pokemon = pokemon;
        cellNameLabel.text = self.pokemon.name.capitalized;
        cellSpriteImage.image = UIImage(named: "\(self.pokemon.pokedexID)");
    }
}
