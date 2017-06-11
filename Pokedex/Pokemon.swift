//
//  Pokemon.swift
//  Pokedex
//
//  Created by Steve Kerney on 6/10/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon
{
    //Stored Properties
    private var _name: String!;
    private var _pokedexID: Int!;
    private var _type: String!;
    private var _info: String!;
    private var _def: String!;
    private var _atk: String!;
    private var _height: String!;
    private var _weight: String!;
    private var _nextEvolutionText: String!;
    private var _nextEvolutionName: String!;
    private var _nextEvolutionID: String!;
    private var _nextEvolutionLVL: String!;
    private var _pokemonURL: String!;
    
    //Accessors
    //Name and Pokedex ID are in the csv, so no need to check for nill.
    var name: String
    {
        return _name;
    }
    
    var pokedexID: Int
    {
        return _pokedexID;
    }
    
    var type: String
    {
        if _type == nil
        {
            _type = "";
        }
        return _type;
    }
    
    var info: String
    {
        if _info == nil
        {
            _info = "";
        }
        return _info;
    }
    
    var def: String
    {
        if _def == nil
        {
            _def = "";
        }
        return _def;
    }
    
    var atk: String
    {
        if _atk == nil
        {
            _atk = "";
        }
        return _atk;
    }
    
    var height: String
    {
        if _height == nil
        {
            _height = "";
        }
        return _height;
    }
    
    var weight: String
    {
        if _weight == nil
        {
            _weight = "";
        }
        return _weight;
    }
    
    var nextEvolutionText: String
    {
        if _nextEvolutionText == nil
        {
            _nextEvolutionText = "";
        }
        return _nextEvolutionText;
    }
    
    var nextEvolutionName: String
    {
        if _nextEvolutionName == nil
        {
            _nextEvolutionName = "";
        }
        return _nextEvolutionName;
    }
    
    var nextEvolutionID: String
    {
        if _nextEvolutionID == nil
        {
            _nextEvolutionID = "";
        }
        return _nextEvolutionID;
    }
    
    var nextEvolutionLVL: String
    {
        if _nextEvolutionLVL == nil
        {
            _nextEvolutionLVL = "";
        }
        return _nextEvolutionLVL;
    }
    
    
    
    //Class Constructor
    init(name: String, pokedexID: Int)
    {

        
        _name = name;
        _pokedexID = pokedexID;
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexID)/"
    }
    
    //PokeAPI request, using AlamoFire
    func downloadDetails(completionClosure: @escaping DownloadComplete)
    {
        Alamofire.request(_pokemonURL).responseJSON{ (response) in
           
            //Catch the data
            if let rootDict = response.result.value as? Dictionary<String, Any>
            {
                if let weight = rootDict["weight"] as? String
                {
                    let weightDecimalIndex = weight.index(weight.endIndex, offsetBy: -1);
                    let weightDecVal = weight.substring(from: weightDecimalIndex);
    
                    let endIndex = weight.index(weight.endIndex, offsetBy: -1);
                    let range = weight.startIndex..<endIndex;
                    let weightKGValue = weight.substring(with: range);
                    
                
                    let weightFixed = "\(weightKGValue).\(weightDecVal) kg"

                    self._weight = weightFixed;
                }
                
                if let height = rootDict["height"] as? String
                {
                    let sortaFixedHeight = "\(height)m";
                    self._height = sortaFixedHeight;
                }
                
                if let attack = rootDict["attack"] as? Int
                {
                    self._atk = String(attack);
                }
                
                if let defense = rootDict["defense"] as? Int
                {
                    self._def = String(defense);
                }
                
                //Drill down further to get Pokemon Type data, since it can be more than 1 value.
                if let typesArrOfDicts = rootDict["types"] as? [Dictionary<String, String>], typesArrOfDicts.count > 0
                {
                    //Pokemon has only 1 Type
                    if let firstTypeVal = typesArrOfDicts[0]["name"]
                    {
                        self._type = firstTypeVal.capitalized;
                    }
                    
                    //Pokemon has more than 1 Type
                    if (typesArrOfDicts.count > 1)
                    {
                        for dictIndex in 1..<typesArrOfDicts.count
                        {
                            if let nextTypeVal = typesArrOfDicts[dictIndex]["name"]
                            {
                                self._type! += "/\(nextTypeVal)".capitalized;
                            }
                        }
                    }
                }
                else
                {
                    self._type = "Err_Getting_Type";
                }
                
                //Pokemon Info
                if let infoArrOfDicts = rootDict["descriptions"] as? [Dictionary<String, String>], infoArrOfDicts.count > 0
                {
                    //Pokedex Blue Pokedex Descriptions
                    if let firstInfoURL = infoArrOfDicts[0]["resource_uri"]
                    {
                        let fullInfoRequestURL = "\(URL_BASE)\(firstInfoURL)"
                        
                        //Alamo Fire Request
                        Alamofire.request(fullInfoRequestURL).responseJSON(completionHandler: { (response) in
                            
                            if let infoDict = response.result.value as? Dictionary<String, AnyObject>
                            {
                                if let pkmnInfo = infoDict["description"] as? String
                                {
                                    let fixedInfo = pkmnInfo.replacingOccurrences(of: "POKMON", with: "Pokemon");
                                    self._info = fixedInfo;
                                }
                            }
                            //Info AlamoFire API Call
                            completionClosure();
                        })
                    }
                }
                else
                {
                    self._info = "Err_Getting_Info";
                }
                //Pokemon Next Evolution Info
                if let evolutionsDictArray = rootDict["evolutions"] as? [Dictionary<String, AnyObject>], evolutionsDictArray.count > 0
                {
                    //Grab Next EvolutionInfo for requested Pokemon
                    //Next Name
                    if let nextEvolutionName = evolutionsDictArray[0]["to"] as? String
                    {
                        if nextEvolutionName.range(of: "mega") == nil
                        {
                            self._nextEvolutionName = nextEvolutionName;
                            
                            //Next Evolution DexID
                            if let uri = evolutionsDictArray[0]["resource_uri"] as? String
                            {
                                let trimmedURI = uri.replacingOccurrences(of: "\(URL_POKEMON)", with: "");
                                let extractedDexID = trimmedURI.replacingOccurrences(of: "/", with: "");
                                self._nextEvolutionID = extractedDexID;
                                
                                //Next Evolution LVL Requirement
                                if let nextEvoLVL = evolutionsDictArray[0]["level"]
                                {
                                    self._nextEvolutionLVL = "\(nextEvoLVL)"
                                }
                                else
                                {
                                    self._nextEvolutionLVL = "";
                                }
                            }
                        }
                    }
                }
            }
            
            //1st AlamoFire API Call
            completionClosure();
            
        }
    }
}
