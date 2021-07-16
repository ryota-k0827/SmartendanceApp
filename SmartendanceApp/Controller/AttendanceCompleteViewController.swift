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
    
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var resultMsgLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var classSymbolLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var attendTimeLabel: UILabel!
    
    
    @IBOutlet weak var myPageButtonOutlet: UIButton!
    
    
    var attendanceDataList: Dictionary<String, String> = [:]
    //var roomNumberText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPageButtonOutlet.layer.cornerRadius = 10.0
        
        print(attendanceDataList)
        idLabel.text = (UserDefaults.standard.object(forKey: "userId") as! String)
        nameLabel.text = (UserDefaults.standard.object(forKey: "name") as! String)
        
        statusLabel.text = attendanceDataList["status"]
        resultMsgLabel.text = attendanceDataList["resultMsg"]
        roomLabel.text = attendanceDataList["classRoomNuber"]
        classSymbolLabel.text = attendanceDataList["classSymbol"]
        subjectLabel.text = attendanceDataList["subject"]
        attendTimeLabel.text = attendanceDataList["attendTime"]

        // Do any additional setup after loading the view.
    }
    
    @IBAction func myPageButtom(_ sender: Any) {
        //画面遷移
        performSegue(withIdentifier: "backMyPage", sender: nil)
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
