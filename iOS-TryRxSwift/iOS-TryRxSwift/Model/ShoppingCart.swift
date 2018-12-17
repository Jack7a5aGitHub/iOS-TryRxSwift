//
//  ShoppingCart.swift
//  iOS-TryRxSwift
//
//  Created by Jack Wong on 2018/12/05.
//  Copyright © 2018 Jack Wong. All rights reserved.
//

import Foundation
import RxSwift

class ShoppingCart {
    static let sharedCart = ShoppingCart()
    
    //Create the array of coffee as an Rx Variable so it can be observed.
    let coffees: Variable<[Coffee]> = Variable([])
    
    func totalCost() -> Float {
        return coffees.value.reduce(0, { runningTotal, coffee in
            return runningTotal + coffee.priceInDollars
        })
    }
    func itemCountString() -> String {
        guard coffees.value.count > 0 else {
            return "🚫☕️"
        }
        //Unique the coffees
        let setOfCoffees = Set<Coffee>(coffees.value)
        let itemStrings: [String] = setOfCoffees.map {
            mapCoffee in
            let count: Int = coffees.value.reduce(0) { runningTotal, reduceCoffee in
                if mapCoffee == reduceCoffee {
                    return runningTotal + 1
                }
                return runningTotal
            }
            return "\(mapCoffee.countryFlagEmoji)☕️: \(count)"
        }
        return itemStrings.joined(separator: "\n")
    }
}
