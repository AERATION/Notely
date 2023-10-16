//
//  FolderPicker.swift
//  Notely
//
//  Created by george on 01.10.2023.
//

import Foundation
import UIKit

class FolderPicker: UITableViewController {
    
    var data: [Folder]
    
    
    init(data: [Folder]) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = data[indexPath.row].name
        cell.textLabel?.textAlignment = .left
        cell.detailTextLabel?.textColor = .black
        return cell
    }
}
