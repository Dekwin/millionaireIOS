//
//  GameFactory.swift
//  Millionaire
//
//  Created by Igor Kasyanenko on 22.04.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation

class GameFactory {
   static func createSingleGame(controller:ISinglePlay) -> Game {
        return SingleGame(singlePlayController: controller);
    }
    
  
   
}