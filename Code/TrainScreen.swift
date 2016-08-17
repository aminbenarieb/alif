//
//  ViewController.swift
//  Alif
//
//  Created by Amin Benarieb on 08/10/15.
//  Copyright © 2015 Amin Benarieb. All rights reserved.
//

import UIKit
import Material
import GSIndeterminateProgressBar
import JTAlertView
import ZAlertView

private let reuseIdentifier = "Cell"

class TrainScreen: UIViewController, UIGestureRecognizerDelegate, TrainerProtocol {

    // Layout
    @IBOutlet var label: UILabel!
    @IBOutlet var labelstatus: UILabel!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var contentview : UIView!
    @IBOutlet var trainView : UIView!
    @IBOutlet var progressView : AminProgressView!
    @IBOutlet var contentheight: NSLayoutConstraint!
    @IBOutlet var contenttopmargin: NSLayoutConstraint!
    
    // TrainView params
    var trainModeView : TrainView?
    var prevTrainModeView : TrainView?
    lazy var сonstructorView : ConstructorView = {
        [unowned self] in
        
        let сonstructorView = ConstructorView.instantiate()
        сonstructorView.frame = self.trainView.bounds
        self.trainView.addSubview(сonstructorView)
        
        return сonstructorView
    }()
    lazy var selectorView : SelectorView = {
        [unowned self] in
        
        let selectorView = SelectorView.instantiate()
        selectorView.frame = self.trainView.bounds
        self.trainView.addSubview(selectorView)
        
        return selectorView
    }()
    lazy var writerView : WriterView = {
        [unowned self] in
        
        let writerView = WriterView.instantiate()
        writerView.frame = self.trainView.bounds
        self.trainView.addSubview(writerView)
        
        return writerView
    }()
    var next = false
    
    //MARK: View actions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //label
        label.font = label.font.fontWithSize(40)
        
        //progressview settings
        progressView.progressValue = CGFloat(Trainer.sharedInstance.progressValue())
                
        // back button actoin
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back".localized, style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        self.navigationItem.leftBarButtonItem = newBackButton;
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        nextWord()
    }
    
    //MARK: Class methods
    
    static func instantiate() -> TrainScreen{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TrainScreen") as! TrainScreen
    }

    //MARK: Controller actions
    
    func back(sender: UIBarButtonItem) {

        
        let dialog = ZAlertView(title: "Hold on", message: "Are you sure you want to leave the training?",
            isOkButtonLeft: true,
            okButtonText: "Cancel",
            cancelButtonText: "Leave",
            okButtonHandler: {
                
                (alert : ZAlertView) -> () in
                alert.dismiss()
            
            },
            cancelButtonHandler:
            {
                
                (alert : ZAlertView) -> () in
                alert.dismiss()
                self.navigationController?.popViewControllerAnimated(true)
            })
        dialog.alertType = .Confirmation
        dialog.show()
        
    }
    
    func check(answer : String?){
        
        if (next)
        {
            // Changing progress value
            progressView.progressValue = CGFloat(Trainer.sharedInstance.progressValue())
            
            if (Trainer.sharedInstance.isFinished() )
            {
                
                if let result = Trainer.sharedInstance.result,
                    alertView = JTAlertView(title: "\(result.title)\n\n \(result.message)", andImage:nil)
                {
                    alertView.size = CGSizeMake(280, 230);
                    alertView.addButtonWithTitle("OK", style: .Default, action: { (alertview: JTAlertView!) in
                        
                        alertview.hide()
                        self.navigationController?.popToRootViewControllerAnimated(true)
                        
                    })
                    
                    alertView.show()
                }
            }
            else
            {
                nextWord()
            }
        }
        else
        {
            
            var statustext : String
            var statuscolor : UIColor
            
            if let answer = answer,
                   result = Trainer.sharedInstance.checkWord(answer) where result.isRight
            {
                statustext = "Wrong, it's \(result.answer) :\\"
                statuscolor = MaterialColor.red.darken2
                
            }
            else
            {
                statustext = "Right!"
                statuscolor = MaterialColor.green.darken2
            }
            
            labelstatus.text = statustext
            labelstatus.textColor = statuscolor
            
            prepareTrainView(["btnTitle" : "Next", "btnColor" : statuscolor ]);
            
        }
        
        next = !next


    }
    
    func nextWord(){
        
        let trainerInfo =  Trainer.sharedInstance.nextWord()
        let userInfo = [ "btnTitle" : "Check",
                         "btnColor" : MaterialColor.blue.darken2,
                          "userVariants" : trainerInfo.support ]
        let mode = trainerInfo.mode
        
        
        labelstatus.text = "Translate it"
        labelstatus.textColor = MaterialColor.grey.darken4
        label.text = trainerInfo.targetWord as String
        prepareTrainView( userInfo, mode: mode);
        
        
    }

    func prepareTrainView(userInfo: [NSObject : AnyObject]?, mode : TrainMode? = nil){
        
        //some choice train mode login
        if let mode = mode
        {
            switch (mode)
            {
            case .Constructor:
                trainModeView = сonstructorView
                break
            case .Writer:
                trainModeView = selectorView
                break
            case .Selector:
                trainModeView = writerView
                break
            }
        }


        if let trainModeView = trainModeView
        {
            trainView.bringSubviewToFront(trainModeView)
            
            prevTrainModeView?.hidden = true
            trainModeView.hidden = false
            
            trainModeView.delegate = self
            trainModeView.updateView(userInfo)
        }
        
        prevTrainModeView = trainModeView
        
    }
    
    
    
}

