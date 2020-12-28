//
//  ReceiptHeaderTableViewCell.swift
//  FIBRA
//
//  Created by Irfan Malik on 16/12/2020.
//

import Foundation
import UIKit

class ReceiptHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblSectionDate: UILabel!
    @IBOutlet weak var cardView: UIView!
    var isCheckEncounter = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(sectionDate: String)  {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: sectionDate)
        print(date?.getPastTime())
        self.lblSectionDate.text = "\(date?.getPastTime() ?? sectionDate)"
    }
    
}
