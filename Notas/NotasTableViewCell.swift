//
//  NotasTableViewCell.swift
//  Notas
//
//  Created by Jose Carlos Corona Bautista on 03/03/23.
//

import UIKit

class NotasTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var notaLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
