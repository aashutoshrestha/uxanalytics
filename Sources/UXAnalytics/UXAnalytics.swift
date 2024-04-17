// The Swift Programming Language
// https://docs.swift.org/swift-book
import UIKit
import CoreData
enum AnalyticsError: Error{
    case fetchEventsError
    case fetchSessionError
    case recordEventError
}
open class UXAnalyticsViewController: UIViewController{
    var analytics: UXAnalytics?
    
    open func initAnalytics(){
        analytics = UXAnalytics()
    }
    
    open func startSession(){
        analytics?.startSession()
    }
    
    open func stopSession(){
        analytics?.stopSession()
    }
    
    open func recordEvent(name eventName: String, property eventProperty: [String:String]) throws {
        do { try analytics?.recordAnalyticsEvent(name: eventName, property: eventProperty)}catch{
            throw AnalyticsError.recordEventError
        }
    }
    
    open func getSessionData() throws -> [Sessions]{
        do{
            let sessionData = try analytics?.getAnalyticalsDataSessions()
            return sessionData ?? [Sessions]()
        }catch{
            throw AnalyticsError.fetchSessionError
        }
    }
    
    open func getEventsData(session: String) throws -> [Events]{
        do{
            let eventsData = try analytics?.getAnalyticalDataEvents(session: session)
            return eventsData ?? [Events]()
        }catch{
            throw AnalyticsError.fetchEventsError
        }
    }
    
}

class UXAnalytics{
    var session : UXAnalyticsSession?
    init() {
    }
    deinit {
    }
    
    func startSession() {
        session = UXAnalyticsSession()
         session?.startSession()
    }
    
    func stopSession(){
        session?.endSession()
    }
    
    func recordAnalyticsEvent(name eventName: String, property eventProperty: [String:String]) throws {
        do { try session?.recordEvent(name: eventName, property: eventProperty)}catch{
            throw AnalyticsError.recordEventError
        }
    }
    
    func getAnalyticalDataEvents(session: String) throws -> [Events] {
        let context = CoreDataManager.shared.context
        let fetchRequest = NSFetchRequest<Events>(entityName: "Events")
        fetchRequest.predicate = NSPredicate(format: "session == %@", session)
        do {
            let events = try context.fetch(fetchRequest)
            return events
        }catch{
            throw AnalyticsError.fetchEventsError
        }
        
    }
    
    func getAnalyticalsDataSessions() throws -> [Sessions] {
        let context = CoreDataManager.shared.context
        let fetchRequest = NSFetchRequest<Sessions>(entityName: "Sessions")
        
        do {
            let sessions = try context.fetch(fetchRequest)
            return sessions
        }catch{
            throw AnalyticsError.fetchSessionError
        }
    }
    
}


