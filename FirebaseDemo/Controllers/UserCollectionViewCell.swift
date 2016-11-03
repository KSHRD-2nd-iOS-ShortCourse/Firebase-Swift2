//
//  UserCollectionViewCell.swift
//  FirebaseDemo
//
//  Created by Kokpheng on 11/3/16.
//  Copyright © 2016 Kokpheng. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.makeItRound()
    }
    
    func makeItRound() {
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
    }
    
    
}
