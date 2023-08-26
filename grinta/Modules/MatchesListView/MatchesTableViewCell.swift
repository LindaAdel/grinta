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
    
    var isFavorite: Bool = false {
        didSet {
            favouriteButton.isSelected = isFavorite
        }
    }
    
    var didTapFavouriteButton: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favouriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        favouriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isFavorite = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
  
    @IBAction func didTapFavouriteButton(_ sender: UIButton) {
        isFavorite.toggle()
        favouriteButton.isSelected = isFavorite
        didTapFavouriteButton?()
    }

}
