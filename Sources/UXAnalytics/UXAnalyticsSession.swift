//
//  File.swift
//  
//
//  Created by Aashutosh Shrestha on 4/15/24.
//

import Foundation
import CoreData
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
        do{
            try recordSession()
        }catch let ex{
            print("Record Start Session", ex.localizedDescription)
        }
    }
    func recordEvent(name eventName: String, property eventProperties: [String:String])throws{
        let event = UXAnalyticsEvent(eventName: eventName, eventProperties: eventProperties)
        do {
            try event.recordEvent(sessionId: id.uuidString)
        }
        catch let ex{
            print("Error recording event", ex.localizedDescription)
            throw SessionError.recordEventError
        }
    }
    func endSession(){
        endTime = Date()
        do{ 
            try recordSession()
        }catch let ex{
            print("Error ending session", ex.localizedDescription)
            print (ex.localizedDescription)
        }
    }
    
    func recordSession() throws{
        let context = CoreDataManager.shared.context
        if fetchSessions() != nil && (fetchSessions()?.count ?? 0) > 1 {
            let fetchRequest: NSFetchRequest<Sessions> = Sessions.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [self.id]) // Adjust the predicate as per your requirements

            do {
                let results = try context.fetch(fetchRequest)
                if let session = results.first {
                    session.startTime = startTime
                    session.endTime = endTime
                    try context.save()
                    print("Session Updated")
                    print(fetchSessions() as Any)
                    return
                }
            } catch let error as NSError {
                print("Could not fetch or update. \(error), \(error.userInfo)")
                return
            }
        }
        let session = Sessions(context: context)
        session.id = id
        session.startTime = startTime
        if endTime != nil{
            session.endTime = endTime
        }
        do{
            try context.save()
            print("Session Saved")
            print(fetchSessions() as Any)
        }catch let ex{
            print("Error saving sessions", ex.localizedDescription)
            throw SessionError.recordSessionError
        }
    }
    
    func fetchSessions() -> [Sessions]?{
        let context = CoreDataManager.shared.context
        let fetchRequest = NSFetchRequest<Sessions>(entityName: "Sessions")
        
        do {
            let sessions = try context.fetch(fetchRequest)
            return sessions
        }catch let ex{
            print("Error getAnalyticalsDataSessions", ex.localizedDescription)
            return nil
        }
    }
}
