//
//  RegisterViewController.swift
//  ZYLife_Swift
//
//  Created by Jason on 16/12/17.
//  Copyright © 2016年 Jason. All rights reserved.
//

import UIKit
import SVProgressHUD
import RKDropdownAlert

enum Op_Type: String {
    case Register = "1"
    case Modify = "2"
}

class RegisterViewController: UIViewController {
    //默认注册
    var type: Op_Type = Op_Type.Register
    var num = 30
    
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var verifyCodeField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var getBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    // MARK: - Life
    override func viewDidLoad() {
        super.viewDidLoad()

        if type == .Modify {
            self.navigationItem.title = "忘记密码"
            
            registerBtn.setTitle("确定", for: UIControlState.normal)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private
    func changeNum() {
        
        if num == 0 {
            self.getBtn.isEnabled = true
            self.getBtn.setTitle("获取", for: UIControlState.normal)
            
            //remove notification
            NotificationCenter.default.removeObserver(self)
            TimerTool.sharedInstance.pauseTimer()
            
            num = 30
        }
        
        self.getBtn.setTitle("\(num)s", for: UIControlState.disabled)
        num -= 1
    }

    // MARK: - Target Actions
    @IBAction func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //获取验证码
    @IBAction func getAction(sender: UIButton) {
        let phone = self.phoneField.text?.removeWhiteSpace()
        if phone!.lengthOfBytes(using: String.Encoding.utf8) != 11 {
            RKDropdownAlert.title("提示", message: "请输入正确的手机号")
            return;
        }
        
        //call
        SVProgressHUD.show(withStatus: "加载中...")
        Main_Service.sharedInstance.getVerifyCode(phone: phone!, success: { (code) in
            SVProgressHUD.showSuccess(withStatus: code as! String)
            
            self.getBtn.isEnabled = false
            
            //add notification
            NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.changeNum), name: NSNotification.Name(rawValue: kDaojishiNotification), object: nil)
            
            TimerTool.sharedInstance.startTimer()
            }) { (str) in
                SVProgressHUD.showError(withStatus: str)
        }
    }
    
    //显示、隐藏密码
    @IBAction func checkAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.passwordField.isSecureTextEntry = !self.passwordField.isSecureTextEntry
    }
    
    //查看协议
    @IBAction func showProtocal(sender: AnyObject) {
        
    }
    
    //提交注册/修改密码
    @IBAction func registerAction() {
        //check
        let phone = self.phoneField.text?.removeWhiteSpace()
        if phone!.lengthOfBytes(using: String.Encoding.utf8) != 11 {
            RKDropdownAlert.title("提示", message: "请输入正确的手机号")
            return;
        }
        
        let password = self.passwordField.text?.removeWhiteSpace()
        if password!.lengthOfBytes(using: String.Encoding.utf8) == 0 {
            Common.showAlert(msg: "请输入密码")
            return;
        }
        
        let code = self.verifyCodeField.text?.removeWhiteSpace()
        if code!.lengthOfBytes(using: String.Encoding.utf8) != 6 {
            Common.showAlert(msg: "请输入正确的验证码")
            return;
        }
        
        if type == .Register {
            
            //call
            Main_Service.sharedInstance.register(phone: phone!, password: password!, code: code!, success: { (dict) in
                //back to login
                self.dismiss(animated: true, completion: nil)
            }) { (str) in
                
            }
        } else {
            //modify
            //call
            Main_Service.sharedInstance.modifyPwd(phone: phone!, password: password!, code: code!, success: { (dict) in
                //back to login
                self.dismiss(animated: true, completion: nil)
            }) { (str) in
                
            }
        }
        
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
