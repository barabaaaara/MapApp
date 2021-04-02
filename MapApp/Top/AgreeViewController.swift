//
//  AgreeViewController.swift
//  MapApp
//
//  Created by 桑原佑輔 on 2021/03/27.
//

import UIKit

class AgreeViewController: UIViewController {
    
    //同意ボタンをタップするとユーザーデフォルトを使用する
    @IBAction func agreeBottunTapped(_ sender: Any) {
        UserDefaults.standard.setValue(true, forKey: "agreeBefore")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func termTapped(_ sender: Any) {
        let vc = UINavigationController(rootViewController: TermViewController())
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
