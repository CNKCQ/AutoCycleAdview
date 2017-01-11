//
//  AutoCycleAdview.swift
//  AutoCycleAdviewDemo
//
//  Created by KingCQ on 2017/1/11.
//  Copyright © 2017年 KingCQ. All rights reserved.
//

import UIKit
import Kingfisher

class AutoCycleAdview: UIView {
    
    var collectionView: UICollectionView!
    var itemsCount: Int = 0
    var interval: Double = 5.0
    var isAutoScroll: Bool = true
    var isShowPageControl: Bool = true
    var isHiddenWhenSinglePage: Bool = true
    var placeholder: UIImage = UIImage()
    var backgroundImgView: UIImageView = UIImageView()
    var timer: Timer!
    var layout: UICollectionViewFlowLayout!
    var pageControl: UIPageControl!
    var callback: ((Int) -> ())?
    
    var imagUrls: [String] = [] {
        didSet {
            itemsCount = imagUrls.count * 100
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        setUpCollectinView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialization() {
        
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
        collectionView.scrollsToTop = false
        collectionView.register(AdCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
    }
    
    func setUpPageControl() {
        pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .black
        pageControl.numberOfPages = imagUrls.count
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPage = index(with: currentIndex())
        addSubview(pageControl)
    }
    
    func setAutoScroll() {
        deinitTimer()
//        if  {
            initTimer()
//        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout.itemSize = bounds.size
        collectionView.frame = bounds
        if collectionView.contentOffset.x == 0, itemsCount > 0 {
            collectionView.scrollToItem(at: IndexPath(item: Int(Double(itemsCount) * 0.5), section: 0), at: .centeredHorizontally, animated: true)
        }
        let size = CGSize(width: Double(imagUrls.count * 5) * 1.5, height: 5)
        let x = bounds.width - size.width - 10 - 20
        let y = bounds.height - size.height - 10
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
        return index
    }
}

extension AutoCycleAdview: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AdCell
        let idx = index(with: indexPath.row)
        let url = imagUrls[idx]
        cell.imageView.contentMode = .scaleAspectFill
        cell.title = "你好， 我来了看看这个👀"
        cell.imageView.kf.setImage(with: URL(string: url)!, placeholder: placeholder, options: nil, progressBlock: nil, completionHandler: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        callback?(index(with: indexPath.row))
    }
}

extension AutoCycleAdview: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !imagUrls.isEmpty else {return}
        pageControl.currentPage = index(with: currentIndex())
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        deinitTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        initTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard !imagUrls.isEmpty else {return}
    }
}
