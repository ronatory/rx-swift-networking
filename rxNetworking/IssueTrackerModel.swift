//
//  IssueTrackerModel.swift
//  rxNetworking
//
//  Created by ronatory on 27.09.16.
//  Copyright © 2016 ronatory. All rights reserved.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift

struct IssueTrackerModel {
	
	let provider: RxMoyaProvider<GitHub>
	let repositoryName: Observable<String>
	
	func trackIssues() -> Observable<[Issue]> {
		return repositoryName
			// make sure its observed on MainScheduler, because the purpose of this model
			// is to bind it to UI, in our case the table view
			.observeOn(MainScheduler.instance)
			// transform the text (repository name) into observable repository sequence,
			// that can be nil in case it doesnt map correctly
			.flatMapLatest { name -> Observable<Repository?> in
				print("name: \(name)")
				return self
					.findRepository(name)
			}
			.flatMapLatest { repository -> Observable<[Issue]?> in
				// check if repository is nil or not
				// if nil, return observable nil sequence
				guard let repository = repository else { return Observable.just(nil) } // just(nil) send one item as an observable, in this case nil
				
				// if not nil transform into array of issues, if the the repository has issues
				print("repository: \(repository.fullName)")
				return self.findIssues(repository)
			}
			// RxOptional extension that helps transform nil to an empty array and by that clear the table view
			.replaceNilWith([])
		
	}
	
	internal func findIssues(repository: Repository) -> Observable<[Issue]?> {
		// provider
		return self.provider
			// we can perform requests on that provider with a given enum case
			.request(GitHub.Issues(repositoryFullName: repository.fullName))
			// use debug to print some valuable infos from the request
			.debug()
			// use to parse and map. if the object cant be parsed it returns nil
			.mapArrayOptional(Issue.self)
	}
	
	internal func findRepository(name: String) -> Observable<Repository?> {
		return self.provider
			.request(GitHub.Repo(fullName: name))
			.debug()
			.mapObjectOptional(Repository.self)
	}
	
}
