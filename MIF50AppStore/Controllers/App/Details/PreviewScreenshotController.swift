//
//  PreviewScreenshotController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 2/21/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class previewScreenshotController: HorizontalSnappingController {
    
    
    fileprivate let screenshotId = "screenshotId"

    
    var app: ResultApp! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        collectionView.register(ScreenshotCell.self, forCellWithReuseIdentifier: screenshotId)
        collectionView.contentInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        
    }
}

// MARK: - UICollectionViewDataSource
extension previewScreenshotController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return app?.screenshotUrls!.count ?? 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: screenshotId, for: indexPath) as! ScreenshotCell
        if let screenshot = app?.screenshotUrls![indexPath.item] {
            cell.screenshotUrl = screenshot
        }
        return cell
        
    }
    
}

// MARK: - Collection View Flow Layout Delegate
extension previewScreenshotController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: 250, height: view.frame.height)
        
    }
    
}






///  to preview desing form SwiftUI
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct previewScreenshotController_Preview : PreviewProvider {
    
    static var previews: some View {
         ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable  {
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<previewScreenshotController_Preview.ContainerView>) -> UIViewController {
            return previewScreenshotController()
        }
        
        func updateUIViewController(_ uiViewController: previewScreenshotController_Preview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<previewScreenshotController_Preview.ContainerView>) {
            
        }
    }
}


#endif
