//
//  TableViewCell.swift
//  testTaskNewsPecodeSoftware
//
//  Created by Andrew Cheberyako on 11.07.2021.
//

import UIKit

protocol CustomCellDelegate: class {
    func customCell(_ cell: TableViewCell, didPressButton: UIButton)
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewNews: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var sourseLabel: UILabel!
    @IBOutlet weak var favoriteButtonOutlet: UIButton!
    
    static let identifier = "cell"

    let button  = UIButton(type: .system)
    weak var delegate: CustomCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .mainWhite()
        imageViewNews.layer.cornerRadius = 10
        imageViewNews.clipsToBounds = true
        
        
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        
       
        self.delegate?.customCell(self, didPressButton: sender)
        
    }
    
    
    static var nib: UINib {
           return UINib(nibName: String(describing: self), bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
}
