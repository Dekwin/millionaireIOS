//
//  SingleGame.swift
//  Millionaire
//
//  Created by Igor Kasyanenko on 22.04.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation

class SingleGame: Game {
    let singlePlayController:ISinglePlay;
    var questions:[Question];
    
    var timer:NSTimer = NSTimer();
    var timerCounter:Int = 0;
    var maxScoreInTable:Double = 1000000;
    var currentQuestionPosition:Int = 0;
    
    init(singlePlayController:ISinglePlay){
        self.singlePlayController = singlePlayController;
       questions = Question.getAll()
    }
    
    func start()->Bool {
        if (questions.count==0) {
           questions = Question.getAll()
        }
        if(questions.count>0){
            currentQuestionPosition = -1;
            singlePlayController.initScoreTable(questions);
            singlePlayController.setScoreTablePosition(questions.count);
          //  singlePlayController.initQuestion(questions[currentQuestionPosition]);
            nextQuestion();
        }else{
            return false;
        }
        return true;
    }
    
    func getQuestions() -> [Question] {
        return questions;
    }
    
    func getProgressionValue(n:Double) -> Double {
        let q = 2.0;
        let a1:Double = maxScoreInTable/pow(q,(Double(questions.count)-1));
        return a1*pow(q,n-1);
    }
    
    func getScoreForPositionInScoreTable(position:Int) -> Double {
        return getProgressionValue(Double(questions.count-position));
    }

    func setTimer()  {
        timerCounter=60;
        singlePlayController.setTime(timerCounter);
        timer.invalidate();
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true);
    }
    
    @objc func updateTime(timer:NSTimer)  {
        timerCounter-=1;
        singlePlayController.setTime(timerCounter);
       // print(timerCounter)
        if (timerCounter <= 0) {
            timer.invalidate();
            //time left
            singlePlayController.gameFinished("Finish",
                                              message: "Time left!\nRetry?",
                                              yesHandler: { action in
                                               // self.singlePlayController.exit();
                                                self.start();
                },
                                              noHandler: { action in
                                                self.singlePlayController.exit();
            });
        }
    }
    
    func answerTouched(answerNumber:Int) {
        checkAnswer(answerNumber);
    }
    
    func checkAnswer(answerNumber: Int) {
       if(currentQuestionPosition <= questions.count-1){
        if(Int(questions[currentQuestionPosition].trueAnswer) == answerNumber){
            
            
             singlePlayController.setScoreTablePosition(questions.count-currentQuestionPosition-1);
            if(currentQuestionPosition < questions.count-1){
                nextQuestion();
                
            }else{
                //successful finish
                timer.invalidate();
                singlePlayController.gameFinished("Finish", message: "Game finished, you won 1000000!\nRetry?", yesHandler: { action in
                    //self.singlePlayController.exit();
                    self.start();
                    }, noHandler: { action in
                        self.singlePlayController.exit();
                });
                
            }
        }else{
            //unsuccessful finish
            timer.invalidate();
            singlePlayController.gameFinished("Finish", message:
                "Wrong answer \(answerNumber), right is \(questions[currentQuestionPosition].trueAnswer)!\nRetry?", yesHandler: { action in
                self.start();
                //self.singlePlayController.exit();
                }, noHandler: { action in
                    self.singlePlayController.exit();
            });
        }
        
       }else{
        
        }
    }
    
    func nextQuestion() {
        currentQuestionPosition+=1;
         setTimer();
        singlePlayController.initQuestion(questions[currentQuestionPosition]);
       
        
    }
    
}