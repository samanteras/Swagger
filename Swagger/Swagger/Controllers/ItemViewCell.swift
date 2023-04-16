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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(url: String?, imageView: UIImageView) {
        if let imageUrl = url, let url = URL(string: imageUrl) {
            self.imageItem.kf.setImage(with: url)
        } else {
            self.imageItem.image = UIImage(named: "content")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
            self.imageItem.image = nil
    }
}
