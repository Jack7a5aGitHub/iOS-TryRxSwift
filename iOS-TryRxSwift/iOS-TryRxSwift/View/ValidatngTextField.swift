//
//  ValidatngTextField.swift
//  iOS-TryRxSwift
//
//  Created by Jack Wong on 2018/12/06.
//  Copyright © 2018 Jack Wong. All rights reserved.
//

import UIKit

final class ValidatngTextField: UITextField {

    var valid: Bool = false {
        didSet {
            configureForValid()
        }
    }
    
    var hasBeenExited: Bool = false {
        didSet {
            configureForValid()
        }
    }
    
    func commonInit() {
        configureForValid()
    }
    
    //Yeah, totally required.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func resignFirstResponder() -> Bool {
        hasBeenExited = true
        return super.resignFirstResponder()
    }
    
    private func configureForValid() {
        if !valid && hasBeenExited {
            //Only color the background if the user has tried to
            //input things at least once.
            self.backgroundColor = .red
        } else {
            self.backgroundColor = .clear
        }
    }
   
}
