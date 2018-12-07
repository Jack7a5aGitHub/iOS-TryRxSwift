
//
//  OrderSuccessViewController.swift
//  iOS-TryRxSwift
//
//  Created by Jack Wong on 2018/12/07.
//  Copyright © 2018 Jack Wong. All rights reserved.
//

import UIKit

final class OrderSuccessViewController: UIViewController {

    @IBOutlet var orderLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var creditCardIcon: UIImageView!
    
    var cardType: CardType = .Unknown {
        didSet {
            configureIconForCardType()
        }
    }
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

extension OrderSuccessViewController {
    
    private func setup() {
        self.title = "Success!"
        configureIconForCardType()
        configureLabelsFromCart()
    }
    
    //MARK: - Configuration methods
    
    private func configureIconForCardType() {
        guard let imageView = creditCardIcon else {
            //View hasn't loaded yet, come back later.
            return
        }
        
        imageView.image = cardType.image
    }
    
    private func configureLabelsFromCart() {
        guard let costLabel = costLabel else {
            //View hasn't loaded yet, come back later.
            return
        }
        
        let cart = ShoppingCart.sharedCart
        
        costLabel.text = CurrencyFormatter.dollarsFormatter.rw_string(from: cart.totalCost())
        
        orderLabel.text = cart.itemCountString()
    }
}
