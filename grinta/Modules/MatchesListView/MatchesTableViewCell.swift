//
//  MatchesTableViewCell.swift
//  grinta
//
//  Created by Linda adel on 25/08/2023.
//

import UIKit

class MatchesTableViewCell: UITableViewCell {

    @IBOutlet weak var firstTeam: UILabel!
    @IBOutlet weak var secondTeam: UILabel!
    @IBOutlet weak var Score: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
