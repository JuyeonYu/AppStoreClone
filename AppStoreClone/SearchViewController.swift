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
import RxDataSources

class SearchViewController: UIViewController, StoryboardView {
    var disposeBag: DisposeBag = DisposeBag()
    enum ContentType {
        case keyword
        case app
    }
//    var contentType: ContentType = .keyword {
//        didSet {
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
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
        reactor = SearchReactor()
        mySearches = RealmManager.shared.readMySearches()
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
//        searchController.searchBar.delegate = self
//        tableView.delegate = self
//        tableView.dataSource = nil
        

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BasicCell")
        appsTableView.register(UINib(nibName: "AppTableViewCell", bundle: nil), forCellReuseIdentifier: "AppTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    func bind(reactor: SearchReactor) {
        Observable.just(Void())
            .map { Reactor.Action.read(keyword: "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        tableView.rx.didScroll
            .asDriver()
            .drive(onNext: {
                self.searchController.searchBar.resignFirstResponder()
            }).disposed(by: disposeBag)
        tableView.rx.modelSelected(MySearch.self)
            .map { Reactor.Action.onSearch(keyword: $0.keyword) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        searchController.searchBar.rx.searchButtonClicked
            .map { Reactor.Action.onSearch(keyword: self.searchController.searchBar.text ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        searchController.searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.read(keyword: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.mySearches }
            .bind(to: tableView.rx.items) { _, _, mySearch in
                let cell = UITableViewCell()
                cell.imageView?.image = UIImage(systemName: "magnifyingglass")
                cell.textLabel?.text = mySearch.keyword
                return cell
            }.disposed(by: disposeBag)
        reactor.state
            .map { $0.contentType == .app }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: true)
            .drive(onNext: { [weak self] isApp in
                self?.tableView.isHidden = isApp
                self?.appsTableView.isHidden = !isApp
                if isApp {
                    self?.searchController.searchBar.resignFirstResponder()
                }
            }).disposed(by: disposeBag)
        reactor.state
            .map { $0.apps }
            .bind(to: appsTableView.rx.items) { tableView, row, app in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "AppTableViewCell", for: IndexPath(row: row, section: 0)) as! AppTableViewCell
                cell.app = app
                return cell
            }.disposed(by: disposeBag)
        reactor.state
            .map { $0.keyword }
            .distinctUntilChanged()
            .bind(to: searchController.searchBar.rx.text)
            .disposed(by: disposeBag)
        reactor.state
            .filter { $0.contentType == .keyword }
            .map { $0.mySearches.count == 0 }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] emptyApp in
                if emptyApp {
                    self?.tableView.setEmptyMessage(title: "검색 기록 없음", subTitle: "새로운 앱을 검색해보세요!")
                } else {
                    self?.tableView.restore()
                }
            }).disposed(by: disposeBag)
        reactor.state
            .filter { $0.contentType == .app }
            .map { $0.apps.count == 0 }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] emptyApp in
                if emptyApp {
                    self?.appsTableView.setEmptyMessage(title: "결과 없음", subTitle: reactor.currentState.keyword)
                } else {
                    self?.appsTableView.restore()
                }
            }).disposed(by: disposeBag)
    }
}

extension SearchViewController {
    static func dataSource() -> RxTableViewSectionedReloadDataSource<SearchModel> {
        return RxTableViewSectionedReloadDataSource<SearchModel>(
            configureCell: { dataSource, tableView, indexPath, _ in
                switch dataSource[indexPath] {
                case .Keyword(let item):
                    let cell = UITableViewCell()
                    cell.imageView?.image = UIImage(systemName: "magnifyingglass")
                    cell.textLabel?.text = item.keyword
                    return cell

                case .App(let item):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AppTableViewCell", for: indexPath) as! AppTableViewCell
                    cell.app = item
                    return cell

                }
            }
        )
    }
}


//extension SearchViewController: UISearchBarDelegate {
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        contentType = .keyword
//    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let keyword = searchBar.text else { return }
//        RealmManager.shared.writeMySearch(keyword: keyword)
//        Service.shared.fetchApps(term: keyword) { response, error in
//            self.apps = response?.results ?? []
//            self.contentType = .app
//        }
//    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        contentType = .keyword
//        guard !searchText.isEmpty else {
//            mySearches = RealmManager.shared.readMySearches()
//            return
//        }
//        mySearches = RealmManager.shared.fetchMySearches(keyword: searchText)
//    }
//}

//extension SearchViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch contentType {
//        case .keyword: return mySearches.count
//        case .app: return apps.count
//        }
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch contentType {
//        case .keyword:
//            let cell = UITableViewCell()
//            cell.imageView?.image = UIImage(systemName: "magnifyingglass")
//            cell.textLabel?.text = mySearches[indexPath.row].keyword
//            return cell
//        case .app:
//            guard let cell = tableView.dequeueReusableCell(
//                withIdentifier: "AppTableViewCell", for: indexPath) as? AppTableViewCell else { return UITableViewCell() }
//            cell.app = apps[indexPath.row]
//            return cell
//        }
//    }
//}
//
//extension SearchViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch contentType {
//        case .keyword:
//            let keyword = mySearches[indexPath.row].keyword
//            searchController.searchBar.text = keyword
//            Service.shared.fetchApps(term: keyword) { response, error in
//                self.apps = response?.results ?? []
//                self.contentType = .app
//            }
//        case .app:
//            guard let detailAppViewController = storyboard?.instantiateViewController(
//                withIdentifier: "DetailAppViewController") as? DetailAppViewController else { return }
//            detailAppViewController.app = apps[indexPath.row]
//            navigationController?.pushViewController(detailAppViewController, animated: true)
//        }
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        searchController.searchBar.resignFirstResponder()
//    }
//}
