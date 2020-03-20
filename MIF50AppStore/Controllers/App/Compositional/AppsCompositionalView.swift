//
//  AppCompositionalView.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 3/13/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import SwiftUI


fileprivate let TAG = "CompositionalController"

class CompositionalController: UICollectionViewController {
    
    fileprivate let topCell = "topCell"
    fileprivate let secondCell = "secondCell"
    fileprivate let headerId = "headerId"
    
    let dispatchGroup = DispatchGroup()

    
    //
    var socialApps = [SocialApp]()
    var gamesGroup : AppGroup?
    var topGrossingGroup : AppGroup?
    var freeAppsGroup: AppGroup?
    
    // var collection view diffable data source
    lazy var diffableDataSource = makeDataSource()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initCollectionView()
        fetchAppDispatchGroup()
        setupDiffableDataSource()
    }

    
   
    
    fileprivate func initView(){
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = .init(title: "fetch Top Free", style: .plain, target: self, action: #selector(handleFetchTopFreeApp))
    }
    
    @objc private func handleFetchTopFreeApp(){
        var snapshot = diffableDataSource.snapshot()
        snapshot.insertSections([.freeApp], afterSection: .topSocial)
        snapshot.appendItems(freeAppsGroup?.feed.results ?? [], toSection: .freeApp)
        diffableDataSource.apply(snapshot)
    }
    
    fileprivate func initCollectionView(){
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: topCell)
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: secondCell)
        collectionView.register(CompostionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        /// handle refresh collection view
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
    }
    
    @objc fileprivate func handleRefresh(){
        var snapshot = diffableDataSource.snapshot()
        snapshot.deleteSections([.freeApp])
        diffableDataSource.apply(snapshot)
        collectionView.refreshControl?.endRefreshing()
    }
    
    
    init() {
     
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
                return CompositionalController.topSection()
            } else {
                return CompositionalController.secondSection()
            }
        }
        super.init(collectionViewLayout: layout)
     }
    
    static func topSection()-> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),heightDimension: .fractionalHeight(1)))
             item.contentInsets.bottom = 16
             item.contentInsets.trailing = 16
             let group = NSCollectionLayoutGroup.horizontal(
                 layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300)),
                 subitems: [item]
             )
             let section = NSCollectionLayoutSection(group: group)
             section.orthogonalScrollingBehavior = .groupPaging
             section.contentInsets.leading = 16
        return section
    }
    
    static func secondSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
        item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: kind, alignment: .topLeading),

        ]
        return section
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK:- CALL SERVER APIS
extension CompositionalController {
    
    func fetchAppDispatchGroup(){
        dispatchGroup.enter()
        Service.share.fetchSocialApp { (res) in
            self.dispatchGroup.leave()
            switch res {
            case .success(let socialApps):
                self.socialApps = socialApps
            case .failure(let error):
                print("\(TAG) fetchSocialApp \(error)")
            }
        }
        
        dispatchGroup.enter()
        Service.share.fetchGames { (res) in
            self.dispatchGroup.leave()
            switch res {
            case .success(let appGroup):
                self.gamesGroup = appGroup
            case .failure(let error):
                print("\(TAG) fetchGames \(error)")
            }
        }
        
        dispatchGroup.enter()
        Service.share.fetchTopGrossing { (res) in
            self.dispatchGroup.leave()
            switch res {
            case .success(let topGrossoing):
                self.topGrossingGroup = topGrossoing
            case .failure(let error):
                print("\(TAG) fetchTopGrossing \(error)")
          }
        }
        
        dispatchGroup.enter()
        Service.share.fetchTopFree { (res) in
            self.dispatchGroup.leave()
            switch res {
            case .success(let topFreeApps):
                self.freeAppsGroup = topFreeApps
            case .failure(let error):
                print("\(TAG) fetchTopFree \(error)")
            }
        }
        
        dispatchGroup.notify(queue: .main) {
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
                        
        }
    }
}

//MARK:- COLLECTION VIEW DIFFABLE DATA SOURCE
extension CompositionalController {
    
    enum AppSection {
        case topSocial
        case grossingApp
        case gamingApp
        case freeApp
    }
    
    private func makeDataSource()-> UICollectionViewDiffableDataSource<AppSection, AnyHashable> {
        return .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewCell? in
            
            if let socialApp = object as? SocialApp {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.topCell, for: indexPath) as! AppsHeaderCell
                
                cell.socialApp = socialApp
                
                return cell
            } else if let appResult = object as? FeedResult {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.secondCell, for: indexPath) as! AppRowCell
                cell.feedResult = appResult
                cell.btnGet.addTarget(self, action: #selector(self.handleGetButton), for: .primaryActionTriggered)
                
                return cell
            }
            
            return nil
            
        }
    }
    
    @objc func handleGetButton(button: UIView){
        var superView = button.superview
        // I want to reached the parent cell of get button
        while superView != nil {
            if let cell = superView as? UICollectionViewCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                guard let objectIClickedOnto = diffableDataSource.itemIdentifier(for: indexPath) else {return}
                var snapshot = diffableDataSource.snapshot()
                snapshot.deleteItems([objectIClickedOnto])
                diffableDataSource.apply(snapshot)
            }
            superView = superView?.superview

        }
    }
    
    
    private func setupDiffableDataSource(){
        
        collectionView.dataSource = diffableDataSource
        // header for second section
        diffableDataSource.supplementaryViewProvider = .some({ (collectionView, kind, indexPath) -> UICollectionReusableView? in
            let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerId, for: indexPath) as! CompostionalHeader
            
            let snapshot = self.diffableDataSource.snapshot()
            let object = self.diffableDataSource.itemIdentifier(for: indexPath)
            let section = snapshot.sectionIdentifier(containingItem: object!)!
            var title : String?
            if section == .grossingApp {
                title = self.topGrossingGroup?.feed.title
            } else if section == .gamingApp {
                title = self.gamesGroup?.feed.title
            } else if section == .freeApp {
                title = self.freeAppsGroup?.feed.title
            }
            
            headerCell.label.text = title
            
            return headerCell
        })
        
        dispatchGroup.notify(queue: .main) {
            // adding data
            var snapshot = self.diffableDataSource.snapshot()
            snapshot.appendSections([.topSocial,.grossingApp,.gamingApp,])
            snapshot.appendItems(self.socialApps ,toSection: .topSocial)
            snapshot.appendItems(self.topGrossingGroup?.feed.results ?? [], toSection: .grossingApp)
            snapshot.appendItems(self.gamesGroup?.feed.results ?? [], toSection: .gamingApp)
//            snapshot.appendItems(self.freeAppsGroup?.feed.results ?? [], toSection: .freeApp)
            
            self.diffableDataSource.apply(snapshot)
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let object = self.diffableDataSource.itemIdentifier(for: indexPath) else { return }
        var appId = ""
        if let socialApp = object as? SocialApp {
            appId = socialApp.id
        } else if let feedResult = object as? FeedResult {
            appId = feedResult.id
        }
                
        let appDetailVC = AppDetailsController(appId: appId)
        navigationController?.pushViewController(appDetailVC, animated: true)
    }
    
}



// MARK:- UICollectionViewDataSource
extension CompositionalController {
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let appId: String
//        if indexPath.section == 0 {
//            appId = socialApps[indexPath.item].id
//        } else if indexPath.section == 1 {
//            appId = gamesGroup?.feed.results[indexPath.item].id ?? ""
//        } else if indexPath.section == 2 {
//            appId = topGrossingGroup?.feed.results[indexPath.item].id ?? ""
//        } else {
//            appId = freeAppsGroup?.feed.results[indexPath.item].id ?? ""
//        }
//        let appDetialVC = AppDetailsController(appId: appId)
//        navigationController?.pushViewController(appDetialVC, animated: true)
//    }
    
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 4
//    }
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return socialApps.count
//        } else if section == 1 {
//            return gamesGroup?.feed.results.count ?? 0
//        } else if section == 2 {
//            return topGrossingGroup?.feed.results.count ?? 0
//        } else {
//            return freeAppsGroup?.feed.results.count ?? 0
//        }
//    }
    
   
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch indexPath.section {
//        case 0:
//            let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: topCell, for: indexPath) as! AppsHeaderCell
//            headerCell.socialApp = socialApps[indexPath.item]
//            return headerCell
//
//        default:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: secondCell, for: indexPath) as! AppRowCell
//            var appGroup:AppGroup?
//            if indexPath.section == 1 {
//                appGroup = gamesGroup
//            } else if indexPath.section == 2 {
//                appGroup = topGrossingGroup
//            } else {
//                appGroup = freeAppsGroup
//            }
//            if let appGroup = appGroup {
//                cell.feedResult = appGroup.feed.results[indexPath.item]
//            }
//            return cell
//        }
//
//    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
           let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CompostionalHeader
           var title: String?
           if indexPath.section == 1 {
               title = gamesGroup?.feed.title
           } else if indexPath.section == 2 {
               title = topGrossingGroup?.feed.title
           } else {
               title = freeAppsGroup?.feed.title
           }
           
           headerView.label.text = title
           return headerView
       }
}


class CompostionalHeader: UICollectionReusableView {
    
    let label = UILabel(text: "Title for Label", font: .boldSystemFont(ofSize: 30))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct AppsView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AppsView>) -> UIViewController {
        let controller = CompositionalController()
        return UINavigationController(rootViewController: controller)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AppsView>) {
        
    }
    
    typealias UIViewControllerType = UIViewController
    
    
}

struct AppCompositionalView_Previews: PreviewProvider {
    static var previews: some View {
        AppsView()
            .edgesIgnoringSafeArea(.all)
    }
}
