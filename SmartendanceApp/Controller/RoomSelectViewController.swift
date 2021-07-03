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
    
    
    var userDataList: Dictionary<String, String> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roomNumber.delegate = self
        
        idLabel.text = userDataList["userId"]
        nameLabel.text = userDataList["name"]
    }
    
    //出席ボタン
    @IBAction func attendance(_ sender: Any) {
        if let text = roomNumber.text, text.isEmpty {
            print("教室番号が空白")
            //空白処理
        }
        else {
            print("教室番号：\(String(describing: roomNumber.text))")
            //画面遷移
            performSegue(withIdentifier: "nextAttendanceComplete", sender: nil)
        }
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

        let nextVC = segue.destination as! AttendanceCompleteViewController
        nextVC.userDataList = userDataList
        //教室番号を受け渡し↓
        let roomNunberText: String? = roomNumber.text
        nextVC.roomNumberText = roomNunberText!
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
