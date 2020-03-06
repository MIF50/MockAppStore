//
//  AppFullscreenController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/22/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class AppFullscreenController: UITableViewController {
    
    var dismissHandler: (() -> ())?
    var todayItem: TodayItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        let height = UIApplication.shared.statusBarFrame.height
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
        
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let headerCell = AppFullscreenHeaderCell()
            headerCell.closeBtn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
            headerCell.todayCell.todayItem = todayItem
            headerCell.todayCell.layer.cornerRadius = 0
            headerCell.todayCell.clipsToBounds = true
            return headerCell
        }
        let cell = AppFullscreenDescriptionCell()
        
        return cell
    }
    
    @objc func handleDismiss(button : UIButton){
        button.isHidden = true
        dismissHandler?()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0  {
            return TodayController.CELL_SIZE
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
}
