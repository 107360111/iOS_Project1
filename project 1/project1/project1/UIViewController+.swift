//
//  UIViewController+.swift
//  project1
//
//  Created by mmslab406-mini2018-2 on 2022/7/13.
//

import Foundation
import UIKit

extension UIViewController {
    func show_On(VC: UIViewController) {
        self.modalPresentationStyle = .overCurrentContext
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .fade
        VC.view.window?.layer.add(transition, forKey: kCATransition)
        VC.present(self, animated: false)
//        {
//            self.popupView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
//            self.popupView.alpha = 0
//            UIView.animate(withDuration: 0.25) {
//                self.popupView.transform = CGAffineTransform(scaleX: 1, y: 1)
//                self.popupView.alpha = 1
//            }
//        }
    }
}
