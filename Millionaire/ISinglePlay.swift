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
    
    func lockInterface();
    func unlockInterface();
    func triggerAnimation(_ rightAnswer:Int, answer: Int,answerAnimationTicks:Int);
    
    func disableAnswers(_ answers:[Int]);
    
    func setScoreTablePosition(_ position: Int);
    func gameFinished(_ title: String, message: String, yesHandler:@escaping(_ action: UIAlertAction)->Void,noHandler:@escaping(_ action: UIAlertAction)->Void);
    func initScoreTable(_ questions:[Question]);
    func initQuestion(_ question:Question);
    func setTime(_ timeLeft:Int);
    func exit();
    
    
    
}
