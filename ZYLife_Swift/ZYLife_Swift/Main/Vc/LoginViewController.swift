//
//  LoginViewController.swift
//  ZYLife_Swift
//
//  Created by Jason on 16/12/14.
//  Copyright © 2016年 Jason. All rights reserved.

//  登录

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    
    // MARK: - Life
    override func viewDidLoad() {
        super.viewDidLoad()

        //设置占位符颜色
        self.phoneField.setValue(UIColor.hexColor(hexStr: "999999"), forKeyPath: "_placeholderLabel.textColor")
        self.pwdField.setValue(UIColor.hexColor(hexStr: "999999"), forKeyPath: "_placeholderLabel.textColor")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Target Actions
    @IBAction func loginAction() {
        //check
        let phone = self.phoneField.text?.removeWhiteSpace()
        let pwd = self.pwdField.text?.removeWhiteSpace()
        
        if phone?.lengthOfBytes(using: String.Encoding.utf8) != 11 {
            Common.showAlert(msg: "请输入正确的手机号码")
            return
        }
        if pwd?.lengthOfBytes(using: String.Encoding.utf8) == 0 {
            Common.showAlert(msg: "请输入密码")
            return
        }
        
        //call
        Main_Service.sharedInstance.login(phone: phone!, password: pwd!, success: { (obj) in
            //to main
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.toMainPage(fromVc: self)
            
            }) { (str) in
                
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier! == "toModify"{
            let nvc = segue.destination as! UINavigationController
            let vc = nvc.topViewController as! RegisterViewController
            //忘记密码
            vc.type = .Modify
        }
    }
    
}
