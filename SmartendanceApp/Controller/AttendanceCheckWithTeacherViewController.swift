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
    @IBOutlet weak var countPeopleLabel: UILabel!
    
    
    @IBOutlet weak var myPageButtonOutlet: UIButton!
    
    var attendDataList: Dictionary<String, String> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(attendDataList)
        
        myPageButtonOutlet.layer.cornerRadius = 10.0
        
        idLabel.text = (UserDefaults.standard.object(forKey: "userId") as! String)
        nameLabel.text = (UserDefaults.standard.object(forKey: "name") as! String)
        
        roomNumLabel.text = attendDataList["classRoomNumber"]
        classLabel.text = attendDataList["classSymbol"]
        subjectLabel.text = attendDataList["subject"]
        countPeopleLabel.text = attendDataList["number_of_attendees"]! + "/" + attendDataList["class_size"]!

        // Do any additional setup after loading the view.
    }
    
    //マイページボタン
    @IBAction func myPageButton(_ sender: Any) {
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
