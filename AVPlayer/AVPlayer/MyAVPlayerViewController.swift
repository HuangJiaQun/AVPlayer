
import UIKit
import AVKit
class MyAVPlayerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "AVPlayerViewController"
        
        let player = AVPlayer(url: NSURL(string: urlString)! as URL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        // Do any additional setup after loading the view.
        //添加view播放的模式
        playerViewController.view.frame = CGRect(x: 20, y: 100, width: self.view.bounds.width - 40, height: 200)
        self.addChild(playerViewController)
        //self.addChildViewController(playerViewController)
        self.view.addSubview(playerViewController.view)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
