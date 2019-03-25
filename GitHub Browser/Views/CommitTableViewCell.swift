//
//  CommitTableViewCell.swift
//  GitHub Browser
//
//  Created by Christopher Thiebaut on 3/24/19.
//  Copyright © 2019 Christopher Thiebaut. All rights reserved.
//

import UIKit

class CommitTableViewCell: UITableViewCell {
    
    static var nibName: String {
        return String(describing: self)
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hashLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        nameLabel.text = nil
        hashLabel.text = nil
        messageLabel.text = nil
    }
    
}
