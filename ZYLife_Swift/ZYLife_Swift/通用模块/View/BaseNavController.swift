//
//  BaseNavController.swift
//  ZYLife_Swift
//
//  Created by Jason on 16/12/28.
//  Copyright © 2016年 Jason. All rights reserved.
//

import UIKit

class BaseNavController: UINavigationController,UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.setNavigationBarHidden(viewController.isKind(of: ClearNavController.classForCoder()), animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
