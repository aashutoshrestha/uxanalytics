//
//  MainViewController.swift
//  SampleProject
//
//  Created by Aashutosh Shrestha on 4/17/24.
//

import Foundation
import UXAnalytics
enum UXAnalyticsError: Error{
    case recordEventError
}
class MainViewController: UXAnalyticsViewController{
   
    override func viewDidLoad() {
      
    }
    
    func initializeAnalytics(){
        initAnalytics()
    }
    
    func startAnalyticsSession(){
        startSession()
    }
    
    func stopAnalyticsSession(){
        stopSession()
    }
    
    func recordAnalyticsEvents(name eventName: String, properties eventProperties: [String:String]) throws {
        do{
            try recordEvent(name: eventName, property: eventProperties)
        }catch{
            throw UXAnalyticsError.recordEventError
        }
    }
    
    func getSessions() throws -> [Sessions]{
        do{
            return try getSessionData()
        }catch let ex{
            print(ex.localizedDescription)
        }
        return [Sessions]()
    }
    
    func getEvents(session: String) throws -> [Events]{
        do{
            return try getEventsData(session: session)
        }catch let ex{
            print(ex.localizedDescription)
        }
        return [Events]()
    }
}
