//
//  RoomSelectWithTeacherViewController.swift
//  SmartendanceApp
//
//  Created by Ryota Kaneko on 2021/06/28.
//

import UIKit

class RoomSelectWithTeacherViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var roomNumberWithTeacher: UITextField!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var attendanceCheckModel = AttendanceCheck()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roomNumberWithTeacher.delegate = self
        
        idLabel.text = (UserDefaults.standard.object(forKey: "userId") as! String)
        nameLabel.text = (UserDefaults.standard.object(forKey: "name") as! String)
    }
    
    @IBAction func attendanceCheckWithTeacher(_ sender: Any) {
        if let text = roomNumberWithTeacher.text, text.isEmpty {
            //空白処理
            print("教室番号が空白")
        }
        else {
            print("教室番号：\(String(describing: roomNumberWithTeacher.text))")
            //画面遷移
            performSegue(withIdentifier: "nextAttendanceCheckWithTeacher", sender: nil)
        }
    }
    
    //マイページボタン
    @IBAction func myPageButton(_ sender: Any) {
        //画面遷移
        performSegue(withIdentifier: "backMyPage", sender: nil)
    }
    
    
    //タップでキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //returnキーでキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //画面遷移で値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "nextAttendanceCheckWithTeacher" {
            let nextVC = segue.destination as! AttendanceCheckWithTeacherViewController
            nextVC.userDataList = attendanceCheckModel.attendanceDataList
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
