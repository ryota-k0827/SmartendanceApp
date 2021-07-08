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
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    
    var loginModel = Login()
    
    override func viewDidAppear(_ animated:Bool) {
        if UserDefaults.standard.object(forKey: "userId") != nil {
            print("ログイン済み")
            //画面遷移
            performSegue(withIdentifier: "nextMyPage", sender: nil)
        }else {
            print("初回起動です。")
            super.viewDidLoad()
            loginButtonOutlet.layer.cornerRadius = 10.0
            
            userId.delegate = self
            pasword.delegate = self
        }
    }

    
    @IBAction func login(_ sender: Any) {
        
        if let text = userId.text, text.isEmpty {
            //空白処理
            print("ユーザIDが空白")
            //アラートを表示
            let dialog = UIAlertController(title: "エラー", message: "ユーザIDが空白です。", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
        }
        else if let text = pasword.text, text.isEmpty {
            //空白処理
            print("パスワードが空白")
            //アラートを表示
            let dialog = UIAlertController(title: "エラー", message: "パスワードが空白です。", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
        }
        else {
            print("ユーザID：\(String(userId.text!))")
            print("パスワード：\(String(pasword.text!))")
            
            loginModel.getUserData(userId: String(userId.text!), password: String(pasword.text!))
            if loginModel.resultMsg == "ログイン成功" {
                //画面遷移
                performSegue(withIdentifier: "nextMyPage", sender: nil)
            } else {
                print("ログイン失敗")
                //アラートを表示
                let dialog = UIAlertController(title: "エラー", message: "ユーザIDもしくはパスワードが正しくありません。", preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
                self.present(dialog, animated: true, completion: nil)
            }
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
    
}

