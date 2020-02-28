//
//  TodayController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/22/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class TodayController: BaseListContoller {
    
    static let CELL_SIZE: CGFloat = 500
    
    var appGame: AppGroup?
    var topGrossing: AppGroup?
    
    // create load indicator
      let activityIndicatorView : UIActivityIndicatorView = {
          let avi = UIActivityIndicatorView(style: .whiteLarge)
          avi.color = .black
          avi.startAnimating()
          avi.hidesWhenStopped = true
          return avi
      }()
    
    
    var items = [TodayItem]()
    
    var startingFrame: CGRect?
    var appFullscreenVC: AppFullscreenController!
    
    // auto layout constraint animations
    var topConstraint: NSLayoutConstraint?
    var leadingConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?
    var heightConstraint: NSLayoutConstraint?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        
    
        collectionView.backgroundColor = #colorLiteral(red: 0.9410567326, green: 0.9410567326, blue: 0.9410567326, alpha: 1)
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleCell.self, forCellWithReuseIdentifier: TodayItem.CellType.muliple.rawValue)
        
        fetchData()
    
    }
    
    
    private func fetchData(){
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        Service.share.fetchGames { (res) in
            dispatchGroup.leave()
            switch res {
            case .success(let appGroup):
                self.appGame = appGroup
            case .failure(let error):
                print("error \(error)")
            }
        }
        dispatchGroup.enter()
        Service.share.fetchTopGrossing { (res) in
            dispatchGroup.leave()
            switch res {
            case .success(let appGroup):
                self.topGrossing = appGroup
            case .failure(let error):
                print("error \(error)")
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicatorView.stopAnimating()
            self.items = [
                TodayItem.init(
                    category: "Daily List",
                    title: self.appGame?.feed.title ?? "",
                    image: #imageLiteral(resourceName: "garden"),
                    description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white,
                    cellType: .muliple,
                    feedResults: self.appGame?.feed.results ?? []
                ),
                TodayItem.init(
                    category: "Daily List",
                    title: self.topGrossing?.feed.title ?? "",
                    image: #imageLiteral(resourceName: "garden"),
                    description: "All the tools and apps you need to intelligently organize your life the right way.", backgroundColor: .white,
                               cellType: .muliple,
                               feedResults: self.topGrossing?.feed.results ?? []
                ),
                TodayItem.init(category: "THE DAILY LIST",
                               title: "Test -Drive These CarPlay Apps",
                               image: #imageLiteral(resourceName: "garden"),
                               description: "",
                               backgroundColor: .white,
                               cellType: .single,
                               feedResults: []
                ),
                TodayItem.init(category: "HOLIDAYS",
                               title: "Travel on a Budget",
                               image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything!",
                               backgroundColor: #colorLiteral(red: 0.9838578105, green: 0.9588007331, blue: 0.7274674177, alpha: 1),
                               cellType: .single,
                               feedResults: []
                )
            ]
            
            self.collectionView.reloadData()
        }
    }
}


// MARK: - UICollectionViewDataSource
extension TodayController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if items[indexPath.item].cellType == .muliple {
            let fullMultipleVC = TodayMultipleAppsController(mode: .fullscreen)
            fullMultipleVC.modalPresentationStyle = .fullScreen
            fullMultipleVC.feedResults = self.items[indexPath.item].feedResults
            present(fullMultipleVC, animated: true)
            return
        }
        let appFullscreenVC = AppFullscreenController()
        appFullscreenVC.todayItem = items[indexPath.item]
        appFullscreenVC.dismissHandler = {
            self.handleRemoveRedView()
        }
        let appFullscreenView = appFullscreenVC.view!
//        redView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView)))
        view.addSubview(appFullscreenView)
        addChild(appFullscreenVC)
        self.appFullscreenVC = appFullscreenVC
        self.collectionView.isUserInteractionEnabled = false
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        // absolute coordinate for cell
        guard let startFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        startingFrame = startFrame

        appFullscreenView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = appFullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startFrame.origin.y)
        leadingConstraint = appFullscreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startFrame.origin.x)
        widthConstraint = appFullscreenView.widthAnchor.constraint(equalToConstant: startFrame.width)
        heightConstraint = appFullscreenView.heightAnchor.constraint(equalToConstant: startFrame.height)
        [topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({ $0?.isActive = true })
        self.view.layoutIfNeeded() // starts animation
        appFullscreenView.layer.cornerRadius = 16
        
       

        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.topConstraint?.constant = 0
            self.leadingConstraint?.constant = 0
            self.widthConstraint?.constant = self.view.frame.width
            self.heightConstraint?.constant = self.view.frame.height
            self.view.layoutIfNeeded() // starts animation
            self.beginAnimationAppFullscreen()
            
             guard let headerCell = self.appFullscreenVC.tableView.cellForRow(at: [0,0]) as? AppFullscreenHeaderCell else { return }
            headerCell.todayCell.topConstraint.constant = 48
            headerCell.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func handleRemoveRedView() {
        // access startingFrame
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {

            guard let startFrame = self.startingFrame else { return }
            self.topConstraint?.constant = startFrame.origin.y
            self.leadingConstraint?.constant = startFrame.origin.x
            self.widthConstraint?.constant = startFrame.width
            self.heightConstraint?.constant = startFrame.height
            self.view.layoutIfNeeded() // starts animation
            self.appFullscreenVC.tableView.contentOffset = .zero

            self.handleAppFullscreenDismissal()
            
            guard let headerCell = self.appFullscreenVC.tableView.cellForRow(at: [0,0]) as? AppFullscreenHeaderCell else { return }
                      headerCell.todayCell.topConstraint.constant = 24
                      headerCell.layoutIfNeeded()
        }, completion: { _ in
            self.appFullscreenVC.view?.removeFromSuperview()
            self.appFullscreenVC.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    fileprivate func beginAnimationAppFullscreen() {
        // self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
        self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
    }
    
    @objc func handleAppFullscreenDismissal() {
        // self.tabBarController?.tabBar.transform = .identity
        if let tabBarFrame = self.tabBarController?.tabBar.frame {
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: items[indexPath.item].cellType.rawValue, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        return cell
    }
}

// MARK: - Collection View Flow Layout Delegate
extension TodayController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 48 , height: TodayController.CELL_SIZE)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
}
