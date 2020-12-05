
import UIKit
import AVKit
let urlString = "https://preview.qiantucdn.com/58pic/22/94/32/50V58PIC4s8C9dbbUKTsQ_w.mp4?e=1606748847&token=OyzEe_0O8H433pm7zVEjtnSy5dVdfpsIawO2nx3f:y-zVK6x9mHTit8mieBQDkpd4wZM="
class AVPlayerVC: UIViewController {
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var bufferTimeLabel : UILabel?
    

    //播放进度
    lazy var slider : UISlider = { [weak self] in
        let slider  = UISlider(frame: CGRect(x: 20, y: 300 + 30, width:(self?.view.frame.width)! - 40, height: 20))
        slider.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
        return slider
        }()
    
    
    lazy var loadTimeLabel : UILabel = { [weak self] in
        let loadTimeLabel = UILabel(frame: CGRect(x: 20, y: (self?.slider.frame.maxY)!, width: 100, height: 20))
        loadTimeLabel.text = "00:00:00"
        return loadTimeLabel
        }()
    
    lazy var totalTimeLabel : UILabel = { [weak self] in
        let totalTimeLabel =  UILabel(frame: CGRect(x: (self?.slider.frame.maxX)! - 100, y: (self?.slider.frame.maxY)!, width: 100, height: 20))
        totalTimeLabel.text = "00:00:00"
        return totalTimeLabel
        }()
    
    lazy var pasueButton : UIButton = { [weak self] in
        let button = UIButton(frame: CGRect(x: 20, y: 280, width: 60, height: 30))
        button.setTitle("暂停", for: .normal)
        button.setTitle("播放", for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(pauseButtonSelected(sender:)), for: .touchUpInside)
        return button
        }()
    
    //播放
    func play(){
        self.player?.play()
    }
    //暂停
    @objc func pauseButtonSelected(sender:UIButton)  {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.player?.pause()
        }else{
            self.play()
        }
    }
    //播放进度
    @objc func sliderValueChange(sender:UISlider){
        if self.player?.status == .readyToPlay {
            let time = Float64(sender.value) * CMTimeGetSeconds((self.player?.currentItem?.duration)!)
            let seekTime = CMTimeMake(value: Int64(time), timescale: 1)
            self.player?.seek(to: seekTime)
        }
    }
    
    //转时间格式
    func changeTimeFormat(timeInterval:TimeInterval) -> String{
        // transToHourMinSec(time: Int(curTime))
        //        if (TimeInterval.isNaN||TimeInterval.isInfinite）else{
        //            return "--"//或其他默认字符串
        //        }
        
        if timeInterval.isNaN || timeInterval.isInfinite{
            return "--"//或其他默认字符串
        }else{
            return String(format: "%02d:%02d:%02d",(Int(timeInterval) % 3600) / 60, Int(timeInterval) / 3600,Int(timeInterval) % 60)
        }
    }
    
    @objc func playToEndTime(){
        print("播放完成")
    }
    
    //KVO观察
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            switch self.playerItem?.status{
                case .readyToPlay?:
                    self.play()
                case .failed?:
                    print("failed")
                case.unknown?:
                    print("unkonwn")
            case .none:
                print("none")
            @unknown default:
                    print("unkonwn")
            }
        }else if keyPath == "loadedTimeRanges" {
            let loadTimeArray = self.playerItem?.loadedTimeRanges
            let newTimeRange : CMTimeRange = loadTimeArray?.first as! CMTimeRange
            let startSeconds = CMTimeGetSeconds(newTimeRange.start);
            let durationSeconds = CMTimeGetSeconds(newTimeRange.duration);
            let totalBuffer = startSeconds + durationSeconds;//缓冲总长度
            print("当前缓冲时间：%f",totalBuffer)
        }else if keyPath == "playbackBufferEmpty"{
            print("正在缓存视频请稍等")
        }else if keyPath == "playbackLikelyToKeepUp"{
            print("缓存好了继续播放")
            self.player?.play()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //        AVPlayer: 负责控制播放器的播放，暂停等操作
        //        AVAsset:获取多媒体信息的抽象类，不能直接使用
        //        AVURLAsset: AVAsset 的一个子类，使用 URL 进行实例化，实例化对象包换 URL 对应视频资源的所有信息。
        //        AVPlayerItem: 管理媒体资源对象，提供播放数据源
        //        AVPlayerLayer: 负责显示视频，如果没有添加该类，只有声音没有画面
        self.title = "AVPlayer播放视频"
        self.view.addSubview(self.slider)
        self.view.addSubview(self.loadTimeLabel)
        self.view.addSubview(self.totalTimeLabel)
        self.view.addSubview(self.pasueButton)
        //创建媒体资源管理对象
        self.playerItem = AVPlayerItem(url: NSURL(string:urlString)! as URL)
        
        //创建ACplayer：负责视频播放
        self.player = AVPlayer.init(playerItem: self.playerItem)
        self.player?.rate = 1.0//播放速度 播放前设置
        
        //创建显示视频的图层
        let playerlayer = AVPlayerLayer.init(player: self.player)
        playerlayer.videoGravity = .resizeAspect//定义如何在AVPlayerLayer bounds rect中显示视频
        playerlayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 300)
        self.view.layer.addSublayer(playerlayer)
        
        //观察属性
        self.playerItem?.addObserver(self, forKeyPath: "status", options:.new, context: nil)
        self.playerItem?.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        self.playerItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        self.playerItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        
        //播放完成
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        //请求在回放期间调用块以报告更改时间
        self.player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main) { [weak self](time) in
            //当前正在播放的时间
            let loadTime = CMTimeGetSeconds(time)
            //视频总时间
            let totalTime = CMTimeGetSeconds((self?.player?.currentItem?.duration)!)
            //滑块进度
            self?.slider.value = Float(loadTime/totalTime)
            self?.loadTimeLabel.text = self?.changeTimeFormat(timeInterval: loadTime)
            self?.totalTimeLabel.text = self?.changeTimeFormat(timeInterval: CMTimeGetSeconds((self?.player?.currentItem?.duration)!))
        }
        // Do any additional setup after loading the view.
    }
    

    deinit {
        self.player?.pause()
        self.playerItem?.removeObserver(self, forKeyPath: "status", context: nil)
        self.playerItem?.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
        self.playerItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty", context: nil)
        self.playerItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp", context: nil)
        NotificationCenter.default.removeObserver(self)
        
    }

}
