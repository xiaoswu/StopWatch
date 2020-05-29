//
//  RecordTimeCell.swift
//  stopWatch_swift
//
//  Created by ynfMac on 2020/5/25.
//  Copyright © 2020 ynfMac. All rights reserved.
//

import UIKit

class RecordTimeCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.black
        textLabel?.textColor = UIColor.white
        detailTextLabel?.textColor = UIColor.white
        detailTextLabel?.font = UIFont.init(name: "HiraMinProN-W3", size: 17)
        isUserInteractionEnabled = false
    }
    
    public func recordTime( with data:stopWatchData, _ indexPath:IndexPath){
        
        textLabel?.textColor = UIColor.white
        detailTextLabel?.textColor = UIColor.white
        
        textLabel?.text = "计次\(data.times.count - indexPath.row)"
        let time = data.times[indexPath.row]
        detailTextLabel?.text = convertTime(seconds: time)
        
        if indexPath.row == data.maxTime{
            textLabel?.textColor = UIColor.red
            detailTextLabel?.textColor = UIColor.red
        }
        
        if indexPath.row == data.minTime{
            textLabel?.textColor = UIColor.green
            detailTextLabel?.textColor = UIColor.green
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func convertTime(seconds: Int) ->String{
        return String(format: "%02ld:%02ld.%02ld",seconds / 100 / 60, seconds / 100 % 60, seconds % 100)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
