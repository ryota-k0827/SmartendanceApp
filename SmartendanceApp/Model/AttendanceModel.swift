//
//  AttendanceModel.swift
//  SmartendanceApp
//
//  Created by Ryota Kaneko on 2021/07/03.
//

import Foundation
import Alamofire
import SwiftyJSON

class Attendance{
    
    //出席情報を格納
    var attendanceDataList: Dictionary<String, String> = [:];
    
    func attendanceProcess(classRoom:String, userId:String, classId:String){
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
            
            
        let url = "https://f4c8-240b-250-1a0-1b10-88ea-1a20-4719-bfde.ngrok.io/Smartendance/student_attend.php?class_room=\(classRoom)&user_id=\(userId)&class_id=\(classId)"
        
        //Alamofireを使ってhttpリクエストを投げる。
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON(queue: queue){ (response) in
            
            switch response.result{
            
            case .success:
                let json:JSON = JSON(response.data as Any)
                print("JSONの中身↓")
                print(json)
                self.attendanceDataList["classRoomNuber"] = json["classRoomNuber"].string
                self.attendanceDataList["classSymbol"] = json["classSymbol"].string
                self.attendanceDataList["subject"] = json["subject"].string
                self.attendanceDataList["attendTime"] = json["attendTime"].string
                self.attendanceDataList["status"] = json["status"].string
                self.attendanceDataList["resultMsg"] = json["resultMsg"].string
                semaphore.signal()
                
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
