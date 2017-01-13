# AutoCycleAdview
A custom view write by swift
#

[![CI Status](http://img.shields.io/travis/kishikawakatsumi/AutoCycleAdview.svg?style=flat)](https://travis-ci.org/kishikawakatsumi/AutoCycleAdview)
[![Version](https://img.shields.io/cocoapods/v/AutoCycleAdview.svg?style=flat)](http://cocoadocs.org/docsets/AutoCycleAdview)
[![Platform](https://img.shields.io/cocoapods/p/AutoCycleAdview.svg?style=flat)](http://cocoadocs.org/docsets/AutoCycleAdview)
![](https://camo.githubusercontent.com/7d97f558ccb8751e27fa65eeee94047955eba100/68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f313630302f312a7861666332716159644d375a4f68655957614d6d51412e706e67)
# AutoCycleAdview
A custom ADView
##### :eyes: See also:
![](http://7xslr9.com1.z0.glb.clouddn.com/AutoCycleAdview_display.gif)
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build IDCardKeyboard 3.0.0+.

To integrate IDCardKeyboard into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'AutoCycleAdview'
end
```

Then, run the following command:

```bash
$ pod install
```

## :book: Usage
  ``` bash
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let imageUrls = [
            "http://ww3.sinaimg.cn/large/610dc034jw1f4saelbb4oj20zk0qoage.jpg",
            "http://ww1.sinaimg.cn/mw690/692a6bbcgw1f4fz7s830fj20gg0o00y5.jpg",
            "http://ww1.sinaimg.cn/mw690/692a6bbcgw1f4fz6g6wppj20ms0xp13n.jpg",
            "http://ww3.sinaimg.cn/mw690/81309c56jw1f4sx4ybttdj20ku0vd0ym.jpg",
            "http://ww4.sinaimg.cn/mw690/9844520fjw1f4fqribdg1j21911w0kjn.jpg"]
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


  ```

  :key: Basics Swift2.2, Swift 3.0
## Author

CNKCQ, wangchengqvan@gmail.com
## License

AutoCycleAdview is available under the MIT license. See the LICENSE file for more info.
