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
        do { 
            try analytics?.recordAnalyticsEvent(name: eventName, property: eventProperty)
        }catch let ex{
            print("Error recordEvent", ex.localizedDescription)
            throw AnalyticsError.recordEventError
        }
    }
    
    open func getSessionData() throws -> [Sessions]{
        do{
            let sessionData = try analytics?.getAnalyticalsDataSessions()
            return sessionData ?? [Sessions]()
        }catch let ex{
            print("Error fetching session", ex.localizedDescription)
            throw AnalyticsError.fetchSessionError
        }
    }
    
    open func getEventsData(session: String) throws -> [Events]{
        do{
            let eventsData = try analytics?.getAnalyticalDataEvents(session: session)
            return eventsData ?? [Events]()
        }catch let ex{
            print("Error fetching events", ex.localizedDescription)
            throw AnalyticsError.fetchEventsError
        }
    }
    
}

public class UXAnalytics{
    var session : UXAnalyticsSession?
    init() {
    }
    deinit {
    }
    
    public func startSession() {
        session = UXAnalyticsSession()
         session?.startSession()
    }
    
    public func stopSession(){
        session?.endSession()
    }
    
    public func recordAnalyticsEvent(name eventName: String, property eventProperty: [String:String]) throws {
        do {
            try session?.recordEvent(name: eventName, property: eventProperty)
        }catch let ex{
            print("Error recordAnalyticsEvent", ex.localizedDescription)
            throw AnalyticsError.recordEventError
        }
    }
    
    public func getAnalyticalDataEvents(session: String) throws -> [Events] {
        let context = CoreDataManager.shared.context
        let fetchRequest = NSFetchRequest<Events>(entityName: "Events")
        fetchRequest.predicate = NSPredicate(format: "session == %@", session)
        do {
            let events = try context.fetch(fetchRequest)
            return events
        }catch let ex{
            print("Error getAnalyticalDataEvents", ex.localizedDescription)
            throw AnalyticsError.fetchEventsError
        }
        
    }
    
    public func getAnalyticalsDataSessions() throws -> [Sessions] {
        let context = CoreDataManager.shared.context
        let fetchRequest = NSFetchRequest<Sessions>(entityName: "Sessions")
        
        do {
            let sessions = try context.fetch(fetchRequest)
            return sessions
        }catch let ex{
            print("Error getAnalyticalsDataSessions", ex.localizedDescription)
            throw AnalyticsError.fetchSessionError
        }
    }
    
}


