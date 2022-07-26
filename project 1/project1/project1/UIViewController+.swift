//
//  UIViewController+.swift
//  project1
//
//  Created by mmslab406-mini2018-2 on 2022/7/13.
//

import UIKit

extension UIViewController {
    
    func removePresented() {
        guard let presented = self.presentedViewController else { return }
        presented.dialogDismiss()
    }
    
    func dialogDismiss() {
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        self.view.window?.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: true, completion: nil)
    }
    
}
