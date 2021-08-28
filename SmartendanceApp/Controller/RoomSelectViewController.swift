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
    
    @IBOutlet weak var attendButton: UIButton!
    @IBOutlet weak var myPageButtonOutlet: UIButton!
    
    var attendanceModel = Attendance()
    var beaconModel = UuidCheck()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attendButton.layer.cornerRadius = 10.0
        myPageButtonOutlet.layer.cornerRadius = 10.0

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
            beaconModel.getUid(classRoom: String(roomNumber.text!), userId: (UserDefaults.standard.object(forKey: "userId") as! String), classId: (UserDefaults.standard.object(forKey: "classId") as! String))
            if beaconModel.resultMsg == "" {
                print("教室番号：\(String(describing: roomNumber.text))")
                //画面遷移
                performSegue(withIdentifier: "nextBeaconSearch", sender: nil)
            } else {
                print(beaconModel.resultMsg)
                //アラートを表示
                let dialog = UIAlertController(title: "エラー", message: beaconModel.resultMsg, preferredStyle: .alert)
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
        if segue.identifier == "nextBeaconSearch" {
            let nextVC = segue.destination as! BeaconSearchViewController
            //教室番号を受け渡し↓
            let roomNunberText: String? = roomNumber.text
            nextVC.roomNumberText = roomNunberText!
            nextVC.beaconUUID = beaconModel.BeaconUuid
        }
    }

}
