//
//  ViewController.swift
//  Millionaire
//
//  Created by Igor Kasyanenko on 17.04.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import UIKit
//import SHA256iOs

//import CommonCrypto



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad();
     //   Question.deleteAll();
       // DataProvider.setLocalSyncDate(0)

        //DataProvider.setLocalSyncDate(0)
       //  Question.deleteAll()
        
        
        DataProvider.synchronize(){result in print(result)};
        
      //  print("hash: \("")")
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }


}

