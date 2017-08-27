//
//  TableViewCell.swift
//  VoiceMemo
//
//  Created by Mars Zhang on 2017/8/27.
//  Copyright © 2017年 Mars Zhang. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate: class {
    func playVoice(index: Int);
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    weak var delegate: TableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func playAction(_ sender: UIButton) {
        self.delegate?.playVoice(index: sender.tag)
    }

}
