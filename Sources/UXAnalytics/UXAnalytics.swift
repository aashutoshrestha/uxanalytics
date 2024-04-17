// The Swift Programming Language
// https://docs.swift.org/swift-book
import UIKit
open class UXAnalyticsViewController: UIViewController{
    
}

open class UXAnalytics{
    var session = UXAnalyticsSession()
    init() {
        session.startTime = Date()
    }
    deinit {
        session.endTime = Date()
    }
    
    func stopSession(){
        
    }
}


