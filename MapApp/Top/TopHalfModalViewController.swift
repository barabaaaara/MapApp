//
//  TopHalfModalViewController.swift
//  MapApp
//
//  Created by 桑原佑輔 on 2021/02/27.
//

import UIKit

class TopHalfModalViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var decideBotton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.layer.cornerRadius = 16.0
        decideBotton.layer.cornerRadius = 16.0
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.systemBlue.cgColor

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
