//
//  UuidCheckModel.swift
//  SmartendanceApp
//
//  Created by Ryota Kaneko on 2021/07/03.
//

import Foundation
import Alamofire
import SwiftyJSON

class UuidCheck{
    
    //出席情報を格納
    var BeaconUuid = String()
    var resultMsg = ""
    
    func getUid(classRoom:String, userId:String, classId:String){
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .utility)
            
            
        let url = "http://ryotakaneko.php.xdomain.jp/Smartendance/class_select.php?class_room=\(classRoom)&user_id=\(userId)&class_id=\(classId)"
        
        //Alamofireを使ってhttpリクエストを投げる。
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON(queue: queue){ (response) in
            
            switch response.result{
            
            case .success:
                let json:JSON = JSON(response.data as Any)
                print("JSONの中身↓")
                print(json)
                if json["resultMsg"].string == nil {
                    self.resultMsg = ""
                    self.BeaconUuid = json["UUID"].string!
                }else {
                    self.resultMsg = json["resultMsg"].string!
                }
                semaphore.signal()
                
            case .failure(let error):
                self.resultMsg = "AFエラー"
                print("AFエラー")
                print(error)
                semaphore.signal()
                
            }
            
        }
        semaphore.wait()
        
        
    }
    
}
