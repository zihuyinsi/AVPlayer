//
//  AVTableView.swift
//  AVPlayer
//
//  Created by lv on 2017/12/12.
//  Copyright © 2017年 Tsou. All rights reserved.
//

import Foundation
import UIKit

class AVTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initializationAVTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*** tableView */
    var avTable: UITableView?
    var avArrs: NSMutableArray = {
        let tempArr = NSMutableArray()
        return tempArr
    }()
    
    
    /**
     *  初始
     */
    func initializationAVTableView(){
        //av数组
        self.avArrs.addObjects(from: NSArray.init(objects: "1", "2", "3", "4", "5", "6", "7", "8", "9") as! [Any])
        
        //avTable
        avTable = UITableView.init()
        avTable?.backgroundColor = UIColor.white
        avTable?.delegate = self as UITableViewDelegate
        avTable?.dataSource = self as UITableViewDataSource
        avTable?.separatorStyle = UITableViewCellSeparatorStyle.none
        avTable?.rowHeight = UITableViewAutomaticDimension
        avTable?.estimatedRowHeight = 100.0
        self.addSubview(avTable!)
        avTable?.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        })
        
        //注册cell
        avTable?.register(AVTableViewVedioCell.self, forCellReuseIdentifier: "AVVedioCell")
        avTable?.register(AVTableViewGifCell.self, forCellReuseIdentifier: "AVGifCell")
    }

    //MARK: - UITableViewDelegate / UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.avArrs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row%2 == 1 {
            let avVedioCell = tableView.dequeueReusableCell(withIdentifier: "AVVedioCell") as! AVTableViewVedioCell
            avVedioCell.selectionStyle = UITableViewCellSelectionStyle.none
            avVedioCell.backgroundColor = UIColor.white
            
            avVedioCell.avInfo = NSMutableDictionary.init()
            
            return avVedioCell
        }
        else
        {
            let avGifCell = tableView.dequeueReusableCell(withIdentifier: "AVGifCell") as! AVTableViewGifCell
            avGifCell.selectionStyle = UITableViewCellSelectionStyle.none
            avGifCell.backgroundColor = UIColor.white
            
            avGifCell.avInfo = NSMutableDictionary.init()
            
            return avGifCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
