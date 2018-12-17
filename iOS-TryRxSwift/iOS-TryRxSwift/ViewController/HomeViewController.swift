//
//  HomeViewController.swift
//  iOS-TryRxSwift
//
//  Created by Jack Wong on 2018/12/05.
//  Copyright © 2018 Jack Wong. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

final class HomeViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet var coffeeTableView: UITableView!
    @IBOutlet var shoppingCartBarItem: UIBarButtonItem!
    
    // MARK: - Properties
    private let coffee = Observable.just(Coffee.ofCoffee)
    private let disposeBag = DisposeBag()
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

extension HomeViewController {
    private func setup() {
        self.title = "Coffee Is My Life!!!"
        setupCellConfiguartion()
        setupCellTapHandling()
        setupCartObserver()
        coffeeTableView.tableFooterView = UIView()
    }
    private func setupCellConfiguartion() {
        //Equivalent of cell for row at index path
        // rx = RxCocoa
        // bind to associate to coffee observable
        // rx.items -> tableview Cell
        coffee
        .bind(to: coffeeTableView
        .rx
            .items(cellIdentifier: CoffeeCell.identifier, cellType: CoffeeCell.self)) {
                row, coffee, cell in
                cell.coffeeFlag = coffee.countryFlagEmoji
                cell.countryName = coffee.countryName
                cell.price = CurrencyFormatter.dollarsFormatter.rw_string(from: coffee.priceInDollars)
        }
            .disposed(by: disposeBag)
    }
    private func setupCellTapHandling() {
        //Equivalent of did select row at index path
        //value is where array of object is stored
        //closure inside onNext will be excuted every time the value change
        //disposed - handle the memory
        //share the same model to store data (ShoppingCart.sharedCart)
        coffeeTableView.rx.modelSelected(Coffee.self)
            .subscribe(onNext: { coffee in
                ShoppingCart.sharedCart.coffees.value.append(coffee)
                if let  selectedRowIndexPath = self.coffeeTableView.indexPathForSelectedRow {
                     self.coffeeTableView.deselectRow(at: selectedRowIndexPath, animated: true)
                }
            }).disposed(by: disposeBag)
    }
    
    private func setupCartObserver() {
        ShoppingCart.sharedCart.coffees.asObservable()
            .subscribe(onNext: {
                coffee in
                self.shoppingCartBarItem.title = "\(coffee.count)☕️"
            })
        .disposed(by: disposeBag)
    }
}

extension HomeViewController: SegueHandler {
    enum SegueIdentifier: String {
        case GoToCart
    }
}
