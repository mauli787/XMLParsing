//
//  movieTableViewCell.swift
//  XMLParseDemo
//
//  Created by Dnyaneshwar on 12/01/21.
//

import UIKit
import SDWebImage

class MovieTableViewCellNew: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setConfigureData(rowModel: Movie) {
        self.titleLabel.text = rowModel.title
        self.imgView.sd_setImage(with: URL(string: rowModel.imageLinkUrl), placeholderImage:UIImage(named: ""))
    }
}
