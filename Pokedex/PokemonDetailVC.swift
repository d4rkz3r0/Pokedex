//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Steve Kerney on 6/11/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController
{
    //ViewController Data
    var pokemonToDisplay : Pokemon!;
    
    //U.I. Vars
    //Nav Bar
    @IBAction func backButtonPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: {});
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //Curr Pokemon Info
    @IBOutlet weak var currPokemonNameLabel: UILabel!
    @IBOutlet weak var currPokemonImage: UIImageView!
    @IBOutlet weak var currPokemonInfoLabel: UILabel!
    @IBOutlet weak var currPokemonTypeLabel: UILabel!
    @IBOutlet weak var currPokemonDexID: UILabel!
    @IBOutlet weak var currPokemonATKLabel: UILabel!
    @IBOutlet weak var currPokemonDEFLabel: UILabel!
    @IBOutlet weak var currPokemonHeightLabel: UILabel!
    @IBOutlet weak var currPokemonWeightLabel: UILabel!
    //Evolution Info
    @IBOutlet weak var secondEvoImage: UIImageView!
    @IBOutlet weak var evolutionLVLLabel: UILabel!
    
    
    //Init
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        let firstLetterCapitalized = String(pokemonToDisplay.name.characters.prefix(1)).uppercased();
        let restOfName = String(pokemonToDisplay.name.characters.dropFirst());
        let displayName = "\(firstLetterCapitalized)\(restOfName)";
        currPokemonNameLabel.text = displayName.uppercased();
        
        
        let pokedexID_Str = "\(pokemonToDisplay.pokedexID)";
        currPokemonDexID.text = pokedexID_Str;

        let currImg = UIImage(named: pokedexID_Str);
        currPokemonImage.image = currImg;
        currPokemonImage.layer.borderColor = UIColor(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 0.75).cgColor;
        currPokemonImage.layer.borderWidth = 3;
        
        segmentedControl.isHidden = true;
        
        
        pokemonToDisplay.downloadDetails
            {
                //Called upon completion of network call.
                self.updatePokemonUIElements();
            }
    }
    
    func updatePokemonUIElements()
    {
        currPokemonATKLabel.text =  pokemonToDisplay.atk;
        currPokemonDEFLabel.text =  pokemonToDisplay.def;
        currPokemonHeightLabel.text =  pokemonToDisplay.height;
        currPokemonWeightLabel.text =  pokemonToDisplay.weight;
        currPokemonTypeLabel.text = pokemonToDisplay.type;
        currPokemonInfoLabel.text = pokemonToDisplay.info;
        if(pokemonToDisplay.nextEvolutionID.isEmpty)
        {
            evolutionLVLLabel.text = "Pokemon is fully evolved.";
            secondEvoImage.isHidden = true;
        }
        else
        {
            secondEvoImage.isHidden = false;
            secondEvoImage.image = UIImage(named: pokemonToDisplay.nextEvolutionID);
            secondEvoImage.layer.borderColor = UIColor(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 0.75).cgColor;
            secondEvoImage.layer.borderWidth = 3;
            let evolutionInfoStr = "Next Evolution: \(pokemonToDisplay.nextEvolutionName) @ LVL: \(pokemonToDisplay.nextEvolutionLVL)";
            evolutionLVLLabel.text = evolutionInfoStr;
        }
    }
}
