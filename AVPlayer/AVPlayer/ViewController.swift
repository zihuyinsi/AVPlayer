//
//  ViewController.swift
//  AVPlayer
//
//  Created by apple on 2017/12/5.
//  Copyright © 2017年 Tsou. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class ViewController: UIViewController {

    /*** 播放器 */
    var avPlayer: AVPlayer?
    var avPlayerItem: AVPlayerItem?
    var avPlayerLayer: AVPlayerLayer?
    
    /*** 是否全屏 */
    var isFullScreen: Bool?
    /*** 自动隐藏定时器 */
    var autoDismissTimer: Timer?
    /*** 是否在拖拽中 */
    var isDragSlider: Bool?
    
    /*** 背景 */
    lazy var backView: UIView = {
        let tempView = UIView()
        tempView.frame = CGRect.init(x: 0, y: 0, width: k_ScreenWidth, height: k_ScreenWidth/2)
        tempView.backgroundColor = UIColor.black
        return tempView
    }()

    /*** 底部操控区 */
    lazy var bottomView: UIView = {
        let tempView = UIView()
        tempView.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        return tempView
    }()
    
    /*** 播放/暂停 按钮 */
    lazy var playBtn: UIButton = {
        let tempBtn = UIButton()
        tempBtn.setImage(UIImage.init(named: "play"), for: UIControlState.normal)
        tempBtn.showsTouchWhenHighlighted = true
        tempBtn.addTarget(self, action: #selector(handlePalyButtonClick), for: UIControlEvents.touchUpInside)
        return tempBtn
    }()
    
    /*** 全屏/退出全屏 按钮 */
    lazy var fullScreenBtn: UIButton = {
        let tempBtn = UIButton()
        tempBtn.setImage(UIImage.init(named: "fullScreen"), for: UIControlState.normal)
        tempBtn.showsTouchWhenHighlighted = true
        tempBtn.addTarget(self, action: #selector(handleFullScreenButtonClick), for: UIControlEvents.touchUpInside)
        return tempBtn
    }()
    
    /*** 缓存进度条 */
    lazy var progressView: UIProgressView = {
        let tempProgressView = UIProgressView()
        tempProgressView.progressTintColor = UIColor.blue
        tempProgressView.trackTintColor = UIColor.lightGray
        tempProgressView.setProgress(0.0, animated: false)
        return tempProgressView
    }()
    
    /*** 进度条 */
    lazy var slider: UISlider = {
        let tempSlider = UISlider()
        tempSlider.minimumValue = 0.0
        tempSlider.minimumTrackTintColor = UIColor.green
        tempSlider.maximumTrackTintColor = UIColor.clear
        tempSlider.value = 0.0
        tempSlider.setThumbImage(UIImage.init(named: "dot"), for: UIControlState.normal)
        tempSlider.addTarget(self, action: #selector(handleSliderDragValueChange(slider:)), for: UIControlEvents.valueChanged)
        tempSlider.addTarget(self, action: #selector(handleSliderTapValueChange(slider:)), for: UIControlEvents.touchUpInside)
        return tempSlider
    }()
    
    /*** 左侧时间轴 */
    lazy var leftTimeAxis: UILabel = {
        let tempAxis = UILabel()
        tempAxis.textColor = UIColor.white
        tempAxis.font = UIFont.systemFont(ofSize: 13.0)
        tempAxis.textAlignment = NSTextAlignment.left
        return tempAxis
    }()
    
    /*** 右侧时间轴 */
    lazy var rightTimeAxis: UILabel = {
        let tempAxis = UILabel()
        tempAxis.textColor = UIColor.white
        tempAxis.font = UIFont.systemFont(ofSize: 13.0)
        tempAxis.textAlignment = NSTextAlignment.right
        return tempAxis
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.isFullScreen = false
        self.isDragSlider = false
        
        //初始化UI
        self.initializationUI()
        
        //播放器
        let urlStr = URL.init(string: "http://flv2.bn.netease.com/videolib3/1608/30/zPuaL7429/SD/zPuaL7429-mobile.mp4")
        avPlayerItem = AVPlayerItem.init(url: urlStr!)
        avPlayer = AVPlayer.init(playerItem: avPlayerItem)
        avPlayerLayer = AVPlayerLayer.init(player: avPlayer)
        avPlayerLayer?.frame = self.backView.frame
        self.backView.layer.insertSublayer(avPlayerLayer!, at: 0)
        
        //设置左右时间轴
        self.updateUI()
        
        //监听播放器状态变化
        avPlayerItem?.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        //监听缓存大小
        avPlayerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        //屏幕旋转监听
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeviceOrientationNotification), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
        
        //添加手势，隐藏下面进度条
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleSliderTap(tap:)))
        self.backView.addGestureRecognizer(tap)
        
        //进度条添加点击手势
        let tapSlider = UITapGestureRecognizer.init(target: self, action: #selector(handleTouchSlider(tap:)))
        self.slider.addGestureRecognizer(tapSlider)
    }

    /**
     *  初始化UI
     *  initializationUI
     */
    fileprivate func initializationUI() {
        //背景
        self.view.addSubview(self.backView)

        //底部操作区
        self.backView.addSubview(self.bottomView)
        self.bottomView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(50)
        }
        
        //播放/暂停
        self.bottomView.addSubview(self.playBtn)
        self.playBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15.0)
            make.centerY.equalTo(self.bottomView)
            make.size.equalTo(CGSize.init(width: 18, height: 20))
        }
        
        //全屏/退出全屏
        self.bottomView.addSubview(self.fullScreenBtn)
        self.fullScreenBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15.0)
            make.centerY.equalTo(self.bottomView)
            make.size.equalTo(CGSize.init(width: 15, height: 15))
        }
        
        //缓存进度条
        self.bottomView.addSubview(self.progressView)
        
        //进度条
        self.bottomView.addSubview(self.slider)
        self.slider.snp.makeConstraints { (make) in
            make.left.equalTo(45.0)
            make.right.equalTo(-45.0)
            make.centerY.equalTo(self.bottomView)
        }

        self.progressView.snp.makeConstraints { (make) in
            make.left.equalTo(self.slider)
            make.right.equalTo(self.slider)
            make.height.equalTo(2)
            make.centerY.equalTo(self.slider).offset(0)
        }
        
        //左侧时间轴
        self.bottomView.addSubview(self.leftTimeAxis)
        self.leftTimeAxis.snp.makeConstraints { (make) in
            make.left.equalTo(self.slider)
            make.top.equalTo(self.slider.snp.bottom).offset(0)
            make.size.equalTo(CGSize.init(width: 100, height: 20))
        }
        
        //右侧时间轴
        self.bottomView.addSubview(self.rightTimeAxis)
        self.rightTimeAxis.snp.makeConstraints { (make) in
            make.right.equalTo(self.slider)
            make.top.equalTo(self.slider.snp.bottom).offset(0)
            make.size.equalTo(CGSize.init(width: 100, height: 20))
        }
    }
    
    //MARK: 播放/暂停K
    /**
     *  播放/暂停 按钮点击事件处理
     *  handlePalyButtonClick
     */
    @objc func handlePalyButtonClick() {
        if self.avPlayer?.rate != 1 {
            self.playBtn.setImage(UIImage.init(named: "pause"), for: UIControlState.normal)
            self.avPlayer?.play()
        }
        else
        {
            self.playBtn.setImage(UIImage.init(named: "play"), for: UIControlState.normal)
            self.avPlayer?.pause()
        }
    }
    
    //MARK: 全屏/退出全屏
    /**
     *  全屏/退出全屏 按钮点击事件处理
     *  handleFullScreenButtonClick
     */
    @objc func handleFullScreenButtonClick() {
        if !(self.isFullScreen!) {
            self.handleScreenLandscapeLeft(isBtnClick: true)
        }
        else
        {
            self.handleScreenPortrait(isBtnClick: true)
        }
        self.isFullScreen = !(self.isFullScreen!)
    }
    
    //MARK: - slider更改
    /**
     *  不更新视频进度
     *  handleSliderDragValueChange(slider:)
     */
    @objc func handleSliderDragValueChange(slider: UISlider){
        self.isDragSlider = true
    }
    
    /**
     *  点击或者拖拽完毕时 调用，更新视频进度
     *  handleSliderTapValueChange(slider:)
     */
    @objc func handleSliderTapValueChange(slider: UISlider){
        self.isDragSlider = false
        self.avPlayer?.seek(to: CMTime.init(seconds: Double(slider.value), preferredTimescale: (self.avPlayerItem?.currentTime().timescale)!))
    }
    
    //MARK: - 单击手势
    /**
     *  点击进度条
     *  handleTouchSlider(tap:)
     */
    @objc func handleTouchSlider(tap: UITapGestureRecognizer){
        let touch:CGPoint = tap.location(in: self.slider)
        let scale:CGFloat = touch.x / self.slider.bounds.size.width
        self.slider.value = Float(CGFloat(CMTimeGetSeconds((self.avPlayerItem?.duration)!)) * scale)
        self.avPlayer?.seek(to: CMTime.init(seconds: Double(self.slider.value), preferredTimescale: (self.avPlayerItem?.currentTime().timescale)!))
        if self.avPlayer?.rate != 1 {
            self.playBtn.setImage(UIImage.init(named: "pause"), for: UIControlState.normal)
            self.avPlayer?.play()
        }
    }
    
    /**
     *  单击手势 - 是否隐藏底部操作区
     *  handleSliderTap(tap:)
     */
    @objc func handleSliderTap(tap:UITapGestureRecognizer){
        UIView.animate(withDuration: 1.0) {
            if (self.bottomView.alpha == 1.0){
                self.bottomView.alpha = 0.0
            }
            else if (self.bottomView.alpha == 0.0){
                self.bottomView.alpha = 1.0
            }
        }
    }
    
    //MARK: - KVO 监听播放器变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            let status:Int = change![NSKeyValueChangeKey.newKey] as! Int
            if status == AVPlayerItemStatus.readyToPlay.rawValue{
                print("0-readyToPlay")
                let current = CMTimeGetSeconds((self.avPlayerItem?.duration)!);
                self.slider.maximumValue = Float(current)
                self.updateUI()
                //自动隐藏底部操作区
                if self.autoDismissTimer == nil {
                    self.autoDismissTimer = Timer.init(timeInterval: 10.0, target: self, selector: #selector(autoDismissBottomView(timer:)), userInfo: nil, repeats: true)
                    RunLoop.current.add(self.autoDismissTimer!, forMode: RunLoopMode.defaultRunLoopMode)
                }
            }
        }
        //监听缓冲进度属性
        else if keyPath == "loadedTimeRanges" {
            //计算缓冲进度
            let timeInterval = self.availableDuration()
            //获取总长度
            let durationTime = CMTimeGetSeconds((self.avPlayerItem?.duration)!)
            //进度条赋值
            self.progressView.setProgress(Float(timeInterval/durationTime), animated: false)
        }
    }
    
    //MARK: - 更新UI
    /**
     *  调用player进行UI更新
     */
    func updateUI() {
        weak var weakSelf = self
        
        //每秒更新一次UI Slider
        self.avPlayer?.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: DispatchQueue.main, using: { (time) in
            //当前时间
            let nowTime = CMTimeGetSeconds((weakSelf?.avPlayerItem?.currentTime())!)
            //总时间
            let duration = CMTimeGetSeconds((weakSelf?.avPlayerItem?.duration)!)
            //secondes 转换为 时间点
            weakSelf?.leftTimeAxis.text = self.convertToTime(time: CGFloat(nowTime))
            weakSelf?.rightTimeAxis.text = self.convertToTime(time: CGFloat(duration))
            //不是拖拽中，更新UI
            if !(weakSelf?.isDragSlider)! {
                weakSelf?.slider.value = Float(CMTimeGetSeconds((weakSelf?.avPlayerItem?.currentTime())!))
            }
        })
    }
 
    //MARK: -
    /**
     *  自动隐藏底部操作区
     */
    @objc func autoDismissBottomView(timer: Timer?) {
        if (self.avPlayer?.rate == 1) {
            UIView.animate(withDuration: 1.0, animations: {
                self.bottomView.alpha = 0.0
            })
        }
    }
    
    /**
     *  计算缓冲进度
     */
    func availableDuration() -> TimeInterval {
        let loadedTimeRanges = self.avPlayerItem?.loadedTimeRanges
        //获取缓冲区域
        let timeRange:CMTimeRange = (loadedTimeRanges?.first?.timeRangeValue)!
        //开始的点
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        //已缓存的时间点
        let durationSeconds = CMTimeGetSeconds(timeRange.duration)
        //计算缓冲进度
        let result = TimeInterval.init(startSeconds+durationSeconds)
        return result
    }
    
    //MARK: -
    /**
     *  时间格式化
     */
    func convertToTime(time: CGFloat?) -> String {
        let dateFormatter = DateFormatter()
        //根据是否大于1小时，进行格式赋值
        if time! >= 3600{
            dateFormatter.dateFormat = "HH:mm:ss"
        }
        else
        {
            dateFormatter.dateFormat = "mm:ss"
        }
        //秒数转换成NSDate
        let date:NSDate = NSDate.init(timeIntervalSince1970: TimeInterval.init(time!))
        //date转字符串
        let dateStr:String = dateFormatter.string(from: date as Date)
        return dateStr
    }
    
    //MARK: - 监听屏幕旋转 / 全屏、退出全屏
    /**
     *  屏幕旋转
     */
    @objc func handleDeviceOrientationNotification() {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case .portrait:
            print("正常")
            self.handleScreenPortrait(isBtnClick: false)
            break
        case .portraitUpsideDown:
            print("倒立")
            break
        case .landscapeLeft:
            print("左旋转")
            self.handleScreenLandscapeLeft(isBtnClick: false)
            break
        case .landscapeRight:
            print("右旋转")
            self.handleScreenLandscapeLeft(isBtnClick: false)
            break
        default:
            break
        }
    }
    
    /*** 屏幕正常 处理 */
    func handleScreenPortrait(isBtnClick: Bool) {
        //先移除
        self.backView.removeFromSuperview()
        //退出全屏
        self.fullScreenBtn.setImage(UIImage.init(named: "fullScreen"), for: UIControlState.normal)

        if isBtnClick == true {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
        
        weak var weakSelf = self
        UIView.animate(withDuration: 0.5, animations: {
            weakSelf?.backView.transform = CGAffineTransform.identity
            weakSelf?.backView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width/2)
            weakSelf?.avPlayerLayer?.frame = (weakSelf?.backView.frame)!
            weakSelf?.view.addSubview((weakSelf?.backView)!)
            
        }) { (finished) in
            
        }
    }
    /*** 屏幕左旋转/右旋转 处理 */
    func handleScreenLandscapeLeft(isBtnClick: Bool) {
        //先移除
        self.backView.removeFromSuperview()
        //设置为全屏
        self.fullScreenBtn.setImage(UIImage.init(named: "deFullScreen"), for: UIControlState.normal)
        
        //初始
        if isBtnClick == true {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        }
        
        //backView 全屏
        let fullFrame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.backView.frame = fullFrame
        //layer
        self.avPlayerLayer?.frame = fullFrame
        
        //加到window上
        let window = UIApplication.shared.keyWindow
        window?.addSubview(self.backView)
    }
    
    //MARK: - deinit
    deinit {
        avPlayerItem?.removeObserver(self, forKeyPath: "status")
        avPlayerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

