//
//  FeedCell.swift
//  NewsApp
//
//  Created by Anton Varenik on 3/26/21.
//  Copyright © 2021 Anton Varenik. All rights reserved.
//

import Foundation
import UIKit



class FeedCell: UICollectionViewCell {
    
    private let dateAndConstraintWidth: CGFloat = 140
    private let cellFeedImageHightCoefficient: CGFloat = 1.1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    // MARK: Set Elements
    let feedImage: LoadImage = {
        let image = LoadImage()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .gray
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        return image
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.6274509804, green: 0.6470588235, blue: 0.7098039216, alpha: 1)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.6274509804, green: 0.6470588235, blue: 0.7098039216, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    let headingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    let feedText: UILabel = {
        var text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 3
        text.textAlignment = .center
        text.font = UIFont.systemFont(ofSize: 18)
        text.textColor = #colorLiteral(red: 0.6274509804, green: 0.6470588235, blue: 0.7098039216, alpha: 1)
        return text
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitle("See more...", for: .normal)
        button.setTitle("Show more", for: .normal)
        return button
    }()

    // MARK: Get Feed Data
    var item: FeedItem! {
        didSet {
            authorLabel.text = item.auther
            dateLabel.text = item.pubDate
            headingLabel.text = item.title
            feedText.text = item.description
            if let url = URL(string: item.imageURL) {
                feedImage.loadImage(from: url)
            }
            let height = LabelHeightCalculate.heightForView(text: item.description, font: UIFont.systemFont(ofSize: 18), width: contentView.frame.width)
            if height <= 70 {
                button.isHidden = true
            } else {
                button.isHidden = false
            }
            
            
        }
    }
    // MARK: Setup Views
    func setupViews() {
        
        addSubview(feedImage)
        addSubview(authorLabel)
        addSubview(dateLabel)
        addSubview(headingLabel)
        addSubview(feedText)
        addSubview(button)
        
        //feedImage constraints
        //top
        addConstraint(NSLayoutConstraint(item: feedImage, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0))
        // right
        addConstraint(NSLayoutConstraint(item: feedImage, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0))
        // left
        addConstraint(NSLayoutConstraint(item: feedImage, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0))
        // height
        addConstraint(NSLayoutConstraint(item: feedImage, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: contentView.frame.width * cellFeedImageHightCoefficient))
        
        //dateLabel constraints
        // top
        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .top, relatedBy: .equal, toItem: feedImage, attribute: .bottom, multiplier: 1, constant: 20))
        // right
        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -5))
        // width
        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: 130))
        // height
        addConstraint(NSLayoutConstraint(item: dateLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50))
        
        //autherLabel constraints
        // top
        addConstraint(NSLayoutConstraint(item: authorLabel, attribute: .top, relatedBy: .equal, toItem: feedImage, attribute: .bottom, multiplier: 1, constant: 20))
        // left
        addConstraint(NSLayoutConstraint(item: authorLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 5))
        // widht
        addConstraint(NSLayoutConstraint(item: authorLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0, constant: contentView.frame.width - dateAndConstraintWidth))
        // height
        addConstraint(NSLayoutConstraint(item: authorLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 50))
        
        //headingLabel constraints
        // top
        addConstraint(NSLayoutConstraint(item: headingLabel, attribute: .top, relatedBy: .equal, toItem: dateLabel, attribute: .bottom, multiplier: 1, constant: 0))
        // left
        addConstraint(NSLayoutConstraint(item: headingLabel, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 10))
        // right
        addConstraint(NSLayoutConstraint(item: headingLabel, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -10))
        // height
        addConstraint(NSLayoutConstraint(item: headingLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 130))
        
        //feedText constraints
        // top
        addConstraint(NSLayoutConstraint(item: feedText, attribute: .top, relatedBy: .equal, toItem: headingLabel, attribute: .bottom, multiplier: 1, constant: 5))
        // left
        addConstraint(NSLayoutConstraint(item: feedText, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 5))
        // right
        addConstraint(NSLayoutConstraint(item: feedText, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -5))
        // height
        //addConstraint(NSLayoutConstraint(item: feedText, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 70))
        addConstraint(NSLayoutConstraint(item: feedText, attribute: .bottom, relatedBy: .equal, toItem: button, attribute: .top, multiplier: 1, constant: 0))
        
        //button
        // top
        //addConstraint(NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: feedText, attribute: .bottom, multiplier: 1, constant: 7))
        // left
        addConstraint(NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 5))
        // right
        addConstraint(NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: -5))
        //height
        addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 10))
        // bottom
        addConstraint(NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
