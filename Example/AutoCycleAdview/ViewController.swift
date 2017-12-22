//
//  ViewController.swift
//  AutoCycleAdview
//
//  Created by wangchengqvan@gmail.com on 12/22/2017.
//  Copyright (c) 2017 wangchengqvan@gmail.com. All rights reserved.
//

import UIKit
import AutoCycleAdview

class ViewController: UIViewController {
    var showImage: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let imageUrls = [
            "http://ww3.sinaimg.cn/large/610dc034jw1f4saelbb4oj20zk0qoage.jpg",
            "http://ww1.sinaimg.cn/mw690/692a6bbcgw1f4fz7s830fj20gg0o00y5.jpg",
            "http://ww1.sinaimg.cn/mw690/692a6bbcgw1f4fz6g6wppj20ms0xp13n.jpg",
            "http://ww3.sinaimg.cn/mw690/81309c56jw1f4sx4ybttdj20ku0vd0ym.jpg",
            "http://ww4.sinaimg.cn/mw690/9844520fjw1f4fqribdg1j21911w0kjn.jpg",
            ]
        let adDescs = ["I was angry friende", "Itold my wrath,my wrath did end.", "I was angry with my foe:", "Itold it not,my wrath did grow ", "And I watered it in fears"]
        let ad = AutoCycleAdview(frame: CGRect(x: 0, y: 100 + 10, width: view.frame.width, height: 240))
        ad.pageControlAlignment = .right
        ad.imagUrls = imageUrls
        ad.isShowTitle = true
        ad.titleAlignment = .left
        ad.pageControlTinColor = .blue
        ad.currentTinColor = .red
        ad.titles = adDescs
        
        ad.callback = {
            print("🌹", adDescs[$0])
        }
        view.addSubview(ad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

