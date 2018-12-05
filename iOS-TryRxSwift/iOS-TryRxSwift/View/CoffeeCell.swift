//
//  CoffeeCell.swift
//  iOS-TryRxSwift
//
//  Created by Jack Wong on 2018/12/05.
//  Copyright © 2018 Jack Wong. All rights reserved.
//

import UIKit

final class CoffeeCell: UITableViewCell {

    @IBOutlet private var coffeeFlagLabel: UILabel!
    @IBOutlet private var countryNameLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    static var identifier: String {
        return self.className
    }
    static var nibName: String {
        return self.className
    }
    var coffeeFlag: String? {
        didSet {
            guard let coffeeFlag = coffeeFlag else {
                return
            }
            coffeeFlagLabel.text = "☕️" + coffeeFlag
        }
    }
    var countryName: String? {
        didSet {
            guard let countryName = countryName else {
                return
            }
            countryNameLabel.text = countryName
        }
    }
    var price: String? {
        didSet {
            guard let price = price else {
                return
            }
            priceLabel.text = price
        }
    }
}
