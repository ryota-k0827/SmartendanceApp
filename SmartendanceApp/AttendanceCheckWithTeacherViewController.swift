//
//  AttendanceCheckWithTeacherViewController.swift
//  SmartendanceApp
//
//  Created by Ryota Kaneko on 2021/06/28.
//

import UIKit

class AttendanceCheckWithTeacherViewController: UIViewController {

    
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var roomNumLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var userIdText = ""
    var nameText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idLabel.text = userIdText
        nameLabel.text = nameText

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
