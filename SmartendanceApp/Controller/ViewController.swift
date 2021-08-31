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
        //ログイン済み
        if UserDefaults.standard.object(forKey: "userId") != nil {
            //画面遷移
            performSegue(withIdentifier: "nextMyPage", sender: nil)
        }
        //初回起動
        else {
            super.viewDidLoad()
            loginButtonOutlet.layer.cornerRadius = 10.0
            
            userId.delegate = self
            pasword.delegate = self
        }
    }

    
    @IBAction func login(_ sender: Any) {
        
        //ユーザIDが空白
        if let text = userId.text, text.isEmpty {
            //アラートを表示
            let dialog = UIAlertController(title: "エラー", message: "ユーザIDを入力してください。", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
        }
        //パスワードが空白
        else if let text = pasword.text, text.isEmpty {
            //アラートを表示
            let dialog = UIAlertController(title: "エラー", message: "パスワードを入力してください。", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
        }
        else {
            loginModel.getUserData(userId: String(userId.text!), password: String(pasword.text!))
            //ログイン成功
            if loginModel.resultMsg == "ログイン成功" {
                //画面遷移
                performSegue(withIdentifier: "nextMyPage", sender: nil)
            }
            //ログイン失敗
            else {
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

