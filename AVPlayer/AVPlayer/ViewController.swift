
import UIKit
class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //let Vc = AVPlayerVC.init()
        //let Vc = WkWebViewVC.init()
        let Vc = MyAVPlayerViewController.init()
        self.navigationController?.pushViewController(Vc, animated: true)
    }
    
    
    

   
}

