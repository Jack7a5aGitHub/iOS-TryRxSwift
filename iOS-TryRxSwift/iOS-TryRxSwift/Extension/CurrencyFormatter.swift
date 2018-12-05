//
//  CurrencyFormatter.swift
//  iOS-TryRxSwift
//
//  Created by Jack Wong on 2018/12/05.
//  Copyright © 2018 Jack Wong. All rights reserved.
//

import Foundation

enum CurrencyFormatter {
    static let dollarsFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter
    }()
}

extension NumberFormatter {
    
    ///Convenience method to prevent having to cast floats to NSNumbers every single time.
    func rw_string(from float: Float) -> String? {
        return self.string(from: NSNumber(value: float))
    }
}
