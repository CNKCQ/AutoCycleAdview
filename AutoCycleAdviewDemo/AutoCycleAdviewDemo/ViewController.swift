//
//  Copyright © 2016年 Jack. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    var sycleScroll: SycleAdContainer!
    var showImage: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        sycleScroll = SycleAdContainer(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 180))
        sycleScroll.backgroundColor = .lightGrayColor()
        let imageUrls = ["http://ww3.sinaimg.cn/large/610dc034jw1f4saelbb4oj20zk0qoage.jpg", "http://ww1.sinaimg.cn/mw690/692a6bbcgw1f4fz7s830fj20gg0o00y5.jpg", "http://ww1.sinaimg.cn/mw690/692a6bbcgw1f4fz6g6wppj20ms0xp13n.jpg", "http://ww3.sinaimg.cn/mw690/81309c56jw1f4sx4ybttdj20ku0vd0ym.jpg", "http://ww4.sinaimg.cn/mw690/9844520fjw1f4fqribdg1j21911w0kjn.jpg"]
        let adDescs = ["girl 1", "girl 2", "girl 3", "girl 4", "girl 5"]
        showImage = UIImageView(frame: CGRect(x: 0, y: sycleScroll.frame.maxY + 10, width: view.frame.width, height: view.frame.height))
        showImage?.contentMode = .ScaleAspectFill
        showImage?.clipsToBounds = true
        view.addSubview(showImage!)
        
        sycleScroll.configAd(imageUrls, descs: adDescs, style: .Right) { (idx) in
            print(idx)
            print(imageUrls[idx])
            self.showImage!.kf_setImageWithURL(NSURL(string: imageUrls[idx])!)
        }
        
        edgesForExtendedLayout = .None
        view.addSubview(sycleScroll)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}
