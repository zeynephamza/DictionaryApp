//
//  HistoryTableCell.swift
//  DictionaryApp
//
//  Created by Zeynep Özcan on 19.05.2024.
//

import UIKit


protocol HistoryTableCellProtocol: AnyObject {
    func setHistoryLabel(_ text: String)
}

class HistoryTableCell: UITableViewCell {

    @IBOutlet var historyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension HistoryTableCell: HistoryTableCellProtocol{

    func setHistoryLabel(_ text: String) {
        historyLabel.text = text
    }
}
