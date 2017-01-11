//
//  Copyright © 2016年 Jack. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    var sycleScroll: SycleAdContainer!
    var showImage: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        sycleScroll = SycleAdContainer(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 180))
//        sycleScroll.backgroundColor = .lightGray
        let imageUrls = [
            "http://ww3.sinaimg.cn/large/610dc034jw1f4saelbb4oj20zk0qoage.jpg",
            "http://ww1.sinaimg.cn/mw690/692a6bbcgw1f4fz7s830fj20gg0o00y5.jpg",
            "http://ww1.sinaimg.cn/mw690/692a6bbcgw1f4fz6g6wppj20ms0xp13n.jpg",
            "http://ww3.sinaimg.cn/mw690/81309c56jw1f4sx4ybttdj20ku0vd0ym.jpg",
            "http://ww4.sinaimg.cn/mw690/9844520fjw1f4fqribdg1j21911w0kjn.jpg"]
        let adDescs = ["I was angry friende", "Itold my wrath,my wrath did end.", "I was angry with my foe:", "Itold it not,my wrath did grow ", "And I watered it in fears"]
//        showImage = UIImageView(frame: CGRect(x: 0, y: sycleScroll.frame.maxY + 10, width: view.frame.width, height: view.frame.height))
//        showImage?.contentMode = .scaleAspectFill
//        showImage?.clipsToBounds = true
//        view.addSubview(showImage!)
//        sycleScroll.configAd(imageUrls, style: .center) { (idx) in
//            print(idx)
//            print(imageUrls[idx])
////            self.showImage!.kf.setImageWithURL(URL(string: imageUrls[idx])!)
//        }
//        edgesForExtendedLayout = UIRectEdge()
//        view.addSubview(sycleScroll)
        let ad = AutoCycleAdview(frame: CGRect(x: 0, y: 100 + 10, width: view.frame.width, height: 240))
        ad.imagUrls = imageUrls
        ad.callback = {
            print("🌹", $0)
        }
        view.addSubview(ad)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
