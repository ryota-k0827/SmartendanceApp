//
//  AttendanceCompleteViewController.swift
//  SmartendanceApp
//
//  Created by Ryota Kaneko on 2021/06/28.
//

import UIKit

class AttendanceCompleteViewController: UIViewController {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    
    var userDataList: Dictionary<String, String> = [:]
    var roomNumberText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idLabel.text = userDataList["userId"]
        nameLabel.text = userDataList["name"]
        roomLabel.text = roomNumberText

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
