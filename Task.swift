//
//  Task.swift
//  taskapp
//
//  Created by 伊藤光次郎 on 2020/09/07.
//  Copyright © 2020 kojiro.ito. All rights reserved.
//
//モデルクラス
//Realmのライブラリで提供されているObjectクラスを継承してTaskクラスを作成する。
//Taskのインスタンスは、タスクの内容が格納されているもの
import RealmSwift

class  Task: Object {
    //管理用ID。プライマリーキー
    @objc dynamic var id = 0
    
    //タイトル
    @objc dynamic var title = ""
    
    //内容
    @objc dynamic var contents = ""
    
    //日時
    @objc dynamic var date = Date()
    
    //カテゴリ
    @objc dynamic var category = ""
    
    //idをプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
