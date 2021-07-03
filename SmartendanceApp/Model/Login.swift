//
//  Login.swift
//  SmartendanceApp
//
//  Created by Ryota Kaneko on 2021/07/03.
//

import Foundation
import Alamofire
import SwiftyJSON

class Login{
    //ログイン情報を格納
    var userDataList: Dictionary<String, String> = ["userId":"", "name":"", "userType":"", "classId":""]
    
    func getUserData(userId:String, password:String){
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .utility)
//        let url = "http://192.168.11.42/GitHub/Smartendance/login.php"
//        let headers: HTTPHeaders = [
//                    "Contenttype": "application/json"
//                ]
//        let parameters = ["userId": userId, "password": password]
//
//        //Alamofireを使ってhttpリクエストを投げる。
//        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{ (response) in
            
            
        let url = "http://localhost/GitHub/Smartendance/login.php?userId=\(userId)&password=\(password)"
        
        //Alamofireを使ってhttpリクエストを投げる。
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON(queue: queue){ (response) in
            
            switch response.result{
            
            case .success:
                let json:JSON = JSON(response.data as Any)
                print("JSONの中身↓")
                print(json)
                if json["result"].string == nil {
                    self.userDataList["userId"] = json["userId"].string
                    self.userDataList["name"] = json["name"].string
                    self.userDataList["userType"] = json["type"].string
                    self.userDataList["classId"] = json["classId"].string
                }
                semaphore.signal()
                
//                print(self.userDataList["userId"]!)
//                print(self.userDataList["name"]!)
//                print(self.userDataList["userType"]!)
//                print(self.userDataList["classId"]!)
                
            case .failure(let error):
                print("AFエラー")
                print(error)
                
            }
            
        }
        semaphore.wait()
        
        
    }
    
}
