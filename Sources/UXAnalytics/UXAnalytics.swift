// The Swift Programming Language
// https://docs.swift.org/swift-book
import UIKit
import CoreData
enum AnalyticsError: Error{
    case fetchEventsError
    case fetchSessionError
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


