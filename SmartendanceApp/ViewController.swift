//
//  ViewController.swift
//  SmartendanceApp
//
//  Created by Ryota Kaneko on 2021/06/27.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var pasword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userId.delegate = self
        pasword.delegate = self
    }

    
    @IBAction func login(_ sender: Any) {
        
        if let text = userId.text, text.isEmpty {
            //空白処理
            print("ユーザIDが空白")
        }
        else if let text = pasword.text, text.isEmpty {
            //空白処理
            print("パスワードが空白")
        }
        else {
            print("ユーザID：\(String(describing: userId.text))")
            print("パスワード：\(String(describing: pasword.text))")
            //画面遷移
            performSegue(withIdentifier: "nextMyPage", sender: nil)
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

        let nextVC = segue.destination as! MyPageViewController
        let userIdText: String? = userId.text
        nextVC.userIdText = userIdText!
    }
    
}

