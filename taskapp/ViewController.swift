//
//  ViewController.swift
//  taskapp
//
//  Created by 伊藤光次郎 on 2020/09/04.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    //UITableViewDataSourceプロトコルのメソッド。テーブル内に何行並べるか（データ数）を返すメソッド。実装必須
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    //UITableViewDataSourceプロトコルのメソッド。テーブル内の一つ一つの行に対して、どんな内容を表示するかを返すメソッド。実装必須。Cellを取得する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
         return cell
    }
    
   
    //UITableViewDelegateプロトコルのメソッド。セルをタップしたときにタスク入力画面に遷移させる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    //UITableViewDelegateプロトコルのメソッド。セルが削除可能なことを伝える
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    //UITableViewDelegateプロトコルのメソッド。Deleteボタンが押された時にローカル通知をキャンセルし、データベースからタスクを削除する。
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }


}

