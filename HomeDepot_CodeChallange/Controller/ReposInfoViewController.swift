//
//  ReposInfoViewController.swift
//  HomeDepot_CodeChallange
//
//  Created by  MyMac on 4/26/18.
//  Copyright © 2018 asdf. All rights reserved.
//

import UIKit

enum DisplayFormat:Int{
    case list
    case grid
}

class ReposInfoViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var repoSearchBar: UISearchBar!
    @IBOutlet weak var repoListTableView: UITableView!
    @IBOutlet weak var repoGridCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var reposArray = [RepoItem]()
    var searchString = ""
    var loadedPageNumber : Int = 1
    var loadingData : Bool = false
    
    var displayFormat:DisplayFormat = .list{
        didSet{
            if displayFormat == .list{
                self.repoListTableView.isHidden = false
                self.repoGridCollectionView.isHidden = true
            }else{
                self.repoListTableView.isHidden = true
                self.repoGridCollectionView.isHidden = false

            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.activityIndicator.hidesWhenStopped = true
        self.displayFormat = .list
        self.repoListTableView.estimatedRowHeight = 100.0
        self.repoListTableView.rowHeight = UITableViewAutomaticDimension
        self.repoListTableView.tableFooterView = UIView()
        
        self.repoGridCollectionView.collectionViewLayout = RepoCollectionLayout()
        self.repoSearchBar.placeholder = "Enter any user"
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Searchbar delegate methods
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        if let searchStr = searchBar.text{
            if searchStr != "" {
                self.searchString = searchStr
                self.loadingData = true
                searchBar.resignFirstResponder()
                self.retriveRepoList(searchString: searchStr, pageNumber: "1")
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.reposArray.count > 0 && searchBar.text == ""{
            self.reposArray.removeAll()
            self.repoListTableView.reloadData()
            self.repoGridCollectionView.reloadData()
        }
    }
    
    @IBAction func displayModeChaged(_ sender: UISegmentedControl) {
        if let selectedDisplayMode = DisplayFormat(rawValue:sender.selectedSegmentIndex){
            self.displayFormat = selectedDisplayMode
        }
    }
    
    
    func retriveRepoList(searchString: String, pageNumber: String){
        let urlStr = "https://api.github.com/users/\(searchString)/repos?page=\(pageNumber)&per_page=10"
            self.activityIndicator.startAnimating()
            RepoWebserviceManager.getRepoList(url: urlStr, completionHandler: { (repoList:[RepoItem]?, error:Error?) -> Void in
                if error != nil{
                    RepoUtils.showAlert(controller: self, title: "error", message: "")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                    }
                    return
                }
                guard let repoList = repoList else{
                    return
                }
                if self.reposArray.count == 0{
                    self.reposArray = repoList
                }else{
                   self.reposArray.append(contentsOf: repoList)
                }

                DispatchQueue.main.async {
                    self.repoListTableView.reloadData()
                    self.repoGridCollectionView.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.loadingData = false
                }
            })
    }

}

extension ReposInfoViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.reposArray.count == 0 {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No repos available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return self.reposArray.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.reposArray.count - 1
        if  !self.loadingData && indexPath.row == lastElement {
            self.loadingData = true
            let nextPage : Int = self.loadedPageNumber + 1
           self.retriveRepoList(searchString: self.searchString, pageNumber: String(nextPage))
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as? RepoListViewCell else{
            return UITableViewCell()
        }
        let repo = self.reposArray[indexPath.row]
        if let name = repo.repoName{
            cell.repoName.text = name
        }
        if let description = repo.repoDescription{
            cell.repoDescription.text = description
        }
        if let createdAt = repo.repoCreated_at{
            cell.repoCreatedDate.text = createdAt
        }
        if let licenseName = repo.repoLicense{
            cell.repoLicense.text = licenseName.name
        }
        return cell
    }
    
}


extension ReposInfoViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if self.reposArray.count == 0 {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            noDataLabel.text          = "No repos available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            collectionView.backgroundView  = noDataLabel
        }
        else {
            collectionView.backgroundView = nil
        }

        return self.reposArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RepoCell", for: indexPath as IndexPath) as! RepoCollectionViewCell
        
        let repo = self.reposArray[indexPath.row]
        if let name = repo.repoName{
            cell.repoName.text = name
        }
        if let description = repo.repoDescription{
            cell.repoDescription.text = description
        }
        if let createdAt = repo.repoCreated_at{
            cell.repoCreatedDate.text = createdAt
        }
        if let licenseName = repo.repoLicense{
            cell.repoLicense.text = licenseName.name
        }
        cell.sizeToFit()
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastElement = self.reposArray.count - 1
        if  !self.loadingData && indexPath.row == lastElement {
            self.loadingData = true
            let nextPage : Int = self.loadedPageNumber + 1
            self.retriveRepoList(searchString: self.searchString, pageNumber: String(nextPage))
        }

    }
    
}

