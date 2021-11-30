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
    var unfoldReleaseNote: Bool = false
    var unfoldDescription: Bool = false
    var appInfo: [[String]] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "AppMainTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "AppMainTableViewHeader")
        tableView.register(UINib(nibName: "AppSummaryTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "AppSummaryTableViewHeader")
        tableView.register(UINib(nibName: "AppReleaseNoteTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "AppReleaseNoteTableViewHeader")
        tableView.register(UINib(nibName: "AppScreenShotsHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "AppScreenShotsHeader")
        tableView.register(UINib(nibName: "AppDescriptionTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "AppDescriptionTableViewHeader")
        tableView.register(UINib(nibName: "AppSellerTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "AppSellerTableViewHeader")
        tableView.register(UINib(nibName: "AppInfoTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "AppInfoTableViewHeader")
        tableView.register(UINib(nibName: "SeparatorTableViewFooter", bundle: nil), forHeaderFooterViewReuseIdentifier: "SeparatorTableViewFooter")
        tableView.register(UINib(nibName: "AppInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "AppInfoTableViewCell")
        
        appInfo = [["제공자", app.sellerName],
                   ["크기", app.fileSizeBytes],
                   ["카테고리", app.genres[0]],
                   ["연령 등급", app.trackContentRating],
                   ["저작권", app.sellerName],
                   ["개발자 웹사이트", app.sellerUrl ?? ""]]
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
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AppMainTableViewHeader") as! AppMainTableViewHeader
            header.thumbnail.load(urlString: app.artworkUrl100)
            header.title.text = app.trackName
            header.genre.text = app.genres.first
            return header
        case .summary:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AppSummaryTableViewHeader") as! AppSummaryTableViewHeader
            (header.ratingStackView.subviews[0] as? UILabel)?.text = "\(app.userRatingCount)개의 평가"
            (header.ratingStackView.subviews[1] as? UILabel)?.text = "\((round(app.averageUserRating * 10) / 10))"
            (header.ratingStackView.subviews[2] as? UIStackView)?.addStar(rating: app.averageUserRating)
            (header.ageStackView.subviews[1] as? UILabel)?.text = app.trackContentRating
            (header.chartStackView.subviews[2] as? UILabel)?.text = app.genres.first
            (header.languageStackView.subviews[1] as? UILabel)?.text = app.languageCodesISO2A.contains(Locale.current.regionCode ?? "KO") ? Locale.current.regionCode : app.languageCodesISO2A.first
            (header.languageStackView.subviews[2] as? UILabel)?.text = "+ \(app.languageCodesISO2A.count)개 언어"
            (header.developerStackView.subviews[2] as? UILabel)?.text = app.sellerName
            return header
        case .releaseNote:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AppReleaseNoteTableViewHeader") as! AppReleaseNoteTableViewHeader
            let initialLabelNumber = header.foldableLabel.contentView.initialLabelNumber
            header.foldableLabel.contentView.label.text = app.releaseNotes
            header.foldableLabel.contentView.label.numberOfLines = unfoldReleaseNote ? 0 : initialLabelNumber
            header.foldableLabel.contentView.toggle.isHidden = unfoldReleaseNote || header.foldableLabel.contentView.label.calculateMaxLines() == initialLabelNumber
            header.foldableLabel.contentView.onToggle = {
                self.unfoldReleaseNote.toggle()
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integer: type.rawValue), with: .none)
                }
            }
            header.version.text = app.version
            header.date.text = app.currentVersionReleaseDate
            return header
        case .screenShot:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AppScreenShotsHeader") as! AppScreenShotsHeader
            header.collectionView.dataSource = self
            header.collectionView.delegate = self
            return header
        case .description:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AppDescriptionTableViewHeader") as! AppDescriptionTableViewHeader
            let initialLabelNumber = header.foldableLabel.contentView.initialLabelNumber
            header.foldableLabel.contentView.label.text = app.description
            header.foldableLabel.contentView.label.numberOfLines = unfoldDescription ? 0 : initialLabelNumber
            header.foldableLabel.contentView.toggle.isHidden = unfoldDescription || header.foldableLabel.contentView.label.calculateMaxLines() == initialLabelNumber
            header.foldableLabel.contentView.onToggle = {
                self.unfoldDescription.toggle()
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integer: type.rawValue), with: .none)
                }
            }
            return header
        case .seller:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AppSellerTableViewHeader") as! AppSellerTableViewHeader
            header.seller.text = app.sellerName
            return header
        case .information:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AppInfoTableViewHeader") as! AppInfoTableViewHeader
            header.infoView.contentView.title.text = "정보"
            header.infoView.contentView.title.font = UIFont.boldSystemFont(ofSize: 20)
            header.infoView.contentView.subTitle.isHidden = true
            header.infoView.contentView.accessory.isHidden = true
            return header
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let type = ContentType.init(rawValue: section) else { return UIView() }
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SeparatorTableViewFooter") as! SeparatorTableViewFooter
        if type == .main {
            footer.separatorTrailing.constant = 0
        } else {
            footer.separatorTrailing.constant = 16
        }
        return footer
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let type = ContentType.init(rawValue: section) else { return .leastNonzeroMagnitude }
        switch type {
        case .main, .releaseNote,.screenShot: return 0.1
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppInfoTableViewCell", for: indexPath) as! AppInfoTableViewCell
            cell.infoView.contentView.title.text = appInfo[indexPath.row][0]
            cell.infoView.contentView.subTitle.text = appInfo[indexPath.row][1]
            cell.infoView.contentView.subTitle.isHidden = indexPath.row == appInfo.count - 1
            cell.infoView.contentView.accessory.isHidden = indexPath.row < appInfo.count - 1
            cell.infoView.contentView.title.textColor = indexPath.row < appInfo.count - 1 ? .systemGray : .tintColor
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenshotCollectionViewCell", for: indexPath) as! ScreenshotCollectionViewCell
        cell.screenshot.load(urlString: app.screenshotUrls[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        app.screenshotUrls.count
    }
}

extension DetailAppViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 200, height: 400)
    }
}
