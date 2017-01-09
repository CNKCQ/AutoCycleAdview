//
//  SycleSubviewContainer.swift
//  Swiftk
//
//  Created by KingCQ on 16/6/23.
//  Copyright © 2016年 Jack. All rights reserved.
//

import UIKit
import Kingfisher
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


public enum PageControlShowStyle {
    case none, left, center, right
}

public typealias ResponseClouser = (Int) -> ()

var currentIdx = 1
let interval = Double(3)
let PAGHEIGHT = CGFloat(20)
let SA_MARGIN = CGFloat(10)

open class SycleAdContainer: UIView, UIScrollViewDelegate {
    var scrollView: UIScrollView!
    var imageUrls: [String]?
    var adDescs: [String]?
    var pageControlShowStyle = PageControlShowStyle.center
    var pageControl = UIPageControl()
    let adDescsLabel = UILabel()
    var leftImageView: UIImageView!
    var rightImageView: UIImageView!
    var centerImageView: UIImageView!
    var isTimerAuto = false
    var timer: Timer?
    var showadDescs = true
    var tapResponse: ResponseClouser?
    var placehoderImage: UIImage?




    public override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView = UIScrollView(frame: bounds)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
        scrollView.contentSize = CGSize(width: bounds.width * 3, height: 0)
        scrollView.showsHorizontalScrollIndicator = false
        leftImageView = imageView(CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        centerImageView = imageView(CGRect(x: bounds.width, y: 0, width: bounds.width, height: bounds.height))
        rightImageView = imageView(CGRect(x: bounds.width * 2, y: 0, width: bounds.width, height: bounds.height))
        scrollView.delegate = self
        scrollView.addSubview(leftImageView)
        scrollView.addSubview(centerImageView)
        scrollView.addSubview(rightImageView)
        addSubview(scrollView)
        adDescsLabel.frame = CGRect(x: 0, y: bounds.height - bounds.height / 8, width: bounds.width, height: bounds.height / 8)
        adDescsLabel.backgroundColor = .black
        adDescsLabel.alpha = 0.7
        adDescsLabel.textColor = .white
        addSubview(adDescsLabel)
    }

    open func configAd(_ urls: [String], placeholder: UIImage = UIImage(), descs: [String] = [String](), style: PageControlShowStyle, response: @escaping ResponseClouser) {
        if descs.count == 0 {
            adDescsLabel.isHidden = true
        }
        imageUrls = urls
        adDescs = descs
        pageControlShowStyle = style
        tapResponse = response
        placehoderImage = placeholder
        configPageControl(style)
        auto()
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(auto), userInfo: nil, repeats: true)
        isTimerAuto = false
    }

    func configPageControl(_ style: PageControlShowStyle) {
        pageControl.numberOfPages = (imageUrls?.count)!
        let PAGEWIDTH = PAGHEIGHT * CGFloat((imageUrls?.count)!)
        let PAGEY = bounds.height - PAGHEIGHT
        switch style {
        case .none:
            pageControl.isHidden = true
        case .left:
            pageControl.frame = CGRect(x: SA_MARGIN, y: PAGEY, width: PAGEWIDTH, height: PAGHEIGHT)
        case .center:
            pageControl.frame = CGRect(x: (bounds.width - PAGEWIDTH) / 2, y: PAGEY, width: PAGEWIDTH, height: PAGHEIGHT)
        case .right:
            pageControl.frame = CGRect(x: bounds.width - SA_MARGIN - PAGEWIDTH, y: PAGEY, width: PAGEWIDTH, height: PAGHEIGHT)
        }
        pageControl.currentPage = 1
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        addSubview(pageControl)
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.scrollView.contentOffset.x == 0 {
            currentIdx = ((currentIdx - 1) % (imageUrls?.count)!)
        } else if self.scrollView.contentOffset.x == bounds.width * 2 {
            currentIdx = ((currentIdx + 1) % (imageUrls?.count)!)
        } else {
            return
        }
        pageControl.currentPage = abs(currentIdx)
        leftImageView.kf.setImage(with: URL(string: imageUrls![abs((currentIdx - 1) % (imageUrls?.count)!)])!, placeholder: placehoderImage, options: nil, progressBlock: nil, completionHandler: nil)
        centerImageView.kf.setImage(with: URL(string: imageUrls![abs((currentIdx) % (imageUrls?.count)!)])!, placeholder: placehoderImage, options: nil, progressBlock: nil, completionHandler: nil)
        rightImageView.kf.setImage(with: URL(string: imageUrls![abs((currentIdx + 1) % (imageUrls?.count)!)])!, placeholder: placehoderImage, options: nil, progressBlock: nil, completionHandler: nil)
        if adDescs?.count > 0 {
            adDescsLabel.text = "  " + adDescs![abs((currentIdx) % (imageUrls?.count)!)]
        }
        self.scrollView.contentOffset = CGPoint(x: bounds.width, y: 0)
        if isTimerAuto == false {
            timer?.fireDate = Date(timeIntervalSinceNow: interval)
        }
        isTimerAuto = false
    }

    func auto() {
        scrollView.setContentOffset(CGPoint(x: bounds.width * 2, y: 0), animated: true)
        isTimerAuto = true
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(scrollViewDidEndDecelerating(_:)), userInfo: nil, repeats: false)
    }

    func tap() {
        if tapResponse != nil {
            tapResponse!(abs(currentIdx))
        }
    }

    func imageView(_ frame: CGRect) -> UIImageView {
        let view = UIImageView(frame: frame)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        timer?.invalidate()
    }

}
