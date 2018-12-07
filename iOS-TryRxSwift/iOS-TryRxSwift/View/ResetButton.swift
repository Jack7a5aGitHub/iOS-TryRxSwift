//
//  ResetButton.swift
//  iOS-TryRxSwift
//
//  Created by Jack Wong on 2018/12/07.
//  Copyright © 2018 Jack Wong. All rights reserved.
//

import UIKit

final class ResetButton: UIButton {

   
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func setup() {
        self.backgroundColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        self.setTitle("Reset", for: .normal)
        self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
    }
}
