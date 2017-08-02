//
//  MenuCell.swift
//  Mojo
//
//  Created by NIKHILESH on 19/02/17.
//  Copyright © 2017 NIKHILESH. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgVeItem: UIImageView!
    @IBOutlet weak var imgSep: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
