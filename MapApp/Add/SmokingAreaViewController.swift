//
//  SmokingAreaViewController.swift
//  MapApp
//
//  Created by 桑原佑輔 on 2021/05/16.
//

import UIKit

class SmokingAreaViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    let smokingAreaLabel = ["全面喫煙可能店","居酒屋・レストラン・カフェ等","バー・スナック・シガーバー等","喫煙専用室設置店"]
    let smokingAreaDescription = ["喫煙専用室","喫煙可能店","喫煙目的店","喫煙専用室"]
    let smokingAreaImage = ["喫煙専用室","喫煙可能店","喫煙目的店","喫煙専用室"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil),forCellReuseIdentifier:"TableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    } //セルを何個返すかの関数
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.smokingAreaLabel.text = smokingAreaLabel[indexPath.row]
        cell.smokingAreaDiscription.text = smokingAreaDescription[indexPath.row]
        cell.smokingAreaImage.image = UIImage(named: smokingAreaImage[indexPath.row])
        return cell
        
    } //セルに対してどのようなものを返すかの関数
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        self.dismiss(animated: true, completion: nil)
    } //タップしたindexPath.rowを返す
    
    
    
}

