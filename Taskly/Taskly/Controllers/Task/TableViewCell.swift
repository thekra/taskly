//
//  TableViewCell.swift
//  Taskly
//
//  Created by Thekra Abuhaimed. on 16/03/1442 AH.
//

import UIKit

protocol TaskCellDelegate {
    func updateTask(index: Int)
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    var cellDelegate: TaskCellDelegate!
    var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkButton.layer.cornerRadius = 13 //* checkButton.bounds.size.width
        checkButton.layer.borderWidth = 0.8
        checkButton.clipsToBounds = true
        checkButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func switcher(_ sender: UIButton) {
        cellDelegate.updateTask(index: index!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
