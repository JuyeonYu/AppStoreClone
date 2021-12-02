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
        appsTableView.registerCellFromNib(AppTableViewCell.self)
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
                detailAppViewController.appInfo = [["제공자", app.sellerName],
                                                   ["크기", "\(Double((Int(app.fileSizeBytes) ?? 1) / 1000000))MB"],
                                                   ["카테고리", app.genres[0]],
                                                   ["연령 등급", app.trackContentRating],
                                                   ["저작권", app.sellerName],
                                                   ["개발자 웹사이트", app.sellerUrl ?? ""]]
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
                if isApp {
                    self?.searchController.searchBar.resignFirstResponder()
                } else {
                    self?.appsTableView.scrollToRow(at: NSIndexPath(row: NSNotFound, section: 0) as IndexPath,
                                                    at: .top,
                                                    animated: false)
                }
            }).disposed(by: disposeBag)
        reactor.state
            .map { $0.apps }
            .bind(to: appsTableView.rx.items) { tableView, row, app in
                let cell = tableView.dequeue(AppTableViewCell.self, for: IndexPath(row: row, section: 0))
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
