//
//  ViewController.swift
//  taskapp
//
//  Created by 伊藤光次郎 on 2020/09/04.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //try!によってエラーを無視して、realmにRealmインスタンスを代入。
    let realm = try! Realm()
    //taskArrayにRealmのobjectメソッドによってクラスを指定。taskの中にTaskクラスのデータベースを読み込み格納し、sortedによって並び替えてる
    //byKeyPathは引数名でどのような順番でかを決める、ascendingはtrueで昇順、falseで降順。
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath:"date",ascending:true)
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        
    }
    
    //segueで画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputViewController: InputViewController = segue.destination as! InputViewController
        if segue.identifier == "cellSegue"{
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            let task = Task()
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0{
                task.id = allTasks.max(ofProperty:"id")! + 1
            }
            inputViewController.task = task
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //UITableViewDataSourceプロトコルのメソッド。テーブル内に何行並べるか（データ数）を返すメソッド。実装必須
    //データの配列であるtaskArrayの要素数を返すようにする。【済】
    //numberOfRowsInsectionでは一つのセクションに入れるセクション数を返している。今回はセクションとかないから気にせず（大きく1セクション）、その中に何個セル？ってこと
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    //UITableViewDataSourceプロトコルのメソッド。テーブル内の一つ一つの行に対して、どんな内容を表示するかを返すメソッド。実装必須。Cellを取得する。データの配列であるtaskArrayの要素数を返すようにします。【済】
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //dequeueReusableCellメソッド：再利用可能なインスタンス化されたセルを取得。IndexPathはそのプロパティにrowを持っている。indexPathはcellForRowAtで取得しようとしているCellの位置を意味する。
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //タスクをtaskに代入。indexpath.row：Int。taskにはtaskArray
        let task = taskArray[indexPath.row]
        //cellのラベルにtaskのタイトルを代入
        cell.textLabel?.text = task.title
        //Dateをインスタンス化
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateStirng:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateStirng
        
        return cell //appleの技術者の人たちが勝手に戻り値を出力するように作ってくれてる
    }
    
   
    //UITableViewDelegateプロトコルのメソッド。セルをタップしたときにcellSegueでタスク入力画面に遷移させる【済】
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    
    
    //UITableViewDelegateプロトコルのメソッド。セルが削除可能なことを伝える
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    
    //UITableViewDelegateプロトコルのメソッド。Deleteボタンが押された時にローカル通知をキャンセルし、データベースからタスクを削除する。【済】
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
                   // 削除するタスクを取得する
                   let task = self.taskArray[indexPath.row]

                   // ローカル通知をキャンセルする
                   let center = UNUserNotificationCenter.current()
                   center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])

                   // データベースから削除する
                   try! realm.write {
                       self.realm.delete(task)
                       tableView.deleteRows(at: [indexPath], with: .fade)
                   }

                   // 未通知のローカル通知一覧をログ出力
                   center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                       for request in requests {
                           print("/---------------")
                           print(request)
                           print("---------------/")
                       }
                   }
               }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            taskArray = realm.objects(Task.self).sorted(byKeyPath:"date",ascending:true)
        }else {
            taskArray = realm.objects(Task.self).filter("category CONTAINS %@", searchBar.text)
        }
        tableView.reloadData()
        
    }


}

