//
//  File.swift
//  
//
//  Created by Aashutosh Shrestha on 4/15/24.
//

import Foundation
class UXAnalyticsEvent{
    var eventName: String
    var eventProperties: [String:String]
    
    init(eventName: String, eventProperties: [String : String]) {
        self.eventName = eventName
        self.eventProperties = eventProperties
    }
}
