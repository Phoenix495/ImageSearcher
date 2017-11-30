//
//  HistoryCell.swift
//  ImageSearcher
//
//  Created by Phoenix on 29.11.17.
//  Copyright © 2017 Phoenix_Dev. All rights reserved.
//

import UIKit

class HistoryCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = UIColor.red
        return view
    }()
    
    let requestLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.text = "Request"
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        label.text = "dd:MM:YY HH:mm:ss"
        return label
    }()
    
    //MARK: - Configuration
    
    func setupView() {
        
        addSubview(imageView)
        addSubview(requestLabel)
        addSubview(dateLabel)
        
        // config constraints
        // set constraint to image view
        // set vertical constraint
        NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 8).isActive = true
        
        // attach top of image view to top of cell with spacing equal to 8 points
        NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 8).isActive = true
        // similarly, at the bottom
        NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -8).isActive = true
        
        // set the width equal to height
        NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: 1, constant: 0).isActive = true
        
        // set constraint to request label
        // set vertical constraint
        NSLayoutConstraint(item: requestLabel, attribute: .centerY, relatedBy: .equal, toItem: imageView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        // set horizontal spacing to image view
        NSLayoutConstraint(item: requestLabel, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .trailing, multiplier: 1, constant: 10).isActive = true
        
        // date label
        // set verticla contraint
        NSLayoutConstraint(item: dateLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 8).isActive = true
        
        // set right spacing
        NSLayoutConstraint(item: dateLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -8).isActive = true
    }
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
