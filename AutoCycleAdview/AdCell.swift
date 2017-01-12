//
//  AdCell.swift
//  AutoCycleAdviewDemo
//
//  Created by KingCQ on 2017/1/11.
//  Copyright © 2017年 KingCQ. All rights reserved.
//

import UIKit

class AdCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var onlyDisplayText: Bool = false
    var titleAlignment = NSTextAlignment.left {
        didSet {
            titleLabel.textAlignment = titleAlignment
        }
    }

    var title: String = "" {
        didSet {
            switch titleAlignment {
            case .left:
                titleLabel.text = "\t" + title
            case .right:
                titleLabel.text = title + "\t"
            default:
                titleLabel.text = title
            }
        }
    }
    
    var titleColor: UIColor = .white {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    var titlebgColor = UIColor.black.withAlphaComponent(0.4) {
        didSet {
            titleLabel.backgroundColor = titlebgColor
        }
    }
    
    var titleFont: UIFont = UIFont.systemFont(ofSize: UIFont.labelFontSize) {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    var titleHeight: CGFloat = 25 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initImageView()
        initTilteLabel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initImageView() {
        imageView = UIImageView()
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    func initTilteLabel() {
        titleLabel = UILabel()
        titleLabel.textColor = titleColor
        titleLabel.backgroundColor = titlebgColor
        contentView.addSubview(titleLabel)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if onlyDisplayText {
            titleLabel.frame = contentView.bounds
        } else {
            imageView.frame = contentView.bounds
            titleLabel.frame = CGRect(origin: CGPoint(x: 0, y: contentView.bounds.height - titleHeight), size: CGSize(width: contentView.bounds.width, height: titleHeight))
        }
    }
}
