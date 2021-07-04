//
//  RoomSelectViewController.swift
//  SmartendanceApp
//
//  Created by Ryota Kaneko on 2021/06/28.
//

import UIKit

class RoomSelectViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var roomNumber: UITextField!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var attendanceModel = Attendance()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roomNumber.delegate = self
        
        idLabel.text = (UserDefaults.standard.object(forKey: "userId") as! String)
        nameLabel.text = (UserDefaults.standard.object(forKey: "name") as! String)
    }
    
    //出席ボタン
    @IBAction func attendance(_ sender: Any) {
        if let text = roomNumber.text, text.isEmpty {
            //空白処理
            print("教室番号が空白")
            //アラートを表示
            let dialog = UIAlertController(title: "エラー", message: "教室番号を入力してください。", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
            
        }
        else {
            attendanceModel.getUid(classRoom: String(roomNumber.text!))
            if attendanceModel.attendanceDataList["resultMsg"] == nil {
                print("教室番号：\(String(describing: roomNumber.text))")
                //画面遷移
                performSegue(withIdentifier: "nextAttendanceComplete", sender: nil)
            } else {
                print(attendanceModel.attendanceDataList["resultMsg"]!)
                //アラートを表示
                let dialog = UIAlertController(title: "エラー", message: attendanceModel.attendanceDataList["resultMsg"]!, preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
                self.present(dialog, animated: true, completion: nil)
                
            }
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

        if segue.identifier == "nextAttendanceComplete" {
            let nextVC = segue.destination as! AttendanceCompleteViewController
            //教室番号を受け渡し↓
    //        let roomNunberText: String? = roomNumber.text
    //        nextVC.roomNumberText = roomNunberText!
            
            nextVC.attendanceDataList = attendanceModel.attendanceDataList
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
