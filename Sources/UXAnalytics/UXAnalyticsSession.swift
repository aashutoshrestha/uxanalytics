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
    case recordSessionError
}
open class UXAnalyticsSession{
    var startTime: Date?
    var endTime: Date?
    init() {
        
    }
    func startSession(){
        startTime = Date()
    }
    func recordEvent(name eventName: String, property eventProperties: [String:String])throws{
        let event = UXAnalyticsEvent(eventName: eventName, eventProperties: eventProperties)
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
    
    func recordSession() throws{
        let context = CoreDataManager.shared.context
        let session = Sessions(context: context)
        session.id = UUID()
        session.startTime = startTime
        if endTime != nil{
            session.endTime = endTime
        }
        do{
            try context.save()
        }catch{
            throw SessionError.recordSessionError
        }
    }
}
