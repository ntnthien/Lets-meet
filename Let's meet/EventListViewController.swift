//
//  EventListViewController.swift
//  Lets meet
//
//  Created by admin on 8/5/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit
import ReactiveKit
import ReactiveUIKit


class EventListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var items = CollectionProperty<[Event]>([])
    @IBOutlet weak var orderSegment: UISegmentedControl!
    
    var isFirstLoad = true
    var tags: [String]?
    override func viewDidLoad() {
        orderSegment.selectedSegmentIndex = 0
        super.viewDidLoad()
        FirebaseAPI.sharedInstance.getTags()
        setUpTableView()
        if (serviceInstance.userIsLogin() == false) {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewControllerWithIdentifier("LoginVC") as! LoginViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
        loadData()

        createNotificationCenter()
        // Tap screen
        hideKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(tapScreen))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(joinValueDidChange(_:)), name: JOIN_VALUE_CHANGED_KEY, object: nil)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedRow, animated: true)
        }
    }
//    var eventArray : [Event] = [Event]()
    
    func joinValueDidChange(notification: NSNotification) {
        loadData()

    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    func loadData() {
        indicator.startAnimation()
        
        let orderString =  (orderSegment.selectedSegmentIndex == 0) ? "join_amount" : "time_since_1970"
        if let tags = tags {
            serviceInstance.getEventsByTags(tags) { (events) in
                print(events)

                self.items.removeAll()
                
                for event in events.reverse() {
                    if !self.items.contains({ (eventD) -> Bool in
                        return event!.id == eventD.id
                    }) {
                        self.items.append(event!)
                    }
                }
                self.tableView.reloadData()
                self.indicator.stopAnimation()
            }
        } else {
            serviceInstance.getEvents(orderString) { (events: [Event?]) in
                if self.isFirstLoad {
                    self.isFirstLoad = false
                    
                    self.loadData()
                } else {
                    self.items.removeAll()
                    //                print(events)
                    for event in events.reverse() {
                        self.items.append(event!)
                    }
                }
                
                //            for index in (events.count - 1).stride(to: 0, by: -1) {
                //                self.items.append(events[index]!)
                //                print(events[index])
                ////                print(event!.joinAmount)
                ////                self.eventArray.append(event!)
                //            }
                //           let indexPath = NSIndexPath.init(forRow:  self.eventArray.count, inSection: 1)
                //            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                //            print(self.items.collection)
                self.indicator.stopAnimation()
            }
        }
       
        
        
    }
    
    func setUpTableView() {
        
        tableView.delegate = self
        tableView.rDataSource.forwardTo = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 130
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        items.bindTo(tableView) { [weak self] indexPath, dataSource, tableView in
            guard let weakSelf = self else { return UITableViewCell() }
            
            let cell = weakSelf.tableView.dequeueReusableCellWithIdentifier("headerCell", forIndexPath: indexPath) as! EventHeaderTableViewCell
            cell.delegate = self
            cell.indexPath = indexPath
            cell.configureCell(self!.items[indexPath.row])
            return cell
        }
    }
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        loadData()
        refreshControl.endRefreshing()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentValueChange(sender: AnyObject) {
        loadData()
    }
}

extension EventListViewController: UITableViewDelegate {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            //            let navVC = segue.destinationViewController as! UINavigationController
            let detailVC = segue.destinationViewController as! EventDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                detailVC.event = items[indexPath.row]
                detailVC.eventImage = (tableView.cellForRowAtIndexPath(indexPath) as! EventHeaderTableViewCell).thumbnailImageView.image
            }
        }
        else if segue.identifier == "filterSegue" {
            let nav = segue.destinationViewController as! UINavigationController
            let nextVC = nav.topViewController as! FilterViewController
            nextVC.delegate = self
        }
    }
}


extension EventListViewController: ActionTableViewCellDelegate {
    func actionTableViewCell(actionTableViewCell: UITableViewCell, didTouchButton button: UIButton) {
        switch button.tag {
        case 60:
            print("Profile button touched")
            if let indexPath = (actionTableViewCell as? EventHeaderTableViewCell)?.indexPath, hostID = items[indexPath.row].hostID {
                showProfileViewController(hostID)
            }
        default:
            print("Unassigned button touched")
        }
    }
}


extension EventListViewController: FilterViewControllerDelegate {
    
    
    func filterViewController(filterViewController: FilterViewController, didUpdateFilter filter: Filter) {
        
//        serviceInstance.getEventsByTags(filter.tags!) { (events) in
//                print(events)
//                for event in events.reverse() {
//                    self.items.append(event!)
//                }
//                self.tableView.reloadData()
//        }
        items.removeAll()
        tags = filter.tags
        print(tags)
        loadData()
    }
    
}














