//
//  AVTableViewGifCell.swift
//  AVPlayer
//
//  Created by lv on 2017/12/12.
//  Copyright © 2017年 Tsou. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class AVTableViewGifCell: AVTableViewCell {
    
    var avInfo: NSMutableDictionary? {
        willSet{
            print("准备设置avInfo")
        }
        didSet{
            print("avInfo设置完成")
            
            self.logo.sd_setImage(with: URL.init(string: "http://img1.juimg.com/160923/328041-16092311292531.jpg"), placeholderImage: UIImage.init(named: "dot"), options: SDWebImageOptions.progressiveDownload, completed: nil)
            self.nameLabel.text = "AVGif"
            self.timeLabel.text = "12-13 13:08"
            self.fromLabel.text = "来自iPhone X58"
            self.contentLabel.text = "iOS Apps Apple UI Design Resources include Photoshop, Sketch, and Adobe XD templates, along with comprehensive UI resources that depict the full range of controls, views, and glyphs available to developers using the iOS SDK. These resources help you design apps that match the iOS design language. Icon and glyph production files are preconfigured to automate asset production using Sketch slices or Adobe Generator for Photoshop CC. Color swatches, dynamic type tables, and fonts are also included. For design guidance, see Human Interface Guidelines > iOS."
        }
    }
    
    lazy var avPlayView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor.black
        return tempView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(self.avPlayView)
        self.avPlayView.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentLabel.snp.bottom).offset(10)
            make.left.equalTo(15.0)
            make.width.equalTo((k_ScreenWidth - 30.0 - 5 * 3)/4)
            make.height.equalTo(self.avPlayView.snp.width).multipliedBy(1)
            make.bottom.equalTo(-15.0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
