//
//  Coffee.swift
//  iOS-TryRxSwift
//
//  Created by Jack Wong on 2018/12/05.
//  Copyright © 2018 Jack Wong. All rights reserved.
//

import UIKit

//MARK: - Equatable Protocol implementation

func ==(lhs: Coffee, rhs: Coffee) -> Bool {
    return (lhs.countryName == rhs.countryName
        && lhs.priceInDollars == rhs.priceInDollars
        && lhs.countryFlagEmoji == rhs.countryFlagEmoji)
}

struct Coffee: Equatable {
    let priceInDollars: Float
    let countryName: String
    let countryFlagEmoji: String
    
    static let ofCoffee: [Coffee] = {
        let brazil = Coffee(priceInDollars: 3,
                            countryName: "Brazil",
                            countryFlagEmoji: "🇧🇷")
        let colombia = Coffee(priceInDollars: 2.4,
                              countryName: "Colombia",
                              countryFlagEmoji: "🇨🇴")
        let ethiopia = Coffee(priceInDollars: 3.6,
                              countryName: "Ethiopia",
                              countryFlagEmoji: "🇪🇹")
        let indonesia = Coffee(priceInDollars: 2.8,
                               countryName: "Indonesia",
                               countryFlagEmoji: "🇮🇩")
        let vietnam = Coffee(priceInDollars: 1.9,
                             countryName: "Vietnam",
                             countryFlagEmoji: "🇻🇳")
        return [brazil, colombia, ethiopia, indonesia, vietnam]
    }()
    
}

extension Coffee: Hashable {
    var hashValue: Int {
        return self.countryFlagEmoji.hashValue
    }
}
