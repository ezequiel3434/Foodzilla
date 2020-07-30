//
//  ItemCell.swift
//  Foodzilla
//
//  Created by Ezequiel Parada Beltran on 30/07/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import UIKit

class ItemCell: UICollectionViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    
    func configureCell(forItem item: Item) {
        itemImageView.image = item.image
        itemNameLabel.text = item.name
        itemPriceLabel.text = String(describing: item.price)
    }
    
    
}
