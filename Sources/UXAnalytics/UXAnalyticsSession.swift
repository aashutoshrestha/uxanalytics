//
//  File.swift
//  
//
//  Created by Aashutosh Shrestha on 4/15/24.
//

import Foundation
public enum SessionError: Error{
    case sessionStartError
    case sessionEndError
    case recordEventError
}
open class UXAnalyticsSession{
    var startTime: Date?
    var endTime: Date?
    func startSession(){
        startTime = Date()
    }
    
    func recordEvent(event: UXAnalyticsEvent)throws{
        do {
            try event.recordEvent()
        }
        catch{
            throw SessionError.recordEventError
        }
    }
    
    func endSession(){
        endTime = Date()
    }
}
