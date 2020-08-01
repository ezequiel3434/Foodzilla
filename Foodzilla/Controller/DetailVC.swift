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
    
    private var hiddenStatus: Bool = UserDefaults.standard.bool(forKey: "nonConsumablePurchaseWasMade")
    
    func initData(forItem item: Item) {
        self.item = item
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        itemImageView.image = item.image
        itemNameLabel.text = item.name
        itemPriceLabel.text = String(describing: item.price)
        buyItemButton.setTitle("Buy the item for $(\(item.price)", for: .normal)

        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchase(_:)), name: NSNotification.Name(IAPServicePurchaseNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFailure), name: NSNotification.Name(IAPServiceFailureNotification), object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showOrHideAds()
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handlePurchase(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        
        switch productID {
        case IAP_MEAL_ID:
            buyItemButton.isEnabled = true
            debugPrint("Meal saccessfully purchased.")
            break
        case IAP_HID_ADS_ID:
            uglyAdView.isHidden = true
            hideAdsButton.isHidden = true
            
            
            
            break
        
        default:
            break
        }
        
    }
    

    @objc func handleFailure() {
         buyItemButton.isEnabled = true
        debugPrint("Purchase failed!")
    }
    
    func showOrHideAds() {
        uglyAdView.isHidden = hiddenStatus
        hideAdsButton.isHidden = hiddenStatus
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
        buyItemButton.isEnabled = false
        IAPService.instance.attemptPurchaseForItemWith(productIndex: .meal)
    }
    
    @IBAction func hideAdsButtonWasPressed(_ sender: Any) {
        
        IAPService.instance.attemptPurchaseForItemWith(productIndex: .hideAds)
        
    }
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
