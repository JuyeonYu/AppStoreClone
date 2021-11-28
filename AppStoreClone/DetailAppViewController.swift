//
//  DetailAppViewController.swift
//  AppStoreClone
//
//  Created by Juyeon on 2021/11/28.
//

import UIKit
import Network

class DetailAppViewController: UIViewController {
    enum ContentType: Int {
        case main
        case newFeature
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
    }
}

extension DetailAppViewController: UITableViewDataSource {

}
