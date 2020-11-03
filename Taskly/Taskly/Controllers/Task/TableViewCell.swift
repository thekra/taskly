//
//  TableViewCell.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 16/03/1442 AH.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkButton.layer.cornerRadius = 13 //* checkButton.bounds.size.width
        checkButton.layer.borderWidth = 0.8
        checkButton.clipsToBounds = true
        checkButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
//    @IBAction func switcher(_ sender: UIButton) {
//        if sender.tag == 1 {
//            sender.backgroundColor = .offWhite
//            sender.tag = 0
//            sender.isSelected = false
//            print(sender.tag)
//            
//            print("sender.isSelected: \(sender.isSelected)")
//            
//        } else if sender.tag == 0 {
//            sender.backgroundColor = .purple
//            sender.tag = 1
//            sender.isSelected = true
//            print(sender.tag)
//            print("sender.isSelected: \(sender.isSelected)")
//        }
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
