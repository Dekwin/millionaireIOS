//
//  Game.swift
//  Millionaire
//
//  Created by Igor Kasyanenko on 22.04.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
protocol Game {
    func start()->Bool;
    func getQuestions() -> [Question];
    func answerTouched(_ answerNumber:Int);
    func getScoreForPositionInScoreTable(_ position:Int) -> Double ;
    func getCurrentQuestion() -> Question?;
    
    func fiftyFiftyTouched();
    func callFriendTouched();
    func audienceHelpTouched();
}
