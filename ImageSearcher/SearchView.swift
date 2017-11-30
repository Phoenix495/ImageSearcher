//
//  SearchView.swift
//  ImageSearcher
//
//  Created by Phoenix on 30.11.17.
//  Copyright © 2017 Phoenix_Dev. All rights reserved.
//

import UIKit

class SearchView: UIView {
    
    
    //MARK: - Properties

    let barColor = UIColor(red: 189/255, green: 189/255, blue: 195/255, alpha: 1.0)
    
    let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundImage = UIImage()
        return bar
    }()
    
    let historyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Configuration
    
    func setupViews() {
        
        // set bacground color of view
        // and bar tint color of search bar
        self.backgroundColor = barColor
        searchBar.barTintColor = barColor
        
        // add search bar and collection view on super view
        self.addSubview(searchBar)
        self.addSubview(historyCollectionView)
        self.addSubview(activityIndicator)
        
        // Configuraton constraints
        NSLayoutConstraint(item: searchBar, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: searchBar, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: searchBar, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: historyCollectionView, attribute: .top, relatedBy: .equal, toItem: searchBar, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: historyCollectionView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: historyCollectionView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: historyCollectionView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        // activity indicator
        NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
