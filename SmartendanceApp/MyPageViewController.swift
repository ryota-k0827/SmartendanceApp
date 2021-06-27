//
//  MyPageViewController.swift
//  SmartendanceApp
//
//  Created by Ryota Kaneko on 2021/06/28.
//

import UIKit

class MyPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
