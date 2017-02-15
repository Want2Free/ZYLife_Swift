//
//  PM_ItemCell.swift
//  ZYLife_Swift
//
//  Created by Jason on 17/1/16.
//  Copyright © 2017年 Jason. All rights reserved.

//  条目cell

import UIKit
import SDWebImage

class PM_ItemCell: UITableViewCell {

    //默认高度
    static let rowHeight = 237
    
    /* 不需要显示出手是需要隐藏 */
    //出手view
    @IBOutlet weak var showBaseView: UIView!
    //出手分隔线
    @IBOutlet weak var showSepaLine: UIView!
    
    
    //倒计时view（非进行中时需要隐藏）
    @IBOutlet weak var overTimeBaseView: UIView!
    @IBOutlet weak var hourBtn: UIButton!
    @IBOutlet weak var minuteBtn: UIButton!
    @IBOutlet weak var SecondBtn: UIButton!
    
    
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var itemMaskImgView: UIImageView!
    @IBOutlet weak var itemNameLab: UILabel!
    @IBOutlet weak var startPriceLab: UILabel!
    @IBOutlet weak var currentPriceLab: UILabel!
    @IBOutlet weak var myTopImg: UIImageView!
    //出手次数
    @IBOutlet weak var showTimesLab: UILabel!
    @IBOutlet weak var zanTimesBtn: UIButton!
    @IBOutlet weak var caiTimesBtn: UIButton!
    
    //出手语
    @IBOutlet weak var showMsgField: UITextField!
    
    //选中的出手价格按钮
    var selectedPriceBtn: UIButton?
    //模型数据
    var pmItem: PM_ItemModel? {
        didSet {
            self.setUI()
        }
    }
    
    func setUI() {
        
        if self.pmItem != nil {
            let file = self.pmItem?.files?.first
            itemImgView.sd_setImage(with: URL.init(string: (file?.thumbnailUrl)!), placeholderImage: UIImage(named: "paim_img_wupin"))
            itemNameLab.text = self.pmItem?.lotName
            startPriceLab.text = "￥\(self.pmItem?.startPrice)"
            currentPriceLab.text = "￥\(self.pmItem?.finalPrice)"
            zanTimesBtn.setTitle("\(self.pmItem?.goods)", for: .normal)
            caiTimesBtn.setTitle("\(self.pmItem?.bads)", for: .normal)
        }
    }
    
    //出手操作
    @IBAction func showAction() {
    }
    
    @IBAction func selectPriceAction(_ sender: UIButton) {
        
        if self.selectedPriceBtn != nil {
            self.selectedPriceBtn?.isSelected = false
        }
        
        self.selectedPriceBtn = sender
        sender.isSelected = true
    }

}
