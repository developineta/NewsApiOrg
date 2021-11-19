//
//  NewsFeedTableViewCell.swift
//  NewsApiOrg
//
//  Created by ineta.magone on 19/11/2021.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    func setupUI(withDataFrom: NewsItem){
        titleLabel.text = withDataFrom.title
        descriptionLabel.text = withDataFrom.description
        
        //articleImage.image = UIImage(string: withDataFrom.urlToImage)
    }
}
