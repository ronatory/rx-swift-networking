//
//  TableViewController.swift
//  rxNetworking
//
//  Created by Ronny Glotzbach on 27.09.16.
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

    override func viewDidLoad() {
        super.viewDidLoad()
		setupRx()
    }

	func setupRx() {
		// 1. create a provider
		provider = RxMoyaProvider<GitHub>()
		
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
