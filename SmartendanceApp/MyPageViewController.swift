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
    
    var userIdText = ""
    var nameText = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("yutayuta")
        print(userIdText)
        idLabel.text = userIdText
        nameLabel.text = nameText
        // Do any additional setup after loading the view.
    }
    

    //前の画面戻る
    @IBAction func logout(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //出席確認ボタン
    @IBAction func attendanceCheck(_ sender: Any) {
        //教官画面遷移
        if userIdText == "teacher" {
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
    
    //画面遷移で値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        //出席確認ボタン押した時（教官）
        if segue.identifier == "nextRoomSelectWithTeacher" {
            let nextVC = segue.destination as! RoomSelectWithTeacherViewController
            nextVC.userIdText = userIdText
            nextVC.nameText = nameText
        }
        //（生徒）
        else if segue.identifier == "nextRoomSelect" {
            let nextVC = segue.destination as! RoomSelectViewController
            nextVC.userIdText = userIdText
            nextVC.nameText = nameText
        }
        //成績照会ボタン押した時
        else if segue.identifier == "nextResultPage" {
            let nextVC = segue.destination as! ResultViewController
            nextVC.userIdText = userIdText
            nextVC.nameText = nameText
        }
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
