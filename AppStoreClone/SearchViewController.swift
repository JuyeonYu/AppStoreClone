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
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var keywordTableView: UITableView!
    @IBOutlet weak var appsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = SearchReactor()
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        keywordTableView.register(UITableViewCell.self, forCellReuseIdentifier: "BasicCell")
        appsTableView.register(UINib(nibName: "AppTableViewCell", bundle: nil), forCellReuseIdentifier: "AppTableViewCell")
        
        keywordTableView.rx.didScroll
            .filter { self.searchController.searchBar.isFirstResponder }
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.searchController.searchBar.resignFirstResponder()
            }).disposed(by: disposeBag)
        appsTableView.rx.modelSelected(AppStoreApp.self)
            .asDriver()
            .drive(onNext: { [weak self] app in
                guard let detailAppViewController = self?.storyboard?.instantiateViewController(
                    withIdentifier: "DetailAppViewController") as? DetailAppViewController else { return }
                detailAppViewController.app = app
                self?.navigationController?.pushViewController(detailAppViewController, animated: true)
            }).disposed(by: disposeBag)
    }
    func bind(reactor: SearchReactor) {
        Observable.just(Void())
            .map { Reactor.Action.read(keyword: "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        keywordTableView.rx.modelSelected(MySearch.self)
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
            .bind(to: keywordTableView.rx.items) { _, _, mySearch in
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
                self?.keywordTableView.isHidden = isApp
                self?.appsTableView.isHidden = !isApp
                if isApp && self?.searchController.searchBar.isFirstResponder ?? false {
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
                    self?.keywordTableView.setEmptyMessage(title: "검색 기록 없음", subTitle: "새로운 앱을 검색해보세요!")
                } else {
                    self?.keywordTableView.restore()
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
