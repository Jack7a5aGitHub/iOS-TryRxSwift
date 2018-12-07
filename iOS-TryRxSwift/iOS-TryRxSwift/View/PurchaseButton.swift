//
//  PurchaseButton.swift
//  iOS-TryRxSwift
//
//  Created by Jack Wong on 2018/12/07.
//  Copyright © 2018 Jack Wong. All rights reserved.
//

import UIKit

final class PurchaseButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        self.backgroundColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        self.setTitle("Purchase", for: .normal)
        self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
    }
}
