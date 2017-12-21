//
//  AVTableController.swift
//  AVPlayer
//
//  Created by lv on 2017/12/12.
//  Copyright © 2017年 Tsou. All rights reserved.
//

import Foundation
import UIKit

class AVTableController: UIViewController {
    
    lazy var avTView: AVTableView = {
        let avTempView = AVTableView.init(frame: CGRect.zero)
        avTempView.backgroundColor = k_Color(r: 245, g: 245, b: 245, a: 1)
        return avTempView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = k_Color(r: 245, g: 23, b: 12, a: 1)
        self.title = "av"
        
        self.view.addSubview(self.avTView)
        self.avTView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
