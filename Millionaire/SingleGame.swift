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
    
    var useAnimation:Bool = true;
    
    
    var fiftyFiftyHintUsed:Bool = false;
    var callFriendHintUsed:Bool = false;
    var audienceHelpHintUsed:Bool = false;
    
    
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
            singlePlayController.gameFinished(NSLocalizedString("TITLE_GAME_FINISHED", comment: "game over title"),
                                              message: NSLocalizedString("MESSAGE_GAME_FINISHED_TIME", comment: "game over time"),
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
        if(useAnimation){
        highlightAnswer(answerNumber);
        }else{
        checkAnswer(answerNumber);
        }
    }

        
    func getCurrentQuestion() -> Question? {
        if(currentQuestionPosition <= questions.count-1){
            return questions[currentQuestionPosition]
        }else{
            return nil;
        }
        
    }
    
    
    var answerAnimationTimer = NSTimer();
    var answerAnimationTicks:Int = 0;
    
    func highlightAnswer(touchedAnswer: Int) {
        guard let rightAnswer = getCurrentQuestion()?.trueAnswer else {
            return;
        }
        timer.invalidate();
       // self.view.userInteractionEnabled = false;
        var answers:[Int] = [Int(rightAnswer)];
        answers.append(touchedAnswer);
        answerAnimationTicks = 0;
        answerAnimationTimer.invalidate();
      //  getTouchedButton(touchedAnswer).selected = true;
        singlePlayController.lockInterface();
        singlePlayController.triggerAnimation(Int(rightAnswer), answer: touchedAnswer, answerAnimationTicks: 0);
        
        answerAnimationTimer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: #selector(answerAnimationTrigger), userInfo: touchedAnswer, repeats: true);
    }

    @objc func answerAnimationTrigger(timer: NSTimer){
        let touchedAnswer = timer.userInfo as! Int;
        if(currentQuestionPosition <= questions.count-1){
            answerAnimationTicks+=1;
            singlePlayController.triggerAnimation(Int(questions[currentQuestionPosition].trueAnswer),answer: touchedAnswer,answerAnimationTicks: answerAnimationTicks);
            if(answerAnimationTicks>10){
                answerAnimationTimer.invalidate();
                checkAnswer(touchedAnswer);
                 singlePlayController.unlockInterface();
            }
            
        }
    }
    
    
    func fiftyFiftyTouched(){
        
        guard let currentQuestionRightAnswer = getCurrentQuestion()?.trueAnswer else {
            return;
        }
        
        if(!fiftyFiftyHintUsed){
        singlePlayController.disableAnswers(getRandomWithExclusion(1,end: 1,exclude: Int(currentQuestionRightAnswer)));
            fiftyFiftyHintUsed = true;
        }
        
        
    }
    func callFriendTouched(){
        
    }
    func audienceHelpTouched(){
        
    }
    
    func checkHints()  {
        if(fiftyFiftyHintUsed){
            singlePlayController.disableAnswers([]);
        }
    }
    
    
    
    func checkAnswer(answerNumber: Int) {
        
       if(currentQuestionPosition <= questions.count-1){
        
        //hints
        checkHints();
        
        if(Int(questions[currentQuestionPosition].trueAnswer) == answerNumber){
            
            
             singlePlayController.setScoreTablePosition(questions.count-currentQuestionPosition-1);
            if(currentQuestionPosition < questions.count-1){
                
            
                nextQuestion();
                
            }else{
                //successful finish
                timer.invalidate();
                singlePlayController.gameFinished(NSLocalizedString("TITLE_GAME_FINISHED", comment: "game over title"), message: NSLocalizedString("MESSAGE_GAME_FINISHED_SUCCESS", comment: "game over success")+NSLocalizedString("MESSAGE_RETRY", comment: "retry?"), yesHandler: { action in
                    //self.singlePlayController.exit();
                    self.start();
                    }, noHandler: { action in
                        self.singlePlayController.exit();
                });
                
            }
            
        }else{
            
            //unsuccessful finish
            guard let wrongAnswerText = getCurrentQuestion()?.getAnswerByNumber(answerNumber) else {
                self.singlePlayController.exit();
                return;
            }
            
            guard let rightAnswerText = getCurrentQuestion()?.getRightAnswer() else {
                self.singlePlayController.exit();
                return;
            }
            
            timer.invalidate();
            singlePlayController.gameFinished(NSLocalizedString("TITLE_GAME_FINISHED", comment: "game over title"), message:
                NSLocalizedString("MESSAGE_WRONG_ANSWER", comment: "wrong answer")+" '\(wrongAnswerText)', "+NSLocalizedString("MESSAGE_RIGHT_ANSWER", comment: "right answer")+" '\(rightAnswerText)'"+NSLocalizedString("MESSAGE_RETRY", comment: "retry?"), yesHandler: { action in
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
    
    
    func getRandomWithExclusion( start: Int, end: Int, exclude: Int) -> [Int] {
        var random = Int(UInt32(start) + UInt32(arc4random_uniform(UInt32(end - start))));
        if (random >=  exclude) {
            random += 1;
        }
        
        let toRemain = [Int(exclude),Int(random)]
        let questionsNumbers = [1,2,3,4];
        return questionsNumbers.filter { !toRemain.contains($0) }
        
    }
    
    
}