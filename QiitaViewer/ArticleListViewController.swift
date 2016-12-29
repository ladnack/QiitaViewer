//
//  ArticleListViewController.swift
//  QiitaViewer
//
//  Created by 酒井恭平 on 2016/12/23.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ArticleListViewController: UIViewController {

    let table = UITableView() // プロパティにtableを追加
    var articles: [[String: String?]] = [] // 記事を入れるプロパティを定義
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新着記事" // Navigation Barのタイトルを設定
        
        table.frame = view.frame // tableの大きさをviewの大きさに合わせる
        view.addSubview(table) // viewにtableを乗せる
        
        table.dataSource = self
        
        getArticles()
    }
    
    func getArticles() {
//        Alamofire.request("https://qiita.com/api/v2/items", method: .get) // APIへリクエストを送信
        Alamofire.request("https://qiita.com/api/v2/items") // method defaults to `.get`
            .responseJSON { response in
//                print(response.result.value ?? "nil") // responseのresultプロパティのvalueプロパティをコンソールに出力
                guard let object = response.result.value else {
                    return
                }
                
                let json = JSON(object)
                json.forEach { (_, json) in
                    let article: [String: String?] = [
                        "title": json["title"].string,
                        "userId": json["user"]["id"].string
                    ] // 1つの記事を表す辞書型を作る
                    self.articles.append(article) // 配列に入れる
                }
//                print(self.articles) // 全ての記事が保存出来たら配列を確認
                self.table.reloadData() // TableViewを更新
            }
        
        
    }

}


extension ArticleListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell") // Subtitleのあるセルを生成
        let article = articles[indexPath.row] // 行数番目の記事を取得
        cell.textLabel?.text = article["title"]! // 記事のタイトルをtextLabelにセット
        cell.detailTextLabel?.text = article["userId"]! // 投稿者のユーザーIDをdetailTextLabelにセット
        return cell // cellを返す
    }
    
}






