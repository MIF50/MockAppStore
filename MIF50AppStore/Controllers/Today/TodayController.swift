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
          let avi = UIActivityIndicatorView(style: .large)
          avi.color = .black
          avi.startAnimating()
          avi.hidesWhenStopped = true
          return avi
      }()
    
    let blurVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    
    
    var items = [TodayItem]()
    
    var startingFrame: CGRect?
    var appFullscreenVC: AppFullscreenController!
    
    // auto layout constraint animations
    var anchoredConstaints: AnchoredConstraints?
    var appFullscreenBeginOffset: CGFloat = 0

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBlurEffect()
        addActivityIndicator()
        initCollectionView()
        fetchData()
    
    }
    
    fileprivate func addBlurEffect(){
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.fillSuperview()
        blurVisualEffectView.alpha = 0
    }
    
    fileprivate func addActivityIndicator(){
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
    }
    
    fileprivate func initCollectionView(){
        collectionView.backgroundColor = #colorLiteral(red: 0.9410567326, green: 0.9410567326, blue: 0.9410567326, alpha: 1)
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleCell.self, forCellWithReuseIdentifier: TodayItem.CellType.muliple.rawValue)
    }
    
    private func fetchData(){
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        APIServices.share.fetchGames { (res) in
            dispatchGroup.leave()
            switch res {
            case .success(let appGroup):
                self.appGame = appGroup
            case .failure(let error):
                print("error \(error)")
            }
        }
        dispatchGroup.enter()
        APIServices.share.fetchTopGrossing { (res) in
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
                    category: "THE DAILY LIST",
                    title: "Test -Drive These CarPlay Apps",
                    image: #imageLiteral(resourceName: "garden"),
                    description: "",
                    backgroundColor: .white,
                    cellType: .single,
                    feedResults: []
                ),
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
                
                TodayItem.init(
                    category: "HOLIDAYS",
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
    
    fileprivate func showDailyAppFullScreen(_ indexPath: IndexPath) {
        let fullMultipleVC = TodayMultipleAppsController(mode: .fullscreen)
        fullMultipleVC.modalPresentationStyle = .fullScreen
        fullMultipleVC.feedResults = self.items[indexPath.item].feedResults
        let navC = BackEnabledNavigationController(rootViewController: fullMultipleVC)
        navC.modalPresentationStyle = .fullScreen
        navC.setNavigationBarHidden(true, animated: false)
        present(navC, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch items[indexPath.item].cellType {
        case .muliple:
            showDailyAppFullScreen(indexPath)
        default:
            showSingleAppFullScreen(indexPath)
        }
    }
    
    fileprivate func setupSingleAppFullScreenController(_ indexPath: IndexPath){
        let appFullscreenVC = AppFullscreenController()
        appFullscreenVC.todayItem = items[indexPath.item]
        appFullscreenVC.dismissHandler = {
            self.handleAppFullScreenDismissall()
        }
        appFullscreenVC.view.layer.cornerRadius = 16
        self.appFullscreenVC = appFullscreenVC
        
        //#1 setup our pan gesture
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        gesture.delegate = self /// used to handle gesture to scroll in table view
        appFullscreenVC.view.addGestureRecognizer(gesture)
        
        //#2 add blure affect view
        
        //#3 not to interface with our UITabelView Scrolling
    }
    
    @objc fileprivate func handleDrag(gesture: UIPanGestureRecognizer) {
        if appFullscreenVC.tableView.contentOffset.y > 0 {
            return
        }
        if gesture.state == .began {
            appFullscreenBeginOffset = appFullscreenVC.tableView.contentOffset.y
        }
        let transilationY = gesture.translation(in: appFullscreenVC.view).y
        
        if gesture.state == .changed {
            if transilationY > 0 {
                let trueOffset = transilationY - appFullscreenBeginOffset
                var scale = 1 - trueOffset / 1000
                scale = min(1, scale)
                scale = max(0.5, scale)
                print("transilationY = \(transilationY) , scale = \(scale)")
                let tranform: CGAffineTransform = .init(scaleX: scale, y: scale)
                appFullscreenVC.view.transform = tranform
            }
        } else if gesture.state == .ended {
            if transilationY > 0 {
                self.handleAppFullScreenDismissall()
            }
        }
        
    }
    
    fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        // absolute coordinate for cell
        guard let startFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startFrame
    }
    
    
    fileprivate func setupSingleAppFullScreenStartingPosition(_ indexPath: IndexPath) {
        let appFullscreenView = appFullscreenVC.view!
        view.addSubview(appFullscreenView)
        addChild(appFullscreenVC)
        self.collectionView.isUserInteractionEnabled = false
        
        setupStartingCellFrame(indexPath)
        
        guard let startingFrame = startingFrame else { return }
        
        self.anchoredConstaints = appFullscreenView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0),
            size: .init(width: startingFrame.width, height: startingFrame.height)
        )
        
        self.view.layoutIfNeeded() // starts animation
    }
    
    fileprivate func beginAnimationAppFullScreen(){
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            self.blurVisualEffectView.alpha = 1
            
            if let anchoredConstaints = self.anchoredConstaints {
                anchoredConstaints.top?.constant = 0
                anchoredConstaints.leading?.constant = 0
                anchoredConstaints.width?.constant = self.view.frame.width
                anchoredConstaints.height?.constant = self.view.frame.height
            }
            

            self.view.layoutIfNeeded() // starts animation
            self.beginAnimationTabBar()
            
             guard let headerCell = self.appFullscreenVC.tableView.cellForRow(at: [0,0]) as? AppFullscreenHeaderCell else { return }
            headerCell.todayCell.topConstraint.constant = 48
            headerCell.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func showSingleAppFullScreen(_ indexPath: IndexPath) {
        /// #1
        setupSingleAppFullScreenController(indexPath)
        /// #2 setup full screen in it starting position
        setupSingleAppFullScreenStartingPosition(indexPath)
        /// #3 begin the full screen animation
        beginAnimationAppFullScreen()
    }

    @objc func handleAppFullScreenDismissall() {
        // access startingFrame
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.7,
            options: .curveEaseOut,
            animations: {
            
            self.blurVisualEffectView.alpha = 0
            self.appFullscreenVC.view.transform = .identity

            guard let startFrame = self.startingFrame else { return }
            self.anchoredConstaints?.top?.constant = startFrame.origin.y
            self.anchoredConstaints?.leading?.constant = startFrame.origin.x
            self.anchoredConstaints?.width?.constant = startFrame.width
            self.anchoredConstaints?.height?.constant = startFrame.height
            self.view.layoutIfNeeded() // starts animation
            self.appFullscreenVC.tableView.contentOffset = .zero

            self.backAnimationTabBarToIdentity()
            
            guard let headerCell = self.appFullscreenVC.tableView.cellForRow(at: [0,0]) as? AppFullscreenHeaderCell else { return }
                      headerCell.todayCell.topConstraint.constant = 24
                      self.appFullscreenVC.closeBtn.alpha = 0
                      self.appFullscreenVC.floatingContainerView.alpha = 0
                      headerCell.layoutIfNeeded()
        }, completion: { _ in
            self.appFullscreenVC.view?.removeFromSuperview()
            self.appFullscreenVC.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    fileprivate func beginAnimationTabBar() {
        // self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
        self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
    }
    
    @objc func backAnimationTabBarToIdentity() {
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
        
        (cell as? TodayMultipleCell)?.multipleAppVC.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        
        return cell
    }
    
    @objc fileprivate func handleMultipleAppsTap(gesture: UIGestureRecognizer) {
        let collectionView = gesture.view
        // figure out which cell were clicking into
        var superview = collectionView?.superview
        while superview != nil {
            if let cell = superview as? TodayMultipleCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                let feedResults = self.items[indexPath.item].feedResults
                
                let fullController = TodayMultipleAppsController(mode: .fullscreen)
                fullController.feedResults = feedResults
                let navC = BackEnabledNavigationController(rootViewController: fullController)
                navC.setNavigationBarHidden(true, animated: false)
                navC.modalPresentationStyle = .fullScreen
                present(navC, animated: true)
                return
            }
            superview = superview?.superview
        }
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

// MARK: - Handle Gesture Recongnizer
extension TodayController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}





///  to preview desing form SwiftUI
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct TodayController_Preview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        func makeUIViewController(context:UIViewControllerRepresentableContext<TodayController_Preview.ContainerView>) -> UIViewController {
            return TodayController()
        }
        
        func updateUIViewController(_ uiViewController: TodayController_Preview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<TodayController_Preview.ContainerView>) {
        }
    }
}

#endif
