//
//  BaseAutoHideNavigationVC.swift
//  Roommate
//
//  Created by TrinhHC on 12/5/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit

class BaseAutoHideNavigationVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: UIScrollviewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        let offset = scrollView.contentOffset.y
        if offset  > 50.0{
            UIView.animate(withDuration: 1.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
//                print("Hide")
            }, completion: nil)
        }else{
            
            UIView.animate(withDuration: 1.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
//                print("Unhide")
            }, completion: nil)
        }
    }

}
