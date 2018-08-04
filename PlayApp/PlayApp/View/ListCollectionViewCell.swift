//
//  ListCellCollectionViewCell.swift
//  PlayApp
//
//  Created by ameethakkar on 8/3/18.
//  Copyright © 2018 ameethakkar. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    @IBOutlet weak var repoCreatedAt: UILabel!
    @IBOutlet weak var repoLicense: UILabel!
    
    override func awakeFromNib() {
    }
    
    func configure(repo: Repository) {
        repoName.text = repo.getName()
        repoDescription.text = repo.getDescription()
        repoCreatedAt.text = repo.getCreatedAt()
        repoLicense.text = repo.getLicense()
    }
}
