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
    @IBOutlet weak var resultButton: UIButton!
    
    var userType = (UserDefaults.standard.object(forKey: "userType") as! String)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attendButton.layer.cornerRadius = 10.0
        resultButton.layer.cornerRadius = 10.0
        
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
    
    //成績照会ボタン
    @IBAction func nextResultPage(_ sender: Any) {
        performSegue(withIdentifier: "nextResultPage", sender: nil)
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
