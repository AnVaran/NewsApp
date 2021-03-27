//
//  ViewController.swift
//  NewsApp
//
//  Created by Anton Varenik on 3/26/21.
//  Copyright © 2021 Anton Varenik. All rights reserved.
//

import UIKit

class FeedViewController: UICollectionViewController {

    var expandedCells = [Int]()
    var dayCounter = 1
    
    let feedLoad = FeedLoad()
    
    private var feedItems = [FeedItem]()
    private var filtredFeedItems = [FeedItem]()
    private let cellID = "Cell"
    private let topCellCoefficient: CGFloat = 7
    private let viewFeedImageHightCoefficient: CGFloat = 1.1
    private let dateAndHeidingLabelHight: CGFloat = 205
    
    lazy var upDataButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("♺", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.tintColor = .white
        button.addTarget(self, action: #selector(updataAction), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
        search.placeholder = "Search"
       
        return search
    }()
    
    @objc func updataAction(_ sender: UIButton) {
        dayCounter = 1
        feedItems.removeAll()
        filtredFeedItems.removeAll()
        
        fetchData(fromCurrentDate: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingCollecctioView()
        fetchData(fromCurrentDate: true)
        settingNavigationBarItems()
    }
    
    private func settingCollecctioView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.backgroundColor = #colorLiteral(red: 0.1803921569, green: 0.1843137255, blue: 0.2549019608, alpha: 1)
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellID)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func settingNavigationBarItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: upDataButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        searchBar.delegate = self
    }
    // MARK: - Load Feed
    private func fetchData(fromCurrentDate: Bool) {
        if dayCounter <= 7 {
            guard let date = DateConverter.getDateFor(hours: 24 * dayCounter) else { return }
            let fromDate = DateConverter.dateToISO_8601String(date: date)
            feedLoad.loadFeed(fromDate: fromDate, fromCurrentDate: fromCurrentDate) { [weak self] (items) in
                self?.feedItems.append(contentsOf: items)
                self?.filtredFeedItems.append(contentsOf: items)
                DispatchQueue.main.async {
                    self?.collectionView.reloadSections(IndexSet(integer: 0))
                    if fromCurrentDate {
                        self?.collectionView.setContentOffset(CGPoint.zero, animated: true)
                    }
                }
            }
            dayCounter += 1
        } else {
            print("DateCounter > 7 ....")
        }
    }

    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == feedItems.count - 1 {
            fetchData(fromCurrentDate: false)
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtredFeedItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! FeedCell
        cell.item = filtredFeedItems[indexPath.item]
        
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
        let index = IndexPath(item: sender.tag, section: 0)
        
        if expandedCells.contains(sender.tag) {
          expandedCells = expandedCells.filter { $0 != sender.tag }
            
            collectionView.reloadItems(at: [index])
        }
          // Otherwise, add the button to the array
        else {
          expandedCells.removeAll()
          expandedCells.append(sender.tag)
            collectionView.reloadItems(at: [index])
        }
      }
    }
}


extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = filtredFeedItems[indexPath.item].description
        let height = LabelHeightCalculate.heightForView(text: text, font: UIFont.systemFont(ofSize: 18), width: view.frame.width)
        
        if expandedCells.contains(indexPath.row) {
          return CGSize(width: view.frame.width, height: (view.frame.width * viewFeedImageHightCoefficient) + dateAndHeidingLabelHight + height + 20)
        } else {
          return  CGSize(width: view.frame.width, height: (view.frame.width * viewFeedImageHightCoefficient) + dateAndHeidingLabelHight + 80 + 20)
        }
    }
}

extension FeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtredFeedItems = []
        
        if searchText == "" {
            filtredFeedItems = feedItems
        } else {
            for item in feedItems {
                if item.title.lowercased().contains(searchText.lowercased()) {
                    filtredFeedItems.append(item)
                }
            }
        }
        collectionView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.resignFirstResponder()
    }
}


struct FeedItem {
    var imageURL: String
    var title: String
    var auther: String
    var pubDate: String
    var description: String
}
