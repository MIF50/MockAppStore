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
    
    //
    var socialApps = [SocialApp]()
    var gamesGroup : AppGroup?
    var topGrossingGroup : AppGroup?
    var freeAppsGroup: AppGroup?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initCollectionView()
        fetchAppDispatchGroup()
    }
    
    fileprivate func initView(){
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    fileprivate func initCollectionView(){
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: topCell)
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: secondCell)
        collectionView.register(CompostionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
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

extension CompositionalController {
    
    func fetchAppDispatchGroup(){
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        Service.share.fetchSocialApp { (res) in
            dispatchGroup.leave()
            switch res {
            case .success(let socialApps):
                self.socialApps = socialApps
            case .failure(let error):
                print("\(TAG) fetchSocialApp \(error)")
            }
        }
        
        dispatchGroup.enter()
        Service.share.fetchGames { (res) in
            dispatchGroup.leave()
            switch res {
            case .success(let appGroup):
                self.gamesGroup = appGroup
            case .failure(let error):
                print("\(TAG) fetchGames \(error)")
                
            }
        }
        
        dispatchGroup.enter()
        Service.share.fetchTopGrossing { (res) in
            dispatchGroup.leave()
            switch res {
            case .success(let topGrossoing):
                self.topGrossingGroup = topGrossoing
            case .failure(let error):
                print("\(TAG) fetchTopGrossing \(error)")
          }
        }
        
        dispatchGroup.enter()
        Service.share.fetchTopFree { (res) in
            dispatchGroup.leave()
            switch res {
            case .success(let topFreeApps):
                self.freeAppsGroup = topFreeApps
            case .failure(let error):
                print("\(TAG) fetchTopFree \(error)")
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}



// MARK:- UICollectionViewDataSource
extension CompositionalController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appId: String
        if indexPath.section == 0 {
            appId = socialApps[indexPath.item].id
        } else if indexPath.section == 1 {
            appId = gamesGroup?.feed.results[indexPath.item].id ?? ""
        } else if indexPath.section == 2 {
            appId = topGrossingGroup?.feed.results[indexPath.item].id ?? ""
        } else {
            appId = freeAppsGroup?.feed.results[indexPath.item].id ?? ""
        }
        let appDetialVC = AppDetailsController(appId: appId)
        navigationController?.pushViewController(appDetialVC, animated: true)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return socialApps.count
        } else if section == 1 {
            return gamesGroup?.feed.results.count ?? 0
        } else if section == 2 {
            return topGrossingGroup?.feed.results.count ?? 0
        } else {
            return freeAppsGroup?.feed.results.count ?? 0
        }
    }
    
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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let headerCell = collectionView.dequeueReusableCell(withReuseIdentifier: topCell, for: indexPath) as! AppsHeaderCell
            headerCell.socialApp = socialApps[indexPath.item]
            return headerCell
                    
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: secondCell, for: indexPath) as! AppRowCell
            var appGroup:AppGroup?
            if indexPath.section == 1 {
                appGroup = gamesGroup
            } else if indexPath.section == 2 {
                appGroup = topGrossingGroup
            } else {
                appGroup = freeAppsGroup
            }
            if let appGroup = appGroup {
                cell.feedResult = appGroup.feed.results[indexPath.item]
            }
            return cell
        }
        
    }
}


class CompostionalHeader: UICollectionReusableView {
    
    let label = UILabel(text: "Title for Label", font: .boldSystemFont(ofSize: 25))
    
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
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<AppsView>) {}
    
    typealias UIViewControllerType = UIViewController
    
    
}

struct AppCompositionalView_Previews: PreviewProvider {
    static var previews: some View {
        AppsView()
            .edgesIgnoringSafeArea(.all)
    }
}
