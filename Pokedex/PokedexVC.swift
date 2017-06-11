//
//  ViewController.swift
//  Pokedex
//
//  Created by Steve Kerney on 6/9/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import UIKit

/*
 Notes:
 UICollectionViewDelegate - this class is the delegate for the collection view
 UICollectionViewDataSource - this class is the dataSource for the collection view
 UICollectionViewDelegateFlowLayout - this class will configure the layout settings for the collection view
 
 
 */


class PokedexVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate
{
    //U.I. Vars
    @IBOutlet weak var collection: UICollectionView!;
    @IBOutlet weak var searchBar: UISearchBar!;
    
    //Data Vars
    var pokemonArr : [Pokemon] = [Pokemon]();
    var filteredPokemonArr : [Pokemon] = [Pokemon]();
    var isSearching : Bool = false;
    
    
    /* UICollectionView Initialization */
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        //UICollectionView
        collection.delegate = self;
        collection.dataSource = self;
        
        //UISearchBar
        searchBar.delegate = self;
        searchBar.returnKeyType = .done;
        
        parseCSV();
    }
    
    /* Search Bar Functionality */
    //Called when user enters text into the searchbar.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar.text == nil || (searchBar.text?.isEmpty)!
        {
            isSearching = false;
            collection.reloadData();
            dismissKeyboard();
        }
        else
        {
            isSearching = true;
            
            let lowercasedInput = searchBar.text!.lowercased();
            //Return a filtered set of Pokemon whom have a name value that encompasses the text the user typed into the search bar.
            filteredPokemonArr = pokemonArr.filter({$0.name.range(of: lowercasedInput) != nil});
            
            //Repopulate UICollectionView data.
            collection.reloadData();
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        dismissKeyboard();
    }
    
    
    func parseCSV() -> Void
    {
        //CSV File Location
        let filePath = Bundle.main.path(forResource: "pokemon", ofType: "csv");
        
        do
        {
            //Open CSV File
            let csvFile = try CSV(contentsOfURL: filePath!)
            //Grab Rows
            let rows = csvFile.rows;
            
            //For all 151 rows, grab the relevant values needed to initialize a pokemon.
            for aRow in rows
            {
                let currPokemonName = aRow["identifier"]!;
                let currPokeDexID = Int(aRow["id"]!)!;
                
                let newPokemon : Pokemon = Pokemon(name: currPokemonName, pokedexID: currPokeDexID);
                
                //Add current pokemon to class level array.
                pokemonArr.append(newPokemon);
            }
        }
        catch let err as NSError
        {
            print("Unable to open csv file.");
            print(err.debugDescription);
        }
    }

    /* Required method overloads for UICollectionView */
    // Cell Creation Method
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //Create Custom UICollectionViewCell
        //Dequeues cells as they go off the screen.
        if let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCollectionViewCell
        {
            //Grab Pokemon from either the main array or the filtered array, depending on if the searchbar is being utilized.
            
            let pokemon : Pokemon!;
            
            if(isSearching)
            {
                pokemon = filteredPokemonArr[indexPath.row];
                
            }
            else
            {
                pokemon = pokemonArr[indexPath.row];
            }
            
            myCell.initCell(pokemon: pokemon);
            
            return myCell;
        }
        else
        {
            return UICollectionViewCell();
        }
    }
    
    // Cell Selection Method
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        var pokemon: Pokemon!
        
        if (isSearching)
        {
            pokemon = filteredPokemonArr[indexPath.row];
        }
        else
        {
            pokemon = pokemonArr[indexPath.row];
        }
        
        performSegue(withIdentifier: "PokeDetailSegue", sender: pokemon);
    }
    
    // Cell count for CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if(isSearching)
        {
            return filteredPokemonArr.count;
        }
        else
        {
            return pokemonArr.count;
        }
    }
    
    // Section count for the CollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1;
    }
    
    // Size for a cell in the CollectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 75, height: 75);
    }
    
    func dismissKeyboard()
    {
        self.view.endEditing(true);
    }
    
    /* Segue Methods */
    //Cell Selection triggers a segue, this makes sure the destination VC has a valid pokemon to display.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "PokeDetailSegue"
        {
            if let destinationVC = segue.destination as? PokemonDetailVC
            {
                if (sender as? Pokemon) != nil
                {
                    destinationVC.pokemonToDisplay = sender as! Pokemon;
                }
            }
        }
    }
}
