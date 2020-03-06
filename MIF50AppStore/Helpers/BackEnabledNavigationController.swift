//
//  BackEnabledNavigationController.swift
//  MIF50AppStore
//
//  Created by BeInMedia on 3/4/20.
//  Copyright © 2020 MIF50. All rights reserved.
//

import UIKit

class BackEnabledNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")

        self.interactivePopGestureRecognizer?.delegate = self
        

    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("viewControllers count =   \(self.viewControllers.count)")
        return self.viewControllers.count > 1
    }
    
}
