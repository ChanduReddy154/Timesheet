//
//  TimeSheetTableViewCell.swift
//  Portal
//
//  Created by Chandu Reddy on 23/01/21.
//

import UIKit

class TimeSheetTableViewCell: UITableViewCell {
    
    @IBOutlet var projectTitle: UILabel!
    
    @IBOutlet var projectDate: UILabel!
    
    @IBOutlet var projectDescription: UILabel!
    
    @IBOutlet var workingHrs: UILabel!
    
    @IBOutlet var projectStatus: UILabel!
    
    @IBOutlet var entireView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        entireView.layer.cornerRadius = 15
        entireView.layer.shadowColor = UIColor.black.cgColor
        
    }
    
    func updateTimesheet(timesheetData :TimesheetData) {
        projectTitle.text = timesheetData.projectTitle
        projectDate.text = timesheetData.currentDate
        projectDescription.text = timesheetData.projectDescription
        projectStatus.text = timesheetData.projectStatus
        workingHrs.text = timesheetData.workingHours
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
