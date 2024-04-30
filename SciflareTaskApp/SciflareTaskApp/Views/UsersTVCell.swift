//
//  UsersTVCell.swift
//  SciflareTaskApp
//
//  Created by Pravin's Mac M1 on 30/04/24.
//

import UIKit

class UsersTVCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    var editTapHandler : (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        bgView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editButtenTapped(_ sender: UIButton) {
        editTapHandler?()
    }
    
}
