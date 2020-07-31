//
//  ViewController.swift
//  Foodzilla
//
//  Created by Ezequiel Parada Beltran on 30/07/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import UIKit

class StoreFrontVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        IAPService.instance.delegate = self
        IAPService.instance.loadProducts()
        
    }

    @IBAction func restoreBtnWasPressed(_ sender: Any) {
    }
    
}


extension StoreFrontVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell" , for: indexPath) as? ItemCell else { return UICollectionViewCell()}
        cell.configureCell(forItem: foodItems[indexPath.row])
        
        
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(identifier: "DetailVC") as? DetailVC else { return }
        let item = foodItems[indexPath.row]
        detailVC.initData(forItem: item)
        present(detailVC,animated: true, completion: nil)
        
        
        
    }
    
    
}


extension StoreFrontVC: IAPServiceDelegate {
    func iapProductsLoaded() {
        print("IAP products loaded")
    }
    
    
}
