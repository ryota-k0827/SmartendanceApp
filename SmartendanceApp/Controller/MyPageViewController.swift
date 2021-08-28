//
//  MyPageViewController.swift
//  SmartendanceApp
//
//  Created by Ryota Kaneko on 2021/06/28.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var attendButton: UIButton!
    
    var userType = (UserDefaults.standard.object(forKey: "userType") as! String)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        attendButton.layer.cornerRadius = 10.0
        
        idLabel.text = (UserDefaults.standard.object(forKey: "userId") as! String)
        nameLabel.text = (UserDefaults.standard.object(forKey: "name") as! String)
    }
    
    //出席確認ボタン
    @IBAction func attendanceCheck(_ sender: Any) {
        //教官画面遷移
        if userType == "instructor" {
            performSegue(withIdentifier: "nextRoomSelectWithTeacher", sender: nil)
        }
        //生徒画面推移
        else {
            performSegue(withIdentifier: "nextRoomSelect", sender: nil)
        }
    }

}
