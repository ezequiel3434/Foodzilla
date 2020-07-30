//
//  DetailVC.swift
//  Foodzilla
//
//  Created by Ezequiel Parada Beltran on 30/07/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var uglyAdView: UIView!
    @IBOutlet weak var buyItemButton: UIButton!
    @IBOutlet weak var hideAdsButton: UIButton!
    
    public private(set) var item: Item!
    
    func initData(forItem item: Item) {
        self.item = item
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        itemImageView.image = item.image
        itemNameLabel.text = item.name
        itemPriceLabel.text = String(describing: item.price)
        buyItemButton.setTitle("Buy the item for $(\(item.price)", for: .normal)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func buyItemsWasPressed(_ sender: Any) {
    }
    
    @IBAction func hideAdsButtonWasPressed(_ sender: Any) {
    }
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
