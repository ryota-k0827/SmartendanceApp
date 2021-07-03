//
//  ResultViewController.swift
//  SmartendanceApp
//
//  Created by Ryota Kaneko on 2021/06/28.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var userDataList: Dictionary<String, String> = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        idLabel.text = userDataList["userId"]
        nameLabel.text = userDataList["name"]

        // Do any additional setup after loading the view.
    }
    
//    @IBAction func ResultAction(_ sender: Any) {
//        //nextResultPage
//        performSegue(withIdentifier: "nextResultPage", sender: nil)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
