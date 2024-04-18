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
    
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var sessionTable: UITableView!
    
    var sessions = [[String:String]]()
    var events = [[String:String]]()
    
    var sessionStarted: Bool = false
    
    var selectedSessionId : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            initializeAnalytics()
            
        }catch let ex{
            print("Error getting sessions", ex.localizedDescription)
        }
        
        self.eventsTable.dataSource = self
        self.eventsTable.delegate = self
        
        self.sessionTable.dataSource = self
        self.sessionTable.delegate = self
    
    }
    
    func fetchSessions(){
        do{
            
            let sessionList = try getSessions()
            sessions.removeAll()
            for session in sessionList {
                sessions.append([
                    "name": "Session",
                    "date": session.startTime?.formatted() ?? "",
                    "id": session.id?.uuidString ?? ""
                ])
            }
            self.sessionTable.reloadData()
        }catch let ex{
            print(ex)
        }
    }
    
    func fetchEvents(){
        do{
            
            let eventsList = try getEvents(session: self.selectedSessionId)
            events.removeAll()
            for event in eventsList {
                events.append([
                    "name": event.name ?? "",
                    "date": event.date?.formatted() ?? "",
                    "properties": event.properties ?? "",
                    "id": event.id?.uuidString ?? ""
                ])
            }
            self.eventsTable.reloadData()
        }catch let ex{
            print(ex)
        }
    }
    @IBAction func recordEvent(_ sender: Any) {
        if !self.sessionStarted{
            let alert = UIAlertController(title: "Session not started", message: "Start session to record event. Obviously event can be recorded on its own, but for this sample, event depends on the session.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
            return
        }
        let alert = UIAlertController(title: "Select Event", message: "Add Event", preferredStyle: .alert)
        for i in ["Event 1", "Event 2", "Event 3", "Event 4"] {
//            alert.addAction(UIAlertAction(title: i, style: .Default, handler: doSomething()))
            alert.addAction(UIAlertAction(title: i, style: .default,handler: { action in
                do{
                    var eventProperties = [
                        "date": Date().formatted(),
                    ]
                    try self.recordAnalyticsEvents(name: i, properties: eventProperties)
//                    print(getEvents(session: T##String))
                }catch let ex{
                    print("Error adding events", ex.localizedDescription)
                    print(ex)
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
            fetchSessions()
            print(try getSessions())
        }catch let ex{
            print("Error on session start clicked", ex.localizedDescription)
        }
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == sessionTable{
            return sessions.count
        }
        
        return events.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == eventsTable{
            return "Events"
        }else{
            return "Sessions"
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == eventsTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCell", for: indexPath) as! EventsTableViewCell
            let data = events[indexPath.item]
            cell.name.text = data["name"]
            cell.desc.text = data["properties"]
            return cell
        } else{
            let cell =  tableView.dequeueReusableCell(withIdentifier: "SessionsTableViewCell", for: indexPath) as! SessionsTableViewCell
            let data = sessions[indexPath.item]
            cell.name.text = data["name"]
            cell.desc.text = data["date"]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == eventsTable{
            
        }else{
            self.selectedSessionId = self.sessions[indexPath.item]["id"] ?? ""
            self.fetchEvents()
        }
    }
    
    
}
