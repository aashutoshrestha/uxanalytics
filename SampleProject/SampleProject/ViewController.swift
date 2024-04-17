//
//  ViewController.swift
//  SampleProject
//
//  Created by Aashutosh Shrestha on 4/17/24.
//
import UIKit
class ViewController: MainViewController {

    @IBOutlet weak var startSessionBtn: UIButton!
    @IBOutlet weak var recordEventBtn: UIButton!
    
    var sessionStarted: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            print(try getSessions())
        }catch{
            
        }
    
    }
    @IBAction func recordEvent(_ sender: Any) {
        let alert = UIAlertController(title: "Select Event", message: "Add Event", preferredStyle: .alert)
        for i in ["Event 1", "Event 2", "Event 3", "Event 4"] {
//            alert.addAction(UIAlertAction(title: i, style: .Default, handler: doSomething()))
            alert.addAction(UIAlertAction(title: i, style: .default,handler: { action in
                do{
                    var eventProperties = [
                        "date": Date().formatted(),
                    ]
                    try self.recordAnalyticsEvents(name: i, properties: eventProperties)
//                    print(getEvents(session: <#T##String#>))
                }catch{
                    
                }
            }))
        }
                            self.present(alert, animated: true, completion: nil)
    }
    @IBAction func startSession(_ sender: Any) {
        if self.sessionStarted{
            self.sessionStarted = false
            self.startSessionBtn.setTitle("Start Session", for: .normal)
            stopAnalyticsSession()
        }else{
            self.sessionStarted = true
            self.startSessionBtn.setTitle("Stop Session", for: .normal)
            startAnalyticsSession()
        }
        
        do{
            print(try getSessions())
        }catch{
            
        }
    }
    

}

