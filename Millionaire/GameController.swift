//
//  GameController.swift
//  Millionaire
//
//  Created by Igor Kasyanenko on 18.04.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//
import UIKit

class GameController: UIViewController,UITableViewDelegate,UITableViewDataSource, ISinglePlay {
    
    @IBOutlet weak var scoreTable: UITableView!
    @IBOutlet weak var firstAnswerButton: UIButton!
    @IBOutlet weak var secondAnswerButton: UIButton!
    @IBOutlet weak var thirdAnswerButton: UIButton!
    @IBOutlet weak var fourthAnswerButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!

    @IBOutlet weak var timeButton: UIButton!
    
    @IBAction func exitButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true);
    }
    
    @IBAction func firstAnswerButtonClicked(sender: UIButton) {
        game?.answerTouched(1)
    }
    @IBAction func secondAnswerButtonClicked(sender: UIButton) {
        game?.answerTouched(2)
    }
    @IBAction func thirdAnswerButtonClicked(sender: UIButton) {
        game?.answerTouched(3)
      }
    @IBAction func fourthAnswerButtonClicked(sender: UIButton) {
        game?.answerTouched(4)
    }
    

    
    var game:Game?;
    
    override func viewDidLoad() {
        game = GameFactory.createSingleGame(self);
        
        scoreTable.delegate = self;
        scoreTable.dataSource = self;
       
        startGame();

        }
    
    func startGame() {
        
        guard let started = game?.start() else{
            return;
        }
        
        if(!started){
            showAlertView("No data", message: "reset?" ,yesHandler: {action in
                DataProvider.synchronize(){ result in
                    print("sync method \(result)")
                    
                    self.startGame();
                
                    
                };
                
                },noHandler: {action in
                    self.exit();
            });
            
        }
        
        
    }
    
    func setScoreTablePosition(position: Int){
        scoreTable.selectRowAtIndexPath(NSIndexPath(forRow: position,inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
    }
    
    func gameFinished(title: String, message: String, yesHandler:(action: UIAlertAction)->Void,noHandler:(action: UIAlertAction)->Void){
        showAlertView(title, message: message ,yesHandler: yesHandler,noHandler: noHandler);
    }
   
    func initScoreTable(questions:[Question]){
        scoreTable.reloadData();
    }
    
    func initQuestion(question:Question){
        questionLabel.text = question.questionText;
        firstAnswerButton.setTitle(question.answer1, forState: .Normal);
        secondAnswerButton.setTitle(question.answer2, forState: .Normal);
        thirdAnswerButton.setTitle(question.answer3, forState: .Normal);
        fourthAnswerButton.setTitle(question.answer4, forState: .Normal);
    }
   
    func setTime(timeLeft:Int){
        timeButton.setTitle(String(timeLeft), forState: .Normal);
    }
   
    func exit(){
        exitButton(self);
    }
    
    func showAlertView(title: String,message: String, yesHandler: (action:UIAlertAction)->Void, noHandler: (action:UIAlertAction)->Void)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler:  yesHandler))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: noHandler))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            guard let game = game else{
            return 0;
        }
        return game.getQuestions().count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ScoreCell = tableView.dequeueReusableCellWithIdentifier("ScoreCell") as! ScoreCell;
        cell.backgroundColor = UIColor.clearColor();
        cell.textLabel?.textColor = UIColor.whiteColor();
        cell.textLabel?.font = UIFont(name:"Helvetica", size:20.0);
        //cell.textLabel?.minimumFontSize = 50.0;
        cell.textLabel?.textAlignment = .Center
        if let g = game {
            cell.textLabel!.text = String(Int(g.getScoreForPositionInScoreTable(indexPath.row)))+"$";
        }
        return cell;
    }
    
    override func viewWillAppear(animated: Bool) {
       // self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        let backgroundImage = UIImage(named: "score_table_back")
        let imageView = UIImageView(image: backgroundImage);
        //imageView.contentMode = .ScaleAspectFit
        
        scoreTable.backgroundView = imageView
    
       
    }
    
   
    
    /*
     func initCoreData() -> Void {
     
     Question.deleteAll()
     let question = Question();
     question.id = 3;
     question.postedTime = 5476756;
     question.updatedTime = 5476758;
     question.level = 1;
     question.questionText = "Four legs and head?";
     question.answer1 = "horse";
     question.answer2 = "bottle";
     question.answer3 = "can";
     question.answer4 = "automobile";
     question.trueAnswer = 1;
     
     let question1 = Question();
     question1.id = 4;
     question1.postedTime = 6476756;
     question1.updatedTime = 9476758;
     question1.level = 3;
     question1.questionText = "Have you ever been in Moscow on Earth 1435?";
     question1.answer1 = "No";
     question1.answer2 = "Yes";
     question1.answer3 = "Super";
     question1.answer4 = "hjj";
     question1.trueAnswer = 2;
     
     let question2 = Question();
     question2.id = 5;
     question2.postedTime = 6496756;
     question2.updatedTime = 9876758;
     question2.level = 1;
     question2.questionText = "Does the cat have a nose?";
     question2.answer1 = "No";
     question2.answer2 = "Yes";
     question2.answer3 = "He has a ears";
     question2.answer4 = "No Question";
     question2.trueAnswer = 2;
     CoreDataHelper.instance.save();
     
     }
     */
    
    
    /*
     var url="https://api.vk.com/method/users.get?user_id=66748";
     
     url = "http://185.4.66.155:6882/millionaire/sync";
     
     Alamofire.request(.POST, url,parameters: ["date":345467]).responseJSON { response in
     //  print(response.request)  // original URL request
     //   print(response.response) // URL response
     //   print(response.data)     // server data
     //   print(response.result)   // result of response serialization
     guard let json =  response.result.value else {
     print("\(response.result.error)");
     return;
     }
     
     print("JSON: \(json)");
     guard let keyDate = json["date"] as? Int else{
     return;
     }
     print("key date enc: \(DataProvider.encrypt(String(keyDate))) key date: \(keyDate)")
     Alamofire.request(.POST, url, parameters: ["hash":DataProvider.encrypt(String(keyDate))]).responseJSON { response in
     print(response);
     }
     }*/
    
    

    
    
}
