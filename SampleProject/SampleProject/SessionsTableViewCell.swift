//
//  SessionsTableViewCell.swift
//  SampleProject
//
//  Created by Aashutosh Shrestha on 4/18/24.
//

import UIKit

class SessionsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
