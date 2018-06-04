//
//  ViewController.swift
//  rxTuto
//
//  Created by pierre-marie de jaureguiberry on 6/4/18.
//  Copyright © 2018 pm. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SearchBarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!
    
    let disposeBag = DisposeBag()
    var shownCities = [String]()
    let allCities = ["Bordeaux", "Toulouse", "Nantes", "Marseille", "Paris", "Toulon", "Jarnac", "Cognac"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityPrototypeCell", for: indexPath)
        cell.textLabel?.text = shownCities[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchBar
            .rx.text // Observable property thanks to RxCocoa
            .orEmpty // Make it non-optional
            .debounce(0.5, scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            .filter { !$0.isEmpty } // If the new value is really new, filter for non-empty query.
            .subscribe(onNext: {
                [unowned self] query in // Here we will be notified of every new value
                self.shownCities = self.allCities.filter { $0.hasPrefix(query) } // We now do our "API Request" to find cities.
                print(self.shownCities)
                self.searchTable.reloadData() // And reload table view data.
            })
        .disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

