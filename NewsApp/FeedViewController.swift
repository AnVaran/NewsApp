//
//  ViewController.swift
//  NewsApp
//
//  Created by Anton Varenik on 3/26/21.
//  Copyright © 2021 Anton Varenik. All rights reserved.
//

import UIKit

class FeedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var expandedCells = [Int]()
    
    private var feedItems: [FeedItem]?
    private let cellID = "Cell"
    private let topCellCoefficient: CGFloat = 7
    private let viewFeedImageHightCoefficient: CGFloat = 1.1
    private let dateAndHeidingLabelHight: CGFloat = 205
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingCollecctioView()
        fetchData()
    }
    
    private func settingCollecctioView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        
        //collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.1843137255, blue: 0.2549019608, alpha: 1)
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellID)
        navigationController?.navigationBar.isTranslucent = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    // MARK: - Load Feed
    
    private func fetchData() {
        let feedLoad = FeedLoad()
        feedLoad.loadFeed(url: "https://news.tut.by/rss/all.rss") { [weak self] (rssItems) in
            self?.feedItems = rssItems
            DispatchQueue.main.async {
                self?.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let text = feedItems?[indexPath.item].description else { return CGSize(width: view.frame.width, height: (view.frame.width * viewFeedImageHightCoefficient) + dateAndHeidingLabelHight + 10)}
        let height = LabelHeightCalculate.heightForView(text: text, font: UIFont.systemFont(ofSize: 18), width: view.frame.width)
        
        if expandedCells.contains(indexPath.row) {
          return CGSize(width: view.frame.width, height: (view.frame.width * viewFeedImageHightCoefficient) + dateAndHeidingLabelHight + height + 10)
        } else {
          return  CGSize(width: view.frame.width, height: (view.frame.width * viewFeedImageHightCoefficient) + dateAndHeidingLabelHight + 80 + 10)
        }
        
        
    }

    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let rssItems = feedItems else {
            return 0
        }
        return rssItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FeedCell
        if let item = feedItems?[indexPath.item] {
            cell.item = item
        }
        if expandedCells.contains(indexPath.row) {
            cell.button.setTitle("Less", for: .normal)
            cell.feedText.numberOfLines = 0
        } else {
            cell.button.setTitle("Show more", for: .normal)
            cell.feedText.numberOfLines = 3
        }
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(deleteAction), for: UIControl.Event.touchUpInside)
        
        
        return cell
    }
    
    @objc func deleteAction(_ sender: UIButton){
      if let button = sender as? UIButton {
        // If the array contains the button that was pressed, then remove that button from the array
        if expandedCells.contains(sender.tag) {
          expandedCells = expandedCells.filter { $0 != sender.tag }
            //sender.titleLabel?.text = "See more..."
        }
          // Otherwise, add the button to the array
        else {
          expandedCells.removeAll()
          expandedCells.append(sender.tag)
        }
        // Reload the tableView data anytime a button is pressed
        DispatchQueue.main.async {
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }

      }
    }
}


struct FeedItem {
    var imageURL: String
    var title: String
    var auther: String
    var pubDate: String
    var description: String
}
