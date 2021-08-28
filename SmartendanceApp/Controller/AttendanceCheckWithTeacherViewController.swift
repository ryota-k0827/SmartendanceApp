//
//  AttendanceCheckWithTeacherViewController.swift
//  SmartendanceApp
//
//  Created by Ryota Kaneko on 2021/06/28.
//

import UIKit

class AttendanceCheckWithTeacherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var roomNumLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var countPeopleLabel: UILabel!
    
    //TableView
    @IBOutlet weak var absenceTableView: UITableView!
    
    
    @IBOutlet weak var myPageButtonOutlet: UIButton!
    
    //出席情報を格納
    var attendDataList: Dictionary<String, String> = [:]
    var absenceNumber: [String] = []
    var absenceName: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        absenceTableView.delegate = self
        absenceTableView.dataSource = self
        
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
    
    //セクションの中のセルの数を確認
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //欠席者の数分
        return absenceNumber.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.selectionStyle = .none
        //textLabel?=オプショナルチェイニング（変数が存在しなくても自動でpassする）
        cell.textLabel?.text = absenceNumber[indexPath.row] + " " + absenceName[indexPath.row]
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return view.frame.size.height/6
//    }

}
