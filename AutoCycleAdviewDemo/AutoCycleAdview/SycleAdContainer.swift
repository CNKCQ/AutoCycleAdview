//
//  SycleSubviewContainer.swift
//  Swiftk
//
//  Created by KingCQ on 16/6/23.
//  Copyright © 2016年 Jack. All rights reserved.
//

import UIKit
import Kingfisher

public enum PageControlShowStyle {
    case None, Left, Center, Right
}

public typealias ResponseClouser = (Int) -> ()

var currentIdx = 1
let interval = Double(3)
let PAGHEIGHT = CGFloat(20)
let SA_MARGIN = CGFloat(10)

public class SycleAdContainer: UIView, UIScrollViewDelegate {
    var scrollView: UIScrollView!
    var imageUrls: [String]?
    var adDescs: [String]?
    var pageControlShowStyle = PageControlShowStyle.Center
    var pageControl = UIPageControl()
    let adDescsLabel = UILabel()
    var leftImageView: UIImageView!
    var rightImageView: UIImageView!
    var centerImageView: UIImageView!
    var isTimerAuto = false
    var timer: NSTimer?
    var showadDescs = true
    var tapResponse: ResponseClouser?


    public override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView = UIScrollView(frame: bounds)
        scrollView.bounces = false
        scrollView.pagingEnabled = true
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
        adDescsLabel.backgroundColor = .blackColor()
        adDescsLabel.alpha = 0.7
        adDescsLabel.textColor = .whiteColor()
        addSubview(adDescsLabel)
    }

    public func configAd(urls: [String], placeholder: UIImage = UIImage(), descs: [String], style: PageControlShowStyle, response: ResponseClouser) {
        imageUrls = urls
        adDescs = descs
        pageControlShowStyle = style
        tapResponse = response
        configPageControl(style)
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(auto), userInfo: nil, repeats: true)
        isTimerAuto = false
    }

    func configPageControl(style: PageControlShowStyle) {
        pageControl.numberOfPages = (imageUrls?.count)!
        let PAGEWIDTH = PAGHEIGHT * CGFloat((imageUrls?.count)!)
        let PAGEY = bounds.height - PAGHEIGHT
        switch style {
        case .None:
            pageControl.hidden = true
        case .Left:
            pageControl.frame = CGRect(x: SA_MARGIN, y: PAGEY, width: PAGEWIDTH, height: PAGHEIGHT)
        case .Center:
            pageControl.frame = CGRect(x: (bounds.width - PAGEWIDTH) / 2, y: PAGEY, width: PAGEWIDTH, height: PAGHEIGHT)
        case .Right:
            pageControl.frame = CGRect(x: bounds.width - SA_MARGIN - PAGEWIDTH, y: PAGEY, width: PAGEWIDTH, height: PAGHEIGHT)
        }
        pageControl.currentPage = 1
        pageControl.pageIndicatorTintColor = .grayColor()
        pageControl.currentPageIndicatorTintColor = .whiteColor()
        addSubview(pageControl)
    }

    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if self.scrollView.contentOffset.x == 0 {
            currentIdx = ((currentIdx - 1) % (imageUrls?.count)!)
        } else if self.scrollView.contentOffset.x == bounds.width * 2 {
            currentIdx = ((currentIdx + 1) % (imageUrls?.count)!)
        } else {
            return
        }
        pageControl.currentPage = abs(currentIdx)
        leftImageView.kf_setImageWithURL(NSURL(string: imageUrls![abs((currentIdx - 1) % (imageUrls?.count)!)])!)
        centerImageView.kf_setImageWithURL(NSURL(string: imageUrls![abs((currentIdx) % (imageUrls?.count)!)])!)
        rightImageView.kf_setImageWithURL(NSURL(string: imageUrls![abs((currentIdx + 1) % (imageUrls?.count)!)])!)
        self.adDescsLabel.text = "  " + adDescs![abs((currentIdx) % (imageUrls?.count)!)]
        self.scrollView.contentOffset = CGPointMake(bounds.width, 0)
        if isTimerAuto == false {
            timer?.fireDate = NSDate(timeIntervalSinceNow: interval)
        }
        isTimerAuto = false
    }

    func auto() {
        scrollView.setContentOffset(CGPoint(x: bounds.width * 2, y: 0), animated: true)
        isTimerAuto = true
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(scrollViewDidEndDecelerating(_:)), userInfo: nil, repeats: false)
    }

    func tap() {
        if tapResponse != nil {
            tapResponse!(abs(currentIdx))
        }
    }

    func imageView(frame: CGRect) -> UIImageView {
        let view = UIImageView(frame: frame)
        view.contentMode = .ScaleAspectFill
        view.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(tapGesture)
        view.userInteractionEnabled = true
        return view
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        timer?.invalidate()
    }

}
