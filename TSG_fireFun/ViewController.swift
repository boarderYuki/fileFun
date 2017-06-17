//
//  ViewController.swift
//  TSG_fireFun
//
//  Created by yuki.pro on 2017. 6. 4..
//  Copyright © 2017년 yuki. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userID: UITextField!
    @IBOutlet weak var userPW: UITextField!
    @IBOutlet weak var myTableView: UITableView!
    
    var myList : [String] = []
    //var handle : DatabaseHandle?
    var ref:DatabaseReference?
    
    
    @IBAction func saveBtn(_ sender: UIButton) {
        
        
        //데이터베이스에 아이템 저장
        if userID.text != "" && userPW.text != "" {
            
            isRegistered()

        } else if userID.text == "" {
            let dialog = UIAlertController(title: "실패", message: "아이디를 입력하세요.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            dialog.addAction(action)
            self.present(dialog, animated: true, completion: nil)
            
            print("등록불가")
        } else if userPW.text == "" {
            let dialog = UIAlertController(title: "실패", message: "패스워드를 입력하세요.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            dialog.addAction(action)
            self.present(dialog, animated: true, completion: nil)
            
            print("등록불가")
        }
    }
    
    
    // 테이블뷰 셋팅
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = myList[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        //handle = ref?.child("userIDs").observe(.childAdded, with: { (snapshot) in
        ref?.child("userIDs").observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? String {
                //print("item-----------------------------")
                self.myList.append(item)
                self.myTableView.reloadData()
            }
        })
    }

    
    func isRegistered() {

        //var recentPostsRef = firebase.database().ref('posts').limitToLast(100);
        ref?.child("userIDs").observeSingleEvent(of: .value, with: { (snapshot) in
            //let key = snapshot.key
            
            if snapshot.value is NSNull {
                
                self.ref?.child("users").childByAutoId().setValue(["userID" : self.userID.text, "userPW" : self.userPW.text])
                self.ref?.child("userIDs").child(self.userID.text!).setValue(self.userID.text)
                self.userID.text = ""
                self.userPW.text = ""
                self.success()
                
                print("등록완료1")

            } else {
            
            
            
            if let snapshot = snapshot.value as? [String : String] {
                let userIDs = [String](snapshot.values)
                
                if !userIDs.contains(self.userID.text!) || userIDs.isEmpty {
                    
                    self.ref?.child("users").childByAutoId().setValue(["userID" : self.userID.text, "userPW" : self.userPW.text])
                    self.ref?.child("userIDs").child(self.userID.text!).setValue(self.userID.text)
                    self.userID.text = ""
                    self.userPW.text = ""
                    self.success()
                    
                    print("등록완료2")
                    
                    
                } else {
                    self.userID.text = ""
                    self.userPW.text = ""
                    
                    let dialog = UIAlertController(title: "실패", message: "이미 등록된 ID", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                    dialog.addAction(action)
                    self.present(dialog, animated: true, completion: nil)
                    
                    print("등록불가")
                }
                }}
        }, withCancel: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func success() {
        let dialog = UIAlertController(title: "성공", message: "ID 등록 성공", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        dialog.addAction(action)
        self.present(dialog, animated: true, completion: nil)
    }

}

