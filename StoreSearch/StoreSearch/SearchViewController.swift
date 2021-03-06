//
//  ViewController.swift
//  StoreSearch
//
//  Created by Jay on 15/11/30.
//  Copyright © 2015年 look4us. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    

    let search = Search()
    
    var landscapleViewController: LandscapeViewController?
    
    struct TableViewCellIdentifiers {
    
        static let searchResultCell = "SearchResultCell"
        
        static let nothingFoundCell = "NothingFoundCell"
        
        static let loadingCell = "LoadingCell"
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 108, left: 0, bottom: 0, right: 0)
        
        var cellNib = UINib(nibName: TableViewCellIdentifiers.searchResultCell, bundle: nil)
        
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.searchResultCell)
        
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.nothingFoundCell, bundle: nil)
        
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.nothingFoundCell)
        
        
        cellNib = UINib(nibName: TableViewCellIdentifiers.loadingCell, bundle: nil)
        
        tableView.registerNib(cellNib, forCellReuseIdentifier: TableViewCellIdentifiers.loadingCell)
        
        tableView.rowHeight = 80
        
        searchBar.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        
        performSearch()
        
    }
    
    func performSearch() {
        
        
        if let category = Search.Category(rawValue: segmentedControl.selectedSegmentIndex){
            
            
            search.performSearchForText(searchBar.text!, category: category,completion: { success in
                
                if !success {
                    
                    self.showNetworkError()
                    
                }
                
                self.tableView.reloadData()
                
                self.landscapleViewController?.searchResultsReceived()
                
                
            })
            
            tableView.reloadData()
            
            searchBar.resignFirstResponder()
            
        }
        
    }

    
    func showNetworkError() {
        
        let alert = UIAlertController(
        
            title: NSLocalizedString("Whoops...", comment: "Error alert: title"),
            
            message: NSLocalizedString("There was an error reading from the iTunes Store. Please try again.", comment: "Error alert: message"),
            
            preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetail" {
        
            if case .Results(let list) = search.state {
            
                let detailViewController = segue.destinationViewController as! DetailViewController
                
                let indexPath = sender as! NSIndexPath
                
                let searchResult = list[indexPath.row]
                
                detailViewController.searchResult = searchResult            
            }
            
        }
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        
        switch newCollection.verticalSizeClass {
            
        case .Compact:
            showLandscapeViewWithCoordinator(coordinator)
        case .Regular, .Unspecified:
            hideLandscapeViewWithCoordinator(coordinator)
            
        }
    }

    
    func showLandscapeViewWithCoordinator(coorinator: UIViewControllerTransitionCoordinator){
    
        precondition(landscapleViewController == nil)
        
        landscapleViewController = storyboard!.instantiateViewControllerWithIdentifier("LandscapeViewController") as? LandscapeViewController
        
        if let controller = landscapleViewController {
        
            controller.search = search
            
            controller.view.frame = view.bounds
            controller.view.alpha = 0
            
            view.addSubview(controller.view)
            
            addChildViewController(controller)
            
            coorinator.animateAlongsideTransition({ _ in
                
                controller.view.alpha = 1
                
                self.searchBar.resignFirstResponder()
                
                if self.presentedViewController != nil {
                
                    self.dismissViewControllerAnimated(true, completion: nil)
                
                }
                
                }, completion:{ _ in
                    
                    controller.didMoveToParentViewController(self)
            })
        }
    }
    
    /**
       隐藏进度
     
     - parameter coordinator: <#coordinator description#>
     */
    func hideLandscapeViewWithCoordinator(coordinator:UIViewControllerTransitionCoordinator){
        
        if let controller = landscapleViewController {
        
            controller.willMoveToParentViewController(nil)
            
            coordinator.animateAlongsideTransition({ _ in
                
                controller.view.alpha = 0
                
                    if self.presentedViewController != nil {
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                    }
                }, completion: { _ in
                    controller.view.removeFromSuperview()
                    controller.removeFromParentViewController()
                    self.landscapleViewController = nil
            })
        }
    }
    
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    
        performSearch()
    
    }
    
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch search.state {
        case .NotSearchedYet:
            return 0
        case .Loading:
            return 1
        case .NoResults:
            return 1
        case .Results(let list):
            return list.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch search.state {
        case .NotSearchedYet:
            
            fatalError("Should never get here")
        
        case .Loading:
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.loadingCell, forIndexPath:indexPath)
            
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
            
        case .NoResults:
            return tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.nothingFoundCell,forIndexPath: indexPath)
            
        case .Results(let list):
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifiers.searchResultCell,forIndexPath: indexPath) as! SearchResultCell
            
            let searchResult = list[indexPath.row]
            cell.configureForSearchResult(searchResult)
            return cell
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        performSegueWithIdentifier("ShowDetail", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        switch search.state {
        case .NotSearchedYet,.Loading,.NoResults:
           return nil
        case .Results:
            return indexPath
        }
    }
}
