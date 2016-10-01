//
//  DataProvider.swift
//  Millionaire
//
//  Created by Igor Kasyanenko on 20.04.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData
import Alamofire
import Crypto

class DataProvider {
	/*
	 func fetchNextTracks() {
	 func callback(_json: JSON?, _error: NSError?) -> Void {
	 if let error = _error {
	 // handle error here
	 } else if let json = _json {
	 if let nextHref = json["next_href"].string {
	 // save the url of "next page"
	 }
	 if let trackArray = json["collection"].array {
	 storeFetched(trackArray)
	 }
	 }
	 }
	 if let nextHref = Prefs.sharedInstance.savedNextSoundCloudHref {
	 SoundCloudService.fetchData(fromSavedUrl: nextHref, callback: callback)
	 }
	 }
	 */

	static func storeFetched(_ questions: [JSON]) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>  = NSFetchRequest(entityName: Question.className)
		for json in questions {
			let questionServerId = json["id"].intValue
			let predicate = NSPredicate(format: "%K == %i", "id", questionServerId)
			fetchRequest.predicate = predicate

			do {
				let fetchedResults = try CoreDataHelper.instance.context.fetch(fetchRequest) as? [Question];
				if let results = fetchedResults {
					if (results.count > 0) {
						for q in results {
							// q.id = json["id"].int32Value;
							q.postedTime = json["posted_time"].int64Value;
							q.updatedTime = json["updated_time"].int64Value;
							q.level = json["level"].int32Value;
							q.questionText = json["text"].stringValue;
							q.answer1 = json["answer1"].stringValue;
							q.answer2 = json["answer2"].stringValue;
							q.answer3 = json["answer3"].stringValue;
							q.answer4 = json["answer4"].stringValue;
							q.trueAnswer = json["true_answer"].int16Value;

						}
						// print("continue");
						continue;
					}
				}

				// print("fetched \(json)")
				let question = Question();
				question.id = json["id"].int32Value;
				question.postedTime = json["posted_time"].int64Value;
				question.updatedTime = json["updated_time"].int64Value;
				question.level = json["level"].int32Value;
				question.questionText = json["text"].stringValue;
				question.answer1 = json["answer1"].stringValue;
				question.answer2 = json["answer2"].stringValue;
				question.answer3 = json["answer3"].stringValue;
				question.answer4 = json["answer4"].stringValue;
				question.trueAnswer = json["true_answer"].int16Value;
				CoreDataHelper.instance.save();

			} catch let error as NSError {
				print(error);
			}

		}
	}

	fileprivate static let LAST_SYNC_DATE = "LAST_SYNC_DATE";

	static func deleteExtraData() {
		let ids = [String]();
		let request: NSFetchRequest<NSFetchRequestResult>  = NSFetchRequest(entityName: "Person");
		request.predicate = NSPredicate(format: "NOT (name IN %@)", argumentArray: ids);

		do {
			let arrayToDelete = try CoreDataHelper.instance.context.fetch(request) as? [Question];

			guard let arr = arrayToDelete else {
				return;
			}

			for obj in arr {
				CoreDataHelper.instance.context.delete(obj)
			}

			// CoreDataHelper.instance.context.deleteObject(obj)

			// [managedObjectContext save:&error];
			// ### Error handling.

		} catch let error as NSError {

		}

		// NSArray*         deleteArray = [managedObjectContext executeFetchRequest:request error:&error];

	}

	static func synchronize(_ finishCallback: @escaping (_ result: String) -> Void) {

		func fetchingDataCallback(_ json: JSON?, error: NSError?) {
			if error != nil {
				finishCallback("fail after auth");
			} else if let j = json {
				if let err = j["error"].string {
					finishCallback("error parameter \(err)");
				}
				if let response = j["response"].array {

					print("response \(response)")

					storeFetched(response);
					finishCallback("got data");

				} else {
					finishCallback("no response parameter");
				}
			}

		}

		func currentTimeMillis() -> Int64 {
			let nowDouble = Date().timeIntervalSince1970
			return Int64(nowDouble * 1000)
		}

		func resetingDataCallback(_ json: JSON?, error: NSError?) {
			Question.deleteAll();
			fetchingDataCallback(json, error: error);
		}

		func authCallback(_ json: JSON?, error: NSError?) {
			// print("auth json "+String(json))

			if error != nil {
				finishCallback("auth error");
			} else if let j = json {

				if let keyDate = j["date"].int64 {

					// print("local \(getLocalSyncDate()) key parse int \(Int(keyDate)) key \(j["date"].int64!) curr \(currentTimeMillis()) jdate \(j["date"])");

					if (getLocalSyncDate() < keyDate) {
						print("just update")
						APIService.fetchData(fromSavedUrl: ServerSettings.host.appendingPathComponent(ServerSettings.synchronizeQuestionsPath), parameters: ["hash": encrypt(String(keyDate)) as AnyObject], callback: fetchingDataCallback);

						setLocalSyncDate(keyDate)
					} else {
						finishCallback("questions is still actual");

					}
				} else if let lastDeleteDate = j["delete_date"].int64 {
					print("reset all")
					APIService.fetchData(fromSavedUrl: ServerSettings.host.appendingPathComponent(ServerSettings.synchronizeQuestionsPath), parameters: ["hash": encrypt(String(lastDeleteDate)) as AnyObject], callback: resetingDataCallback);
					setLocalSyncDate(lastDeleteDate)

				}
				else {
					finishCallback("no date parameter");
				}

			}
		}

		APIService.fetchData(fromSavedUrl: ServerSettings.host.appendingPathComponent(ServerSettings.synchronizeQuestionsPath), parameters: ["date": NSNumber(value: getLocalSyncDate() as Int64)], callback: authCallback)

	}

	static func encrypt(_ date: String) -> String {
        
		let hash = HMAC.sign(message: date + ServerSettings.salt, algorithm: .sha256, key: ServerSettings.salt);

        
        //
        
        		// let hash = date+ServerSettings.salt;
		return hash!;
	}

	static func getServerSyncDate() -> Int {
		let url = "https://api.vk.com/method/users.get?user_id=66748";

        Alamofire.request( url, method: .get).responseJSON { response in
			// print(response.request)  // original URL request
			// print(response.response) // URL response
			// print(response.data)     // server data
			// print(response.result)   // result of response serialization

			guard let json = response.result.value else {
				print("\(response.result.error)");
				return;
			}

			print("JSON: \(json)")

			for q in Question.getAll() {
				print(q.questionText)
			}

		}

		return 0;
	}

	static func getLocalSyncDate() -> Int64 {
        
        if let number =  UserDefaults.standard.object(forKey: LAST_SYNC_DATE) as? Int64{
            
            return  number;
            
        }else{
            return 0;
        }
        
//		return NSUserDefaults.standardUserDefaults().integerForKey(LAST_SYNC_DATE)
	}

	static func setLocalSyncDate(_ syncDate: Int64) {
        
        
        UserDefaults.standard.set(NSNumber(value: syncDate as Int64), forKey: LAST_SYNC_DATE);
        
		//NSUserDefaults.standardUserDefaults().setInteger(syncDate, forKey: LAST_SYNC_DATE)
	}

}
