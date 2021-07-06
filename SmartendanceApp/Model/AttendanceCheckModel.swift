//
//  Login.swift
//  SmartendanceApp
//
//  Created by Ryota Kaneko on 2021/07/03.
//

import Foundation
import Alamofire
import SwiftyJSON

class AttendanceCheck{
    
    //出席情報を格納
    var attendanceDataList: Dictionary<String, String> = [:];
    
    func getAttendanceData(classRoom:String){
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
            
            
        let url = "https://3b7f98a69607.ngrok.io/GitHub/Smartendance/student_attend.php?class_room=\(classRoom)"
        
        //Alamofireを使ってhttpリクエストを投げる。
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON(queue: queue){ (response) in
            
            switch response.result{
            
            case .success:
                let json:JSON = JSON(response.data as Any)
                print("JSONの中身↓")
                print(json)
                if json["resultMsg"].string == nil {
                    self.attendanceDataList.removeValue(forKey: "resultMsg")
                    self.attendanceDataList["classRoomNuber"] = json["classRoomNuber"].string
                    self.attendanceDataList["classSymbol"] = json["classSymbol"].string
                    self.attendanceDataList["subject"] = json["subject"].string
                    self.attendanceDataList["attendTime"] = json["attendTime"].string
                    self.attendanceDataList["UUID"] = json["UUID"].string
                }else {
                    self.attendanceDataList["resultMsg"] = json["resultMsg"].string
                }
                semaphore.signal()
                
//                print(self.userDataList["userId"]!)
//                print(self.userDataList["name"]!)
//                print(self.userDataList["userType"]!)
//                print(self.userDataList["classId"]!)
                
            case .failure(let error):
                self.attendanceDataList["resultMsg"] = String("AFエラー")
                print("AFエラー")
                print(error)
                semaphore.signal()
                
            }
            
        }
        semaphore.wait()
        
        
    }
    
}
