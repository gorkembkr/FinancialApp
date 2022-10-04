//
//  UIAnimatable.swift
//  dca-calculator
//
//  Created by Gorkem BekAr on 22.11.2021.
//

import Foundation
import MBProgressHUD

protocol UIAnimatable where Self: UIViewController{
    func showLoadingAnimation()
    func hideLoadingAnimation()
}

extension UIAnimatable{
    func showLoadingAnimation(){
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    func hideLoadingAnimation(){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
