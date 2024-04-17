//
//  File.swift
//  
//
//  Created by Aashutosh Shrestha on 4/15/24.
//

import Foundation
public enum EventError: Error{
    case propertiesParseError
    case eventSaveError
}
class UXAnalyticsEvent{
    var eventName: String
    var eventProperties: [String:String]
    
    init(eventName: String, eventProperties: [String : String]) {
        self.eventName = eventName
        self.eventProperties = eventProperties
    }
    
    func recordEvent(sessionId: String) throws{
        let context = CoreDataManager.shared.context
        let event = Events(context: context)
        event.id = UUID()
        event.name = eventName
        do {
                let jsonData = try JSONSerialization.data(withJSONObject: eventProperties)
                if let json = String(data: jsonData, encoding: .utf8) {
                    event.properties = json
                }
            } catch {
                throw EventError.propertiesParseError
            }
        event.session = sessionId
        do{
            try context.save()
            print("Event Saved")
        }catch let ex{
            print("Error saving events", ex.localizedDescription)
            throw EventError.eventSaveError
        }
    }
}
