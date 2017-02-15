//
//  SideViewController.swift
//  ZYLife_Swift
//
//  Created by Jason on 16/12/24.
//  Copyright © 2016年 Jason. All rights reserved.

//  侧边栏

import UIKit

class SideViewController: UITableViewController {

    // MARK: - Property
    @IBOutlet weak var headImgWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var labWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var headImaView: UIImageView!
    @IBOutlet weak var nameLab: UILabel!
    
    // MARK: - Life
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initTableview()
        
        //load userInfo
        self.loadUserInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Private
    
    func loadUserInfo() {
        
        if ShareData.sharedInstance.userInfo == nil {
            
            Main_Service.sharedInstance.getUserInfo(success: { (userInfo) in
                self.headImaView.sd_setImage(with: NSURL.init(string: (ShareData.sharedInstance.userInfo?.picture)!) as URL!, placeholderImage: nil)
                self.nameLab.text = ShareData.sharedInstance.userInfo?.userName
            }) { (str) in
                
            }
        } else {
            self.headImaView.sd_setImage(with: NSURL.init(string: (ShareData.sharedInstance.userInfo?.picture)!) as URL!, placeholderImage: nil)
            self.nameLab.text = ShareData.sharedInstance.userInfo?.userName
        }
    }
    
    func initTableview() {
        //下半部分背景
        let imgView = UIImageView.init(frame: self.view.bounds)
        imgView.image = UIImage(named: "cebian_bg_xia")
        self.tableView.backgroundView = imgView
        
        //分隔线
        self.tableView.separatorColor = UIColor.darkGray
        
        self.headImgWidthConstraint.constant = kWidth-65*(kWidth/320)
        self.labWidthConstraint.constant = kWidth-65*(kWidth/320)
        
        //头像圆角
        self.headImaView.layer.cornerRadius = self.headImaView.bounds.size.width/2.0
        self.headImaView.layer.masksToBounds = true
        self.headImaView.layer.borderColor = UIColor.white.cgColor
        self.headImaView.layer.borderWidth = 2.0
    }
    
    // MARK: - Table view data source


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
