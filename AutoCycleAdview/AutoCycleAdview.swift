//
//  AutoCycleAdview.swift
//  AutoCycleAdviewDemo
//
//  Created by KingCQ on 2017/1/11.
//  Copyright © 2017年 KingCQ. All rights reserved.
//

import UIKit
import Kingfisher

public enum PageControlAlignment {
    case left, center, right
}

public class AutoCycleAdview: UIView {
    
    public var interval: Double = 5.0
    public var isAutoScroll: Bool = true
    public var isShowPageControl: Bool = true
    public var isHiddenWhenSinglePage: Bool = true
    public var placeholder: UIImage = UIImage()
    public var callback: ((Int) -> ())?
    public var pageControlAlignment = PageControlAlignment.right
    public var isShowTitle: Bool = true
    public var onlyDisplayText: Bool = false
    public var titleAlignment = NSTextAlignment.left
    public var titleColor: UIColor = .white
    public var titlebgColor = UIColor.black.withAlphaComponent(0.4)
    public var titleFont: UIFont = UIFont.systemFont(ofSize: UIFont.labelFontSize)
    public var titleHeight: CGFloat = 25
    public var imgContentMode: UIViewContentMode = .scaleAspectFill
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var itemsCount: Int = 0
    fileprivate var backgroundImgView: UIImageView = UIImageView()
    fileprivate var timer: Timer!
    fileprivate var layout: UICollectionViewFlowLayout!
    fileprivate var pageControl: UIPageControl!
    
    public var pageControlTinColor: UIColor = .lightGray {
        didSet {
            pageControl.pageIndicatorTintColor = pageControlTinColor
        }
    }
    
    public var currentTinColor: UIColor = .white {
        didSet {
            pageControl.currentPageIndicatorTintColor = currentTinColor
        }
    }

    public var imagUrls: [String] = [] {
        didSet {
            itemsCount = imagUrls.count * 5000
            if imagUrls.count > 1 {
                collectionView.isScrollEnabled = true
                setAutoScroll()
            } else {
                collectionView.isScrollEnabled = false
            }
            setUpPageControl()
            collectionView.reloadData()
        }
    }
    
    public var titles: [String] = [] {
        didSet {
            if onlyDisplayText {
                imagUrls = titles
            }
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        setUpCollectinView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCollectinView() {
        layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AdCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollsToTop = false
        addSubview(collectionView)
    }
    
    func setUpPageControl() {
        pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = currentTinColor
        pageControl.pageIndicatorTintColor = pageControlTinColor
        pageControl.numberOfPages = imagUrls.count
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPage = index(with: currentIndex())
        addSubview(pageControl)
    }
    
    func setAutoScroll() {
        deinitTimer()
        if isAutoScroll {
            initTimer()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layout.itemSize = bounds.size
        collectionView.frame = bounds
        if collectionView.contentOffset.x == 0, itemsCount > 0 {
            collectionView.scrollToItem(at: IndexPath(item: Int(Double(itemsCount) * 0.5), section: 0), at: [], animated: false)
        }
        let size = CGSize(width: Double(imagUrls.count * 5) * 1.5, height: 5)
        var x = bounds.width - size.width
        let y = bounds.height - size.height - 10
        switch pageControlAlignment {
        case .left:
            x = 30
        case .center:
            x = (bounds.width - size.width) / 2
        case .right:
            x = bounds.width - size.width - 10 - 20
        }
        pageControl.frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
    }
    
    func initTimer() {
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
    }
    
    func deinitTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    public func preScroll(to: Int) {
        scroll(to: currentIndex())
    }
    
    func automaticScroll() {
        scroll(to: currentIndex() + 1)
    }
    
    func scroll(to index: Int) {
        if index > itemsCount {
            collectionView.scrollToItem(at: IndexPath(item: Int(Double(itemsCount) * 0.5), section: 0), at: .centeredHorizontally, animated: true)
            return
        }
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func index(with current: Int) -> Int {
        guard !imagUrls.isEmpty else {
            return 0
        }
        return current % imagUrls.count
    }
    
    func currentIndex() -> Int {
        var index = 0
        switch layout.scrollDirection {
        case .horizontal:
            index = Int((collectionView.contentOffset.x + layout.itemSize.width * 0.5) / layout.itemSize.width)
        case .vertical:
            index = Int((collectionView.contentOffset.y + layout.itemSize.height * 0.5) / layout.itemSize.height)
        }
        return max(0, index)
    }

    deinit {
        collectionView.delegate = nil
        collectionView.dataSource = nil
        deinitTimer()
    }
}

extension AutoCycleAdview: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AdCell
        let idx = index(with: indexPath.row)
        let uri = imagUrls[idx]
        cell.titleLabel.isHidden = !isShowTitle
        cell.onlyDisplayText = onlyDisplayText
        cell.titleColor = titleColor
        cell.titlebgColor = titlebgColor
        cell.titleHeight = titleHeight
        cell.titleAlignment = titleAlignment
        cell.titleFont = titleFont
        cell.imageView.contentMode = imgContentMode
        if isShowTitle, onlyDisplayText {
            cell.title = titles[idx]
        } else if let url = URL(string: uri), url.scheme!.contains("http") {
            cell.imageView.kf.setImage(with: url, placeholder: placeholder, options: nil, progressBlock: nil, completionHandler: nil)
            if isShowTitle {
                cell.title = titles[idx]
            }
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        callback?(index(with: indexPath.row))
    }
}

extension AutoCycleAdview: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !imagUrls.isEmpty else {return}
        pageControl.currentPage = index(with: currentIndex())
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        deinitTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        initTimer()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard !imagUrls.isEmpty else {return}
    }
}
