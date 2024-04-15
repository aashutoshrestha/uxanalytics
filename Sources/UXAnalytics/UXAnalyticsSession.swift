//
//  File.swift
//  
//
//  Created by Aashutosh Shrestha on 4/15/24.
//

import Foundation
class UXAnalyticsSession{
    var startTime: Date?
    var endTime: Date?
    func startSession(){
        startTime = Date()
    }
    
    func recordEvent(event: UXAnalyticsEvent){
        
    }
    
    func endSession(){
        endTime = Date()
    }
}
