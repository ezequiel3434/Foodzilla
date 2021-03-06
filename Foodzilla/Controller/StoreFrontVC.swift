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
    @IBOutlet weak var subscriptionStatusLbl: UILabel!
    @IBOutlet weak var foodzillaLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        IAPService.instance.iapDelegate = self
        IAPService.instance.loadProducts()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showRestoredAlert), name: NSNotification.Name(rawValue: IAPServiceRestoreNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(subscriptionStatusWasChanged(_:)), name: NSNotification.Name(IAPSubInfoChangedNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IAPService.instance.isSubscriptionActive { (active) in
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func subscriptionStatusWasChanged(_ notification: Notification) {
        guard let status = notification.object as? Bool else { return }
        DispatchQueue.main.async {
        if status == true {
                      
        // Perform actions for active subcriptions
            self.view.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            self.collectionView.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            self.subscriptionStatusLbl.text = "SUBSCRIPTION ACTIVE"
            self.subscriptionStatusLbl.textColor = #colorLiteral(red: 0.4274509804, green: 0.737254902, blue: 0.3882352941, alpha: 1)
            self.foodzillaLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
              } else {
                       
            // Perform actions for expired subcriptions
            self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.subscriptionStatusLbl.text = "SUBSCRIPTION EXPIRED"
            self.subscriptionStatusLbl.textColor = #colorLiteral(red: 0.8235294118, green: 0.3137254902, blue: 0.3058823529, alpha: 1)
            self.foodzillaLbl.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            }
        }
       
        
    }
    
    
    @IBAction func subscribeBtnWasPressed(_ sender: Any) {
        IAPService.instance.attemptPurchaseForItemWith(productIndex: .monthlySub)
    }
    

    @IBAction func restoreBtnWasPressed(_ sender: Any) {
        let alertVC = UIAlertController(title: "Restore Purchases?", message: "Do you want to restore any in-app purchases you've previusly purchased?", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Restore", style: .default) { (action) in
            IAPService.instance.restorePurchases()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(action)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
        
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
    
    @objc func showRestoredAlert(){
        let alert = UIAlertController(title: "Success", message: "Your purchases were successfuly restored", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
}


extension StoreFrontVC: IAPServiceDelegate {
    func iapProductsLoaded() {
        print("IAP products loaded")
    }
    
    
}
