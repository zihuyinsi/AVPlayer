//
//  AVTableViewCell.swift
//  AVPlayer
//
//  Created by lv on 2017/12/12.
//  Copyright © 2017年 Tsou. All rights reserved.
//

import Foundation
import UIKit

class AVTableViewCell: UITableViewCell {
    
    /*** 头像 */
    lazy var logo: UIImageView = {
        let tempLogo = UIImageView()
        return tempLogo
    }()
    
    /*** 昵称 */
    lazy var nameLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.font = UIFont.systemFont(ofSize: 15.0)
        tempLabel.textAlignment = NSTextAlignment.left
        tempLabel.textColor = k_TitColor
        return tempLabel
    }()
    
    /*** 等级、👑等 */
    lazy var levelImgView: UIImageView = {
        let tempImg = UIImageView()
        tempImg.isHidden = true
        return tempImg
    }()
    
    /*** 时间 */
    lazy var timeLabel : UILabel = {
       let tempLabel = UILabel()
        tempLabel.font = UIFont.systemFont(ofSize: 12.0)
        tempLabel.textAlignment = NSTextAlignment.left
        tempLabel.textColor = k_SubTitColor
        return tempLabel
    }()
    
    /*** 发布方式（来自xxx） */
    lazy var fromLabel: UILabel = {
       let tempLabel = UILabel()
        tempLabel.font = UIFont.systemFont(ofSize: 13.0)
        tempLabel.textAlignment = NSTextAlignment.left
        tempLabel.textColor = k_SubTitColor
        return tempLabel
    }()
    
    /*** 文本内容 */
    lazy var contentLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.font = UIFont.systemFont(ofSize: 13.0)
        tempLabel.textAlignment = NSTextAlignment.left
        tempLabel.textColor = k_TitColor
        tempLabel.numberOfLines = 0
        return tempLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //头像
        self.addSubview(self.logo)
        self.logo.snp.makeConstraints { (make) in
            make.left.equalTo(15.0)
            make.top.equalTo(15.0)
            make.width.equalTo(45.0)
            make.height.equalTo(45.0)
        }
        self.logo.layer.masksToBounds = true
        self.logo.layer.cornerRadius = 22.5
        self.logo.contentMode = UIViewContentMode.scaleAspectFill
        
        //昵称
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.logo.snp.right).offset(10.0)
            make.top.equalTo(self.logo.snp.top).offset(0)
            make.height.equalTo(20.0)
        }
        
        //等级、👑
        self.addSubview(self.levelImgView)
        self.levelImgView.snp.makeConstraints { (make) in
            make.left.equalTo(self.nameLabel.snp.right).offset(5)
            make.top.equalTo(self.logo.snp.top).offset(0)
            make.width.equalTo(0)
            make.height.equalTo(20.0)
            make.right.greaterThanOrEqualTo(-15)
        }
        
        //发布时间
        self.addSubview(self.timeLabel)
        self.timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.logo.snp.right).offset(10.0)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(5)
            make.height.equalTo(20.0)
            make.width.lessThanOrEqualTo(100.0)
        }
        
        //发布方式、途径
        self.addSubview(self.fromLabel)
        self.fromLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.timeLabel.snp.top).offset(0)
            make.left.equalTo(self.timeLabel.snp.right).offset(5)
            make.height.equalTo(20.0)
        }
        
        //内容
        self.addSubview(self.contentLabel)
        self.contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.logo.snp.bottom).offset(10.0)
            make.left.equalTo(15.0)
            make.right.equalTo(-15.0)
            make.height.greaterThanOrEqualTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
