//
//  ServerSettings.swift
//  Millionaire
//
//  Created by Igor Kasyanenko on 20.04.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation
class ServerSettings {
    static let host:NSURL = NSURL(fileURLWithPath: "http://185.4.66.155:6882");
    static let checkSyncDatePath: String = "";
    static let synchronizeQuestionsPath:String =  "/millionaire/sync";
    
    static let salt = "kjkszpj";
}