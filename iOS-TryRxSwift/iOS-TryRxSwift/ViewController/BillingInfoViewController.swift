//
//  BillingInfoViewController.swift
//  iOS-TryRxSwift
//
//  Created by Jack Wong on 2018/12/06.
//  Copyright © 2018 Jack Wong. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

final class BillingInfoViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet private var creditCardNumberTextField: ValidatngTextField!
    @IBOutlet private var expirationDateTextField: ValidatngTextField!
    @IBOutlet private var cvvTextField: ValidatngTextField!
    @IBOutlet private var purchaseButton: UIButton!
    @IBOutlet var creditCardImageView: UIImageView!
    private let cardType: Variable<CardType> = Variable(.Unknown)
    private let disposeBag = DisposeBag()
    private let throttleInterval = 0.1
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = identifierForSegue(segue: segue)
        switch identifier {
        case .PurchaseSuccess:
            guard let destination = segue.destination as? OrderSuccessViewController else {
                assertionFailure("Couldn't get coffee is coming VC!")
                return
            }
            destination.cardType = cardType.value
        }
    }
}

extension BillingInfoViewController {
    
    private func setup() {
        self.title = "💳 Info"
        setupCardImageDisplay()
        setupTextChangeHandling()
    }
    
    //MARK: - RX Setup
    // asObservable - emit notifications of change
    // asObserver - which is observable, in order to be notified when it has changed.
    // You can have multiple Observers listening to an Observable. This means that when the Observable changes,
    // it will notify all its Observers.
    private func setupCardImageDisplay() {
        cardType.asObservable()
            .subscribe(onNext: { cardType in
                self.creditCardImageView.image = cardType.image
            })
        .disposed(by: disposeBag)
    }
    // rx.text -> TextField
    private func setupTextChangeHandling() {
        let creditCardValid = creditCardNumberTextField
            .rx
            .text
            .throttle(throttleInterval, scheduler: MainScheduler.instance)
            .map{

                self.validate(cardText: $0)
        }
        creditCardValid
            .subscribe(onNext: { isValid in
                self.creditCardNumberTextField.valid = isValid
            })
        .disposed(by: disposeBag)
        
        let expirationValid = expirationDateTextField
            .rx
            .text
            .throttle(throttleInterval, scheduler: MainScheduler.instance)
            .map { self.validate(expirationDateText: $0) }
        expirationValid
            .subscribe(onNext: { self.expirationDateTextField.valid = $0 })
            .disposed(by: disposeBag)
        
        let cvvValid = cvvTextField
            .rx
            .text
            .map { self.validate(cvvText: $0) }
        
        cvvValid
            .subscribe(onNext: { self.cvvTextField.valid = $0 })
            .disposed(by: disposeBag)
        
        let everythingValid = Observable
            .combineLatest(creditCardValid, expirationValid, cvvValid) {
                $0 && $1 && $2 //All must be true
        }
        
        everythingValid
            .bind(to: purchaseButton.rx.isEnabled).disposed(by: disposeBag)
    }
}

extension BillingInfoViewController {
    
    //MARK: - Validation methods
    
    func validate(cardText: String?) -> Bool {
        guard let cardText = cardText else {
            return false
        }
        let noWhitespace = cardText.rw_removeSpaces()
        
        updateCardType(using: noWhitespace)
        formatCardNumber(using: noWhitespace)
        advanceIfNecessary(noSpacesCardNumber: noWhitespace)
        
        guard cardType.value != .Unknown else {
            //Definitely not valid if the type is unknown.
            return false
        }
        
        guard noWhitespace.rw_isLuhnValid() else {
            //Failed luhn validation
            return false
        }
        
        return noWhitespace.count == self.cardType.value.expectedDigits
    }
    
    func validate(expirationDateText expiration: String?) -> Bool {
        guard let expiration = expiration else {
            return false
        }
        let strippedSlashExpiration = expiration.rw_removeSlash()
        
        formatExpirationDate(using: strippedSlashExpiration)
        advanceIfNecessary(expirationNoSpacesOrSlash:  strippedSlashExpiration)
        
        return strippedSlashExpiration.rw_isValidExpirationDate()
    }
    
    func validate(cvvText cvv: String?) -> Bool {
        guard let cvv = cvv else {
            return false
        }
        guard cvv.rw_allCharactersAreNumbers() else {
            //Someone snuck a letter in here.
            return false
        }
        dismissIfNecessary(cvv: cvv)
        return cvv.count == self.cardType.value.cvvDigits
    }
    
    
    //MARK: Single-serve helper functions
    
    private func updateCardType(using noSpacesNumber: String) {
        cardType.value = CardType.fromString(string: noSpacesNumber)
    }
    
    private func formatCardNumber(using noSpacesCardNumber: String) {
        creditCardNumberTextField.text = self.cardType.value.format(noSpaces: noSpacesCardNumber)
    }
    
    func advanceIfNecessary(noSpacesCardNumber: String) {
        if noSpacesCardNumber.count == self.cardType.value.expectedDigits {
            self.expirationDateTextField.becomeFirstResponder()
        }
    }
    
    func formatExpirationDate(using expirationNoSpacesOrSlash: String) {
        expirationDateTextField.text = expirationNoSpacesOrSlash.rw_addSlash()
    }
    
    func advanceIfNecessary(expirationNoSpacesOrSlash: String) {
        if expirationNoSpacesOrSlash.count == 6 { //mmyyyy
            self.cvvTextField.becomeFirstResponder()
        }
    }
    
    func dismissIfNecessary(cvv: String) {
        if cvv.count == self.cardType.value.cvvDigits {
            let _ = self.cvvTextField.resignFirstResponder()
        }
    }
}

//MARK: - SegueHandler
extension BillingInfoViewController: SegueHandler {
    enum SegueIdentifier: String {
        case
        PurchaseSuccess
    }
}






