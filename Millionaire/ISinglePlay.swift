//
//  PlayController.swift
//  Millionaire
//
//  Created by Igor Kasyanenko on 22.04.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import UIKit

protocol ISinglePlay {
    func setScoreTablePosition(position: Int);
    func gameFinished(title: String, message: String, yesHandler:(action: UIAlertAction)->Void,noHandler:(action: UIAlertAction)->Void);
    func initScoreTable(questions:[Question]);
    func initQuestion(question:Question);
    func setTime(timeLeft:Int);
    func exit();
    
}