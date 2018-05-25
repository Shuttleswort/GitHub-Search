//
//  RepoCell.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/23/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!

    func configure(with repo: Repository) {
        titleLabel.text = repo.name
        descriptionLabel.text = repo.description
        starsLabel.text = "\(repo.stars)"
    }

}
