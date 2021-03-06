//
//  DatePickerPopupViewController.swift
//  Lets meet
//
//  Created by Nhung Huynh on 8/11/16.
//  Copyright © 2016 Zincer. All rights reserved.
//

import UIKit

protocol DatePickerPopupViewControllerDelegate {
    func getDate(date: NSTimeInterval)
}
class DatePickerPopupViewController: BaseViewController {
    
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var eventTime: NSTimeInterval?
    var appDelegate = UIApplication.sharedApplication().delegate
    
    var delegate: DatePickerPopupViewControllerDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        self.popUpView.layer.cornerRadius = 5
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSizeMake(0.0, 0.0)
        // Tap screen
        hideKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(tapScreen))
        
    }
    
    func showInView(aView: UIView!, animated: Bool)
    {
        print(aView.frame.size.width)
        self.view.frame.size.width = aView.frame.size.width
        aView.addSubview(self.view)
        
        if animated
        {
            self.showAnimate()
        }
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    
                    self.view.removeFromSuperview()
                }
        });
    }
    
    @IBAction func closePopup(sender: AnyObject) {
        //        var dateFormatter = NSDateFormatter()
        //        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        //        strDate = dateFormatter.stringFromDate(datePicker.date)
        eventTime = datePicker.date.timeIntervalSince1970
        self.removeAnimate()
        self.delegate.getDate(eventTime!)
    }
    // MARK: - Navigation
    
    override func tapScreen() {
        print("Screen is tapped")
        eventTime = datePicker.date.timeIntervalSince1970
        self.removeAnimate()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
    
}
