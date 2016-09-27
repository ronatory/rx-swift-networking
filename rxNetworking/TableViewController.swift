//
//  TableViewController.swift
//  rxNetworking
//
//  Created by ronatory on 27.09.16.
//  Copyright © 2016 ronatory. All rights reserved.
//

import Moya
import Moya_ModelMapper
import UIKit
import RxCocoa
import RxSwift

class TableViewController: UITableViewController {
	
	@IBOutlet weak var searchBar: UISearchBar!
	
	let disposeBag = DisposeBag()
	var provider: RxMoyaProvider<GitHub>!
	var latestRepositoryName: Observable<String> {
		return searchBar
			.rx_text
			.throttle(0.5, scheduler: MainScheduler.instance)
			.distinctUntilChanged()
	}
	var issueTrackerModel: IssueTrackerModel!

    override func viewDidLoad() {
        super.viewDidLoad()
		setupRx()
    }

	func setupRx() {
		// create a provider
		provider = RxMoyaProvider<GitHub>()
		
		
		// setup the model
		issueTrackerModel = IssueTrackerModel(provider: provider, repositoryName: latestRepositoryName)
		
		tableView.dataSource = nil
		tableView.delegate = nil
		
		// bind issues to table view
		// magic happens with only one binding
		// fill up about 3 table view data source methods
		issueTrackerModel
			.trackIssues()
			.bindTo(tableView.rx_itemsWithCellFactory) { (tableView, row, item) in
				let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: NSIndexPath(forRow: row, inSection: 0))
				cell.textLabel?.text = item.title
				
				return cell
			}
			.addDisposableTo(disposeBag)
		
		
		// here tell the table view, that if the user clicks on a cell
		// and the keyboard is still visible, then hide it
		tableView
			.rx_itemSelected
			.subscribeNext { indexPath in
				if self.searchBar.isFirstResponder() == true {
					self.view.endEditing(true)
				}
			}
			.addDisposableTo(disposeBag)
	}

}
