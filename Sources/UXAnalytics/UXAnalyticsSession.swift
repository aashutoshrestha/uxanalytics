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
class UXAnalyticsSession{
    var startTime: Date?
    var endTime: Date?
    var id = UUID()
    init() {
        //Starting Session on Initialization
//        startSession()
    }
    deinit {
        //Stopping and recording session on Deinitialization
//        endSession()
    }
    func startSession(){
        startTime = Date()
    }
    func recordEvent(name eventName: String, property eventProperties: [String:String])throws{
        let event = UXAnalyticsEvent(eventName: eventName, eventProperties: eventProperties)
        do {
            try event.recordEvent(sessionId: id.uuidString)
        }
        catch{
            
            throw SessionError.recordEventError
        }
    }
    func endSession(){
        endTime = Date()
        do{ 
            try recordSession()
        }catch let ex{
            print (ex.localizedDescription)
        }
    }
    
    func recordSession() throws{
        let context = CoreDataManager.shared.context
        let session = Sessions(context: context)
        session.id = id
        session.startTime = startTime
        if endTime != nil{
            session.endTime = endTime
        }
        do{
            try context.save()
            print("Session Saved")
        }catch let ex{
            print("Error saving sessions", ex.localizedDescription)
            throw SessionError.recordSessionError
        }
    }
}
