//
//  SearchTableViewCell.swift
//  dca-calculator
//
//  Created by Gorkem BekAr on 16.10.2021.
//

import UIKit

class SearchTableViewCell : UITableViewCell{
    
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet weak var asssetSymbolLabel: UILabel!
    @IBOutlet weak var assetTypeLAbel: UILabel!
    
    
    func configure(with searchResult: SearchResult){
        assetNameLabel.text = searchResult.name
        asssetSymbolLabel.text = searchResult.symbol
        assetTypeLAbel.text = searchResult.type
            .appending(" ")
            .appending(searchResult.currency)
    }
}
