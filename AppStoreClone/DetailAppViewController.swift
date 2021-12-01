//
//  DetailAppViewController.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/28.
//

import UIKit
import Network

class DetailAppViewController: UIViewController {
    enum ContentType: Int, CaseIterable {
        case main
        case summary
        case releaseNote
        case screenShot
        case description
        case seller
        case information
    }
    var app: AppStoreApp!
    var appInfo: [[String]]!
    var unfoldReleaseNote: Bool = false
    var unfoldDescription: Bool = false
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerViewFromNib(AppMainTableViewHeader.self)
        tableView.registerViewFromNib(AppSummaryTableViewHeader.self)
        tableView.registerViewFromNib(AppReleaseNoteTableViewHeader.self)
        tableView.registerViewFromNib(AppScreenShotsHeader.self)
        tableView.registerViewFromNib(AppDescriptionTableViewHeader.self)
        tableView.registerViewFromNib(AppSellerTableViewHeader.self)
        tableView.registerViewFromNib(AppInfoTableViewHeader.self)
        tableView.registerViewFromNib(SeparatorTableViewFooter.self)
        tableView.registerCellFromNib(AppInfoTableViewCell.self)
    }
}

extension DetailAppViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        ContentType.allCases.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let type = ContentType.init(rawValue: section) else { return UIView() }
        switch type {
        case .main:
            let header = tableView.dequeue(AppMainTableViewHeader.self)
            header.app = app
            return header
        case .summary:
            let header = tableView.dequeue(AppSummaryTableViewHeader.self)
            header.app = app
            return header
        case .releaseNote:
            let header = tableView.dequeue(AppReleaseNoteTableViewHeader.self)
            header.app = app
            header.configure(isUnfoldReleaseNote: unfoldReleaseNote)
            header.foldableLabel.contentView.onToggle = {
                self.unfoldReleaseNote.toggle()
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integer: type.rawValue), with: .fade)
                }
            }
            return header
        case .screenShot:
            let header = tableView.dequeue(AppScreenShotsHeader.self)
            header.collectionView.dataSource = self
            header.collectionView.delegate = self
            return header
        case .description:
            let header = tableView.dequeue(AppDescriptionTableViewHeader.self)
            header.app = app
            header.configure(isUnfoldDescription: unfoldDescription)
            header.foldableLabel.contentView.onToggle = {
                self.unfoldDescription.toggle()
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integer: type.rawValue), with: .fade)
                }
            }
            return header
        case .seller:
            let header = tableView.dequeue(AppSellerTableViewHeader.self)
            header.app = app
            return header
        case .information:
            return tableView.dequeue(AppInfoTableViewHeader.self)
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let type = ContentType.init(rawValue: section) else { return UIView() }
        let footer = tableView.dequeue(SeparatorTableViewFooter.self)
        switch type {
        case .main: footer.separatorTrailing.constant = 0
        default: footer.separatorTrailing.constant = 16
        }
        return footer
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let type = ContentType.init(rawValue: section) else { return .leastNonzeroMagnitude }
        switch type {
        case .main, .summary, .releaseNote, .screenShot: return 0.1
        default: return .leastNonzeroMagnitude
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let type = ContentType.init(rawValue: section) else { return 0 }
        switch type {
        case .information: return appInfo.count
        default: return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = ContentType.init(rawValue: indexPath.section) else { return UITableViewCell() }
        switch type {
        case .information:
            let cell = tableView.dequeue(AppInfoTableViewCell.self, for: indexPath)
            cell.configure(appInfo: appInfo, row: indexPath.row)
            return cell
        default: return UITableViewCell()
        }
    }
}

extension DetailAppViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == ContentType.information.rawValue && indexPath.row == appInfo.count - 1,
           let url = URL(string: appInfo.last?[1] ?? "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension DetailAppViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(ScreenshotCollectionViewCell.self, for: indexPath)
        cell.screenshot.load(urlString: app.screenshotUrls[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        app.screenshotUrls.count
    }
}

extension DetailAppViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 200, height: 400)
    }
}
