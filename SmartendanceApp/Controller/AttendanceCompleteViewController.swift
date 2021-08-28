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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ボタンを丸くする
        myPageButtonOutlet.layer.cornerRadius = 10.0
        
        //ユーザ情報をラベルに代入
        idLabel.text = (UserDefaults.standard.object(forKey: "userId") as! String)
        nameLabel.text = (UserDefaults.standard.object(forKey: "name") as! String)
        
        //取得情報をラベルに代入
        statusLabel.text = attendanceDataList["status"]
        resultMsgLabel.text = attendanceDataList["resultMsg"]
        roomLabel.text = attendanceDataList["classRoomNuber"]
        classSymbolLabel.text = attendanceDataList["classSymbol"]
        subjectLabel.text = attendanceDataList["subject"]
        attendTimeLabel.text = attendanceDataList["attendTime"]
    }
    
    @IBAction func myPageButtom(_ sender: Any) {
        //画面遷移
        performSegue(withIdentifier: "backMyPage", sender: nil)
    }

}
