//
//  ViewController.swift
//  PlayApp
//  Copyright © 2018 . All rights reserved.
//

import UIKit

let MINIMUM_WIDTH = CGFloat(5)

class ViewController: UIViewController {

    @IBOutlet weak public var repoCollectionView: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let repoSearchController = UISearchController(searchResultsController: nil)
    var itemWidth = CGFloat(0)
    var itemHeight = CGFloat(0)
    var frameSize: CGSize!
    var repoDataSource = [Repository]()
    var pageNo = 1
    var isGrid = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frameSize = self.view.frame.size
        itemWidth = frameSize.width
        itemHeight = frameSize.width/3
        initializeRepoSearchUI()
        initializeRepoResponseUI()
    }

    override func viewDidLayoutSubviews() {
        recalculateLayout()
    }
    
    func initializeRepoSearchUI() {

        repoSearchController.searchBar.placeholder = "Organization"
        repoSearchController.searchBar.delegate = self
        repoSearchController.dimsBackgroundDuringPresentation = false
        repoSearchController.obscuresBackgroundDuringPresentation = false
        repoSearchController.hidesNavigationBarDuringPresentation = false
        
        if #available(iOS 11.0, *){
            self.navigationItem.searchController = repoSearchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        else{
            self.navigationItem.titleView = repoSearchController.searchBar
        }
        self.definesPresentationContext = true
    }
    
    func initializeRepoResponseUI() {
        repoCollectionView.register(UINib(nibName: "ListCell", bundle: Bundle.main), forCellWithReuseIdentifier: "listCell")
        repoCollectionView.isHidden = false
    }
    
    @IBAction func toggleLayout(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0) {
            isGrid = false
        }
        else{
            isGrid = true
        }
        recalculateLayout()
    }
    
    func recalculateLayout() {
        itemWidth = !isGrid ? repoCollectionView.frame.size.width : repoCollectionView.frame.size.width / 2
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.repoCollectionView.reloadData()
        }
    }
}


//MARK: UICollectionView Extension

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repoDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let repoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! ListCollectionViewCell
        repoCell.configure(repo: repoDataSource[indexPath.row])
        return repoCell
    }

}

extension ViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if(indexPath.row == repoDataSource.count-1 && pageNo <= Utilies.page){
            pageNo += 1
            getRepos(page: pageNo, append: true)
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth - MINIMUM_WIDTH, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return MINIMUM_WIDTH
    }
}

//MARK: UISearchController Extension

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        repoDataSource = []
        self.getRepos(org: searchBar.text!, page: 1)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        repoDataSource = []
        repoCollectionView.reloadData()
    }
}

//MARK: For API Calls
extension ViewController {
    func getRepos(org:String = "", page:Int, append: Bool = false) {
        self.activityIndicator.startAnimating()
        APIManager.sharedInstance.makeGetCall(orgName: org.lowercased(), page: page){ (repos, error) in
             DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            if(error != ""){
                DispatchQueue.main.async {
                    self.repoDataSource = []
                    self.repoCollectionView.reloadData()
                }
                self.present(Utilies.createAlert(title: "Error", message: error), animated: true, completion: nil)
            }
            else{
                if(!append){
                    self.repoDataSource = repos
                }
                else{
                    self.repoDataSource.append(contentsOf: repos)
                }
                DispatchQueue.main.async {
                    self.repoCollectionView.reloadData()
                }
            }
        }
    }
}

