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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("yutayuta")
        print(userIdText)
        idLabel.text = userIdText
        // Do any additional setup after loading the view.
    }
    

    //前の画面戻る
    @IBAction func logout(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //出席確認ボタン
    @IBAction func attendanceCheck(_ sender: Any) {
        //画面遷移
        performSegue(withIdentifier: "nextRoomSelect", sender: nil)
        
        //教官画面推移
        //performSegue(withIdentifier: "nextRoomSelectWithTeacher", sender: nil)
    }
    
    //画面遷移で値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let nextVC = segue.destination as! RoomSelectViewController
        nextVC.userIdText = userIdText
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
