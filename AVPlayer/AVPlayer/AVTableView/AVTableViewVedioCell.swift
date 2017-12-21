//
//  AVTableViewVedioCell.swift
//  AVPlayer
//
//  Created by lv on 2017/12/12.
//  Copyright © 2017年 Tsou. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class AVTableViewVedioCell: AVTableViewCell {
    
    var avInfo: NSMutableDictionary? {
        willSet{
            print("准备设置avInfo")
        }
        didSet{
            print("avInfo设置完成")
            
            self.logo.sd_setImage(with: URL.init(string: "http://pic9.nipic.com/20100816/3320946_110714083363_2.jpg"), placeholderImage: UIImage.init(named: "dot"), options: SDWebImageOptions.progressiveDownload, completed: nil)
            self.nameLabel.text = "AVPlayer"
            self.timeLabel.text = "12-12 13:08"
            self.fromLabel.text = "来自iPhone X"
            self.contentLabel.text = "什么是极限运动？极限运动是在征得业主同意、不违背有关法律，遵守一定规则并获得相应保护的，挑战自我胜利、意志极限的运动，比如超长马拉松，超级铁人三项，又比如北美街头颇为流行的花样单板、花样小轮车、花样滑雪、生存挑战、风筝冲浪、跑酷、高空蹦极、水肺潜水、悬挂滑翔……这些都叫极限运动，任何一种真正得到公认的极限运动，都会在或长或短的“草根”阶段竭力“正规化”，并在“正规化”后摸索各种有效的行为规范和人身保护措施。号称“极限运动最普及的国家”美国，恰是极限运动规则最严密的国家。如今大多数极限运动都有严密的组织和严格的规范，有些甚至已跻身奥运表演或正式项目行列。"
        }
    }
    
    lazy var avPlayView: AVVedioView = {
        let tempView = AVVedioView.init(frame: CGRect.zero)
        tempView.backgroundColor = UIColor.black
        return tempView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(self.avPlayView)
        self.avPlayView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(10)
            make.left.equalTo(15.0)
            make.right.equalTo(-15.0)
            make.height.equalTo((k_ScreenWidth-30)/2)
            make.bottom.equalTo(-15.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
