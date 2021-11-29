//
//  ViewController.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/28.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import RealmSwift

class SearchViewController: UIViewController {
    enum ContentType {
        case keyword
        case app
    }
    var contentType: ContentType = .keyword {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var disposeBag = DisposeBag()
    let realm = try! Realm()
    var mySearches: [MySearch] = [] {
        didSet {
            mySearches.sort(by: {$0.id > $1.id} )
        }
    }
    var apps: [AppStoreApp] = []
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var appsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mySearches = RealmManager.shared.readMySearches()
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AppTableViewCell", bundle: nil), forCellReuseIdentifier: "AppTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        contentType = .keyword
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        RealmManager.shared.writeMySearch(keyword: keyword)
        Service.shared.fetchApps(term: keyword) { response, error in
            self.apps = response?.results ?? []
            self.contentType = .app
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        contentType = .keyword
        guard !searchText.isEmpty else {
            mySearches = RealmManager.shared.readMySearches()
            return
        }
        mySearches = RealmManager.shared.fetchMySearches(keyword: searchText)
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch contentType {
        case .keyword: return mySearches.count
        case .app: return apps.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch contentType {
        case .keyword:
            let cell = UITableViewCell()
            cell.imageView?.image = UIImage(systemName: "magnifyingglass")
            cell.textLabel?.text = mySearches[indexPath.row].keyword
            return cell
        case .app:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "AppTableViewCell", for: indexPath) as? AppTableViewCell else { return UITableViewCell() }
            cell.app = apps[indexPath.row]
            return cell
        }
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch contentType {
        case .keyword:
            let keyword = mySearches[indexPath.row].keyword
            searchController.searchBar.text = keyword
            Service.shared.fetchApps(term: keyword) { response, error in
                self.apps = response?.results ?? []
                self.contentType = .app
            }
        case .app:
            guard let detailAppViewController = storyboard?.instantiateViewController(
                withIdentifier: "DetailAppViewController") as? DetailAppViewController else { return }
            detailAppViewController.app = apps[indexPath.row]
            navigationController?.pushViewController(detailAppViewController, animated: true)
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}
