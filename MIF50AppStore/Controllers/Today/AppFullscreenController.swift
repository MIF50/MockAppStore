//
//  AppFullscreenController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/22/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class AppFullscreenController: UIViewController {
    
    var dismissHandler: (() -> ())?
    var todayItem: TodayItem?
    
    let closeBtn : UIButton = {
           let btn = UIButton()
           let buttonImage = UIImage(named: "close_button")?.withRenderingMode(.alwaysTemplate)
           btn.setImage(buttonImage, for: .normal)
           btn.tintColor = #colorLiteral(red: 0.118634904, green: 0.5518733931, blue: 0.9639316307, alpha: 1)
           btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
           return btn
       }()
    
    @objc func handleDismiss(button : UIButton){
        button.isHidden = true
        dismissHandler?()
    }
    
    let tableView = UITableView.init(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        setupCloseButton()
        setupFloatingControls()
    }
    
    fileprivate func initTableView(){
        view.clipsToBounds = true
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInsetAdjustmentBehavior = .never
        let height = UIApplication.shared.statusBarFrame.height
        tableView.contentInset = .init(top: 0, left: 0, bottom: height, right: 0)
    }
    
    fileprivate func setupCloseButton(){
        view.addSubview(closeBtn)
        closeBtn.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor,
                        padding: .init(top: 12, left: 0, bottom: 0, right: 0),
                        size: .init(width: 80, height: 40))
    }
    
    fileprivate func setupFloatingControls(){
        let floatingContainerView = UIView()
        floatingContainerView.clipsToBounds = true
        floatingContainerView.layer.cornerRadius = 12
        view.addSubview(floatingContainerView)
        let paddingBottom = UIApplication.shared.statusBarFrame.height
        floatingContainerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding:  .init(top: 0, left: 16, bottom: paddingBottom, right: 16),
                                     size: .init(width: 0, height: 90))
        let blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        floatingContainerView.addSubview(blurVisualEffect)
        blurVisualEffect.fillSuperview()
        
        // add our subviews
        let imageView = UIImageView(cornerRadius: 16)
        imageView.image = todayItem?.image
        imageView.size(width: 67, height: 67)
        
        let verticalStactView = VerticalStackView(arrangedSubViews: [
            UILabel(text: "Life Style", font: .boldSystemFont(ofSize: 16)),
            UILabel(text: "The Dialy List of Life ", font: .systemFont(ofSize: 16))
        ], spacing: 4)
        
        let btnGet = UIButton(title: "GET")
        btnGet.setTitleColor(.white, for: .normal)
        btnGet.size(width: 80, height: 32)
        btnGet.layer.cornerRadius = 16
        btnGet.titleLabel?.font = .boldSystemFont(ofSize: 16)
        btnGet.backgroundColor = .darkGray
        
        let stackView = UIStackView(arrangeViews: [
            imageView,
            verticalStactView,
            btnGet
        ], customSpacing: 16)
        floatingContainerView.addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.alignment = .center
        
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
    }
    

    
    
}

// MARK: - TableView DataSource and Delegate
extension AppFullscreenController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let headerCell = AppFullscreenHeaderCell()
            headerCell.todayCell.todayItem = todayItem
            headerCell.todayCell.layer.cornerRadius = 0
            headerCell.todayCell.clipsToBounds = true
            headerCell.todayCell.backgroundView = nil
            return headerCell
        } else {
            return AppFullscreenDescriptionCell()
        }
        
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0  {
            return TodayController.CELL_SIZE
        } else {
            return UITableView.automaticDimension
        }
        
    }
}


