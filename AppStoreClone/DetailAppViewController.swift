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
        case developer
        case information
    }
    var app: AppStoreApp!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "AppMainTableViewCell", bundle: nil), forCellReuseIdentifier: "AppMainTableViewCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

extension DetailAppViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ContentType.allCases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = ContentType.init(rawValue: indexPath.row) else { return UITableViewCell() }
        switch type {
        case .main:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppMainTableViewCell", for: indexPath) as! AppMainTableViewCell
            cell.thumbnail.load(urlString: app.artworkUrl60)
            cell.title.text = app.trackName
            cell.desc.text = app.primaryGenreName
            return cell
        case .summary:
            fallthrough
        case .releaseNote:
            fallthrough
        case .screenShot:
            fallthrough
        case .description:
            fallthrough
        case .developer:
            fallthrough
        case .information:
            return UITableViewCell()
        }
    }
}

extension DetailAppViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let type = ContentType.init(rawValue: indexPath.row) else { return .leastNonzeroMagnitude }
        switch type {
        case .main:
            return 150
        case .summary:
            fallthrough
        case .releaseNote:
            fallthrough
        case .screenShot:
            fallthrough
        case .description:
            fallthrough
        case .developer:
            fallthrough
        case .information:
            return .leastNonzeroMagnitude
        }
    }
}
