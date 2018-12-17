//
//  String+Extension.swift
//  iOS-TryRxSwift
//
//  Created by Jack Wong on 2018/12/06.
//  Copyright © 2018 Jack Wong. All rights reserved.
//

import Foundation

/// ExpirationDate
extension String {
    
    func rw_addSlash() -> String {
        guard self.count > 2 else {
            //Nothing to add
            return self
        }
        
        let index2 = self.index(self.startIndex, offsetBy: 2)
        let firstTwo = self.prefix(upTo: index2) //self.substring(to: index2)
        let rest = self.suffix(from: index2) //self.substring(from: index2)
        
        return firstTwo + " / " + rest
    }
    
    func rw_removeSlash() -> String {
        let removedSpaces = self.rw_removeSpaces()
        return removedSpaces.replacingOccurrences(of: "/", with: "")
    }
    
    func rw_isValidExpirationDate() -> Bool {
        let noSlash = self.rw_removeSlash()
        
        guard noSlash.count == 6 //Must be mmyyyy
            && noSlash.rw_allCharactersAreNumbers() else { //must be all numbers
                return false
        }
        
        let index2 = self.index(self.startIndex, offsetBy: 2)
        let monthString = self.prefix(upTo: index2) //self.substring(to: index2)
        let yearString = self.suffix(from: index2) //self.substring(from: index2)
        
        guard
            let month = Int(monthString),
            let year = Int(yearString) else {
                //We can't even check.
                return false
        }
        
        //Month must be between january and december.
        guard (month >= 1 && month <= 12) else {
            return false
        }
        
        let now = Date()
        let currentYear = now.rw_currentYear()
        
        guard year >= currentYear else {
            //Year is before current: Not valid.
            return false
        }
        
        if year == currentYear {
            let currentMonth = now.rw_currentMonth()
            guard month >= currentMonth else {
                //Month is before current in current year: Not valid.
                return false
            }
        }
        
        //If we made it here: Woo!
        return true
    }
}

/// CreditCard
extension String {
    
    func rw_allCharactersAreNumbers() -> Bool {
        let nonNumberCharacterSet = NSCharacterSet.decimalDigits.inverted
        return (self.rangeOfCharacter(from: nonNumberCharacterSet) == nil)
    }
    
    
    func rw_integerValueOfFirst(characters: Int) -> Int {
        guard rw_allCharactersAreNumbers() else {
            return NSNotFound
        }
        
        if characters > self.count {
            return NSNotFound
        }
        
        let indexToStopAt = self.index(self.startIndex, offsetBy: characters)
        let substring =  self.prefix(upTo: indexToStopAt) //self.substring(to: indexToStopAt)
        guard let integerValue = Int(substring) else {
            return NSNotFound
        }
        
        return integerValue
    }
    
    
    func rw_isLuhnValid() -> Bool {
        //https://www.rosettacode.org/wiki/Luhn_test_of_credit_card_numbers
        
        guard self.rw_allCharactersAreNumbers() else {
            //Definitely not valid.
            return false
        }
        
        let reversed = self.reversed().map { String($0) }
        
        var sum = 0
        for (index, element) in reversed.enumerated() {
            guard let digit = Int(element) else {
                //This is not a number.
                return false
            }
            
            if index % 2 == 1 {
                //Even digit
                switch digit {
                case 9:
                    //Just add nine.
                    sum += 9
                default:
                    //Multiply by 2, then take the remainder when divided by 9 to get addition of digits.
                    sum += ((digit * 2) % 9)
                }
            } else {
                //Odd digit
                sum += digit
            }
        }
        
        //Valid if divisible by 10
        return sum % 10 == 0
    }
    
    func rw_removeSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}

extension String {
    func index(of aString: String, startingFrom position: Int = 0) -> String.Index? {
        let start = index(startIndex, offsetBy: position)
        return self[start...].range(of: aString, options: .literal)?.lowerBound
    }
}
