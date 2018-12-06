//
//  CartViewController.swift
//  iOS-TryRxSwift
//
//  Created by Jack Wong on 2018/12/05.
//  Copyright © 2018 Jack Wong. All rights reserved.
//

import UIKit

final class CartViewController: UIViewController {

    // MARK: IBOutlet
    @IBOutlet private var totalItemLabel: UILabel!
    @IBOutlet private var totalCostLabel: UILabel!
    @IBOutlet private var checkoutButton: UIButton!
    @IBOutlet private var resetButton: UIButton!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - IBAction
    @IBAction func checkoutAction(_ sender: Any) {
        
    }
    
    @IBAction func resetAction(_ sender: Any) {
        ShoppingCart.sharedCart.coffees.value = []
        navigationController?.popViewController(animated: true)
    }
    
}

extension CartViewController {
    private func setup() {
        self.title = "Cart"
        configureFromCart()
    }
    private func configureFromCart() {
        guard checkoutButton != nil else {
            //UI has not been instantiated yet. Bail!
            return
        }
        let cart = ShoppingCart.sharedCart
        totalItemLabel.text = cart.itemCountString()
        let cost = cart.totalCost()
        totalCostLabel.text = CurrencyFormatter.dollarsFormatter.rw_string(from: cost)
        //Disable checkout if there's nothing to check out with
        checkoutButton.isEnabled = (cost > 0)
    }
}
