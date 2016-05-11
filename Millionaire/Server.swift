//
//  Server.swift
//  Millionaire
//
//  Created by Igor Kasyanenko on 20.04.16.
//  Copyright © 2016 Igor Kasyanenko. All rights reserved.
//

import Foundation

class Server {
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
}