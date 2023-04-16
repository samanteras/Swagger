//
//  ItemViewCell.swift
//  Swagger
//
//  Created by MAC13 on 14.04.2023.
//

import UIKit

class ItemViewCell: UITableViewCell {

    @IBOutlet weak var nameItem: UILabel!
    @IBOutlet weak var imageItem: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
            self.imageItem.image = nil
    }
}
