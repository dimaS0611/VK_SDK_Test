//
//  ViewController.swift
//  VK_NewsFeed
//
//  Created by Dzmitry Semenovich on 18.06.21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stroryboard = UIStoryboard(name: "Tabbar", bundle: nil)
        let vc = stroryboard.instantiateViewController(identifier: "Tabbar")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }


}

