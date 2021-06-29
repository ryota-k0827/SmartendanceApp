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
    
    
    var userIdText = ""
    var nameText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roomNumber.delegate = self
        
        idLabel.text = userIdText
        nameLabel.text = nameText
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
        nextVC.userIdText = userIdText
        nextVC.nameText = nameText
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
