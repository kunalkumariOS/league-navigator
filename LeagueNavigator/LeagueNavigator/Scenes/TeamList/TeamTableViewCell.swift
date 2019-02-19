//
//  TeamTableViewCell.swift
//  LeagueNavigator
//
//  Created by Dhiman kunal on 19/02/19.
//  Copyright © 2019 Dhiman kunal. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var teamName: UILabel!
    @IBOutlet weak var logoImageViewHeight: NSLayoutConstraint!
    
    private var viewModel: TeamCellViewModel? {
        didSet {
            self.teamName.attributedText = self.viewModel?.name
            self.viewModel?.fetchLogo(then: { [unowned self] content in
                performOnMain {
                    switch content {
                    case .logo(let image):
                        self.logoImageView.image = image
                    case .color(let color):
                        self.logoImageView.backgroundColor = color
                    case .none:
                        self.setNeedsUpdateConstraints()
                        self.logoImageViewHeight.constant = 0
                        self.updateConstraintsIfNeeded()
                    }
                }
            })
        }
    }
    
    func configure(withViewModel viewModel: TeamCellViewModel) {
        self.viewModel = viewModel
    }
}

extension TeamTableViewCell {
    static var nib: UINib {
        return UINib(nibName: String(describing: self.classForCoder()), bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self.classForCoder())
    }
}
