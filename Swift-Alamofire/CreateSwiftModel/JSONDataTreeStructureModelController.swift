//
//  JSONDataTreeStructureModelController.swift
//  CreateJSONModel
//
//  Created by YouXianMing on 16/8/24.
//  Copyright © 2016年 YouXianMing. All rights reserved.
//

import UIKit

// MARK: [Class] JSONDataTreeStructureModelController

private let width  : CGFloat = UIScreen.mainScreen().bounds.size.width
private let height : CGFloat = UIScreen.mainScreen().bounds.size.height

class JSONDataTreeStructureModelController: UIViewController, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    private let backButtonEvent    = 100
    private let cancelButtonEvent  = 101
    private let okButtonEvent      = 102
    private let createButtonEvent  = 103
    private let dismissButtonEvent = 104
    
    var treeStructureModel   : JSONDataTreeStructureModel!
    weak var editModel       : JSONDataTreeStructureModel?
    var isRootViewController : Bool = false
    
    private var allProperties : [PropertyInfomation]!
    private var tableView     : UITableView!
    private var backButton    : UIButton!
    private var createButton  : UIButton!
    private var dismissButton : UIButton!
    private var editView      : UIButton!
    private var nameField     : UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        baseSetup()
        createTitleView()
        createUITableView()
    }
    
    private func baseSetup() {
        
        view.backgroundColor = UIColor.whiteColor()
        allProperties        = treeStructureModel.allProperties()
    }
    
    private func createTitleView() {
        
        view.addSubview(BackgroundLineView(frame: CGRectMake(0, 0, width, 63.5), lineWidth: 4, lineGap: 4,
            lineColor: UIColor.blackColor().colorWithAlphaComponent(0.015), rotate: CGFloat(M_PI_4)))
        
        let titleLabel           = UILabel(frame: CGRectMake(0, 20, width, 44))
        titleLabel.text          = title
        titleLabel.textAlignment = .Center
        view.addSubview(titleLabel)
        
        let lineView             = UIView(frame: CGRectMake(0, 63.5, width, 0.5))
        lineView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.05)
        view.addSubview(lineView)
        
        // Back button.
        backButton     = UIButton(frame: CGRectMake(-10, 20, 50, 44))
        backButton.tag = backButtonEvent
        backButton.addTarget(self, action: #selector(JSONDataTreeStructureModelController.buttonsEvent(_:)),
                             forControlEvents: .TouchUpInside)
        backButton.setImage(UIImage(named: "JSONDataTreeStructureModelController_black"),     forState: .Normal)
        backButton.setImage(UIImage(named: "JSONDataTreeStructureModelController_black_pre"), forState: .Highlighted)
        view.addSubview(backButton)
        
        // Create button.
        createButton                  = UIButton(frame: CGRectMake(width - 50, 20, 40, 44))
        createButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        createButton.tag              = createButtonEvent
        createButton.setTitle("create", forState: .Normal)
        createButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        createButton.setTitleColor(UIColor.redColor().colorWithAlphaComponent(0.5), forState: .Highlighted)
        createButton.addTarget(self, action: #selector(JSONDataTreeStructureModelController.buttonsEvent(_:)),
                           forControlEvents: .TouchUpInside)
        view.addSubview(createButton)
        
        dismissButton                  = UIButton(frame: CGRectMake(8, 20, 50, 44))
        dismissButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        dismissButton.tag              = dismissButtonEvent
        dismissButton.setTitle("dismiss", forState: .Normal)
        dismissButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        dismissButton.setTitleColor(UIColor.grayColor().colorWithAlphaComponent(0.5), forState: .Highlighted)
        dismissButton.addTarget(self, action: #selector(JSONDataTreeStructureModelController.buttonsEvent(_:)),
                               forControlEvents: .TouchUpInside)
        view.addSubview(dismissButton)
        
        if isRootViewController == true {
            
            backButton.hidden    = true
            createButton.hidden  = false
            dismissButton.hidden = false
            
        } else {
            
            backButton.hidden    = false
            createButton.hidden  = true
            dismissButton.hidden = true
        }
    }
    
    func buttonsEvent(button : UIButton) {
        
        switch button.tag {
            
        case backButtonEvent:
            self.navigationController?.popViewControllerAnimated(true)
            
        case cancelButtonEvent:
            self.hideEditView()
            
        case okButtonEvent:
            self.hideEditView(nameField.text)
 
        case dismissButtonEvent:
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)

        case createButtonEvent:
            
            let pointerArray = NSPointerArray(options: .WeakMemory)
            treeStructureModel.traverseModel(pointerArray)
            
            for (_, value) in pointerArray.allObjects.enumerate() {
                
                let model = value as! JSONDataTreeStructureModel
                JSONDataTreeStructureModelFileCreator(model: model)?.createFile()
            }
            
            print("生成的文件在以下路径: " + NSHomeDirectory().stringByAppendingString("/Documents"))

        default:break}
    }
    
    private func createUITableView() {
        
        tableView                = UITableView(frame: CGRectMake(0, 64, width, height - 64))
        tableView.delegate       = self
        tableView.dataSource     = self
        tableView.rowHeight      = 40
        tableView.separatorStyle = .None
        tableView.registerClass(TreeStructureModelCell.classForCoder(), forCellReuseIdentifier: "TreeStructureModelCell")
        view.addSubview(tableView)
    }
    
    private func createEditView(string : String? = nil) {
        
        editView                     = UIButton(frame: CGRectMake(0, 64, width, height - 64))
        editView.backgroundColor     = UIColor.clearColor()
        editView.tag                 = cancelButtonEvent
        editView.layer.masksToBounds = true
        editView.addTarget(self, action: #selector(JSONDataTreeStructureModelController.buttonsEvent(_:)),
                           forControlEvents: .TouchUpInside)
        view.addSubview(editView)
        
        let whiteView               = UIView(frame: CGRectMake(0, -40, width, 40))
        whiteView.backgroundColor   = UIColor.whiteColor()
        editView.addSubview(whiteView)
        
        UIView.animateWithDuration(0.35) {
            
            self.editView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.20)
            whiteView.frame               = CGRectMake(0, 0, width, 40)
        }
        
        // Cancel button.
        let cancelButton              = UIButton(frame: CGRectMake(width - 75, 0, 40, 40))
        cancelButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        cancelButton.tag              = cancelButtonEvent
        cancelButton.setTitle("cancel", forState: .Normal)
        cancelButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        cancelButton.setTitleColor(UIColor.redColor().colorWithAlphaComponent(0.5), forState: .Highlighted)
        cancelButton.addTarget(self, action: #selector(JSONDataTreeStructureModelController.buttonsEvent(_:)),
                               forControlEvents: .TouchUpInside)
        whiteView.addSubview(cancelButton)
        
        // Ok button.
        let okButton              = UIButton(frame: CGRectMake(width - 40, 0, 40, 40))
        okButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        okButton.tag              = okButtonEvent
        okButton.setTitle("ok", forState: .Normal)
        okButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        okButton.setTitleColor(UIColor.redColor().colorWithAlphaComponent(0.5), forState: .Highlighted)
        okButton.addTarget(self, action: #selector(JSONDataTreeStructureModelController.buttonsEvent(_:)),
                           forControlEvents: .TouchUpInside)
        whiteView.addSubview(okButton)
        
        nameField             = UITextField(frame: CGRectMake(10, 10, width - 95, 20))
        nameField.placeholder = string
        nameField.font        = UIFont.systemFontOfSize(12)
        whiteView.addSubview(nameField)
        
        let lineView             = UIView(frame: CGRectMake(10, 30, width - 95, 0.5))
        lineView.backgroundColor = UIColor.blackColor()
        whiteView.addSubview(lineView)
    }
    
    func hideEditView(string : String? = nil) {
        
        UIView.animateWithDuration(0.35, animations: {
            
            self.editView.alpha = 0
            
        }) { (hide) in
            
            self.editView.removeFromSuperview()
        }
        
        if string?.characters.count > 0 {
            
            // If have the string, change the model's info & reload data.
            editModel?.modelName = string
            tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDataSource & UITableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allProperties.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let model        = allProperties[indexPath.row]
        let cell         = tableView.dequeueReusableCellWithIdentifier("TreeStructureModelCell") as? TreeStructureModelCell
        cell?.data       = model
        cell?.model      = treeStructureModel
        cell?.controller = self
        cell?.loadData()
        
        return cell!
    }
    
    // MARK: System method.
    
    func useInteractivePopGestureRecognizer() {
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private var enableInteractivePopGestureRecognizer : Bool? {
        
        get { return (self.navigationController?.interactivePopGestureRecognizer?.enabled)}
        set(newVal) { self.navigationController?.interactivePopGestureRecognizer?.enabled = newVal!}
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        guard isRootViewController == true else {
            
            return
        }
        
        enableInteractivePopGestureRecognizer = false
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        guard isRootViewController == true else {
            
            return
        }
        
        enableInteractivePopGestureRecognizer = true
    }
}

// MARK: private - [Class] TreeStructureModelCell

private class TreeStructureModelCell : UITableViewCell {
    
    weak var data       : PropertyInfomation?
    weak var model      : JSONDataTreeStructureModel?
    weak var controller : JSONDataTreeStructureModelController?
    
    private var nameLabel     : UILabel!
    private var typeLabel     : UILabel!
    private var listLabel     : UILabel!
    private var editButton    : UIButton!
    private var nextImageView : UIImageView!
    
    private let editButtonTag     = 100
    private let nextPageButtonTag = 101
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .None
        typeLabel      = UILabel(frame: CGRectMake(4, 0, 200, 16))
        typeLabel.font = UIFont.systemFontOfSize(8)
        self.addSubview(typeLabel)
        
        nameLabel      = UILabel(frame: CGRectMake(15, 0, width - 30, 40))
        nameLabel.font = UIFont.systemFontOfSize(16)
        self.addSubview(nameLabel)
        
        listLabel               = UILabel(frame: CGRectMake(15, 0, width - 40, 25))
        listLabel.textAlignment = .Right
        listLabel.font          = UIFont.systemFontOfSize(8)
        self.addSubview(listLabel)
        
        nextImageView        = UIImageView(image: UIImage(named: "JSONDataTreeStructureModelController_next"))
        nextImageView.center = CGPointMake(width - 13, 20)
        self.addSubview(nextImageView)
        
        let lineView             = UIView(frame: CGRectMake(15, 39.5, width, 0.5))
        lineView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.05)
        self.addSubview(lineView)
        
        let nextPageButton = UIButton(frame : CGRectMake(0, 0, width, 40))
        nextPageButton.tag = nextPageButtonTag
        nextPageButton.addTarget(self, action: #selector(TreeStructureModelCell.buttonEvent(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(nextPageButton)
        
        editButton                  = UIButton(frame: CGRectMake(width - 75, 20, 50, 13))
        editButton.titleLabel?.font = UIFont.systemFontOfSize(8)
        editButton.backgroundColor  = UIColor.blackColor()
        editButton.setTitle("Edit Name", forState: .Normal)
        editButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        editButton.setTitleColor(UIColor.redColor(), forState: .Highlighted)
        editButton.tag = editButtonTag
        
        editButton.addTarget(self, action: #selector(TreeStructureModelCell.buttonEvent(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(editButton)
    }
    
    @objc private func buttonEvent(button : UIButton) {
        
        switch button.tag {
            
        case editButtonTag:
            
            if data?.propertyType == .NSArray {
                
                let structModel       = model?.arrayTypeModelList[(data?.propertyName!)!]
                controller?.editModel = structModel
                controller?.createEditView(structModel!.modelName)
                
            } else if data?.propertyType == .NSDictionary {
                
                let structModel       = model?.dictionaryTypeModelList[(data?.propertyName!)!]
                controller?.editModel = structModel
                controller?.createEditView(structModel!.modelName)
            }
            
        case nextPageButtonTag:
            
            if data?.propertyType == .NSArray {
                
                let viewController                  = JSONDataTreeStructureModelController()
                viewController.treeStructureModel   = model?.arrayTypeModelList[(data?.propertyName!)!]
                viewController.isRootViewController = false
                viewController.title                = viewController.treeStructureModel!.modelName
                controller?.navigationController?.pushViewController(viewController, animated: true)
                
            } else if data?.propertyType == .NSDictionary {
                
                let viewController                  = JSONDataTreeStructureModelController()
                viewController.treeStructureModel   = model?.dictionaryTypeModelList[(data?.propertyName!)!]
                viewController.isRootViewController = false
                viewController.title                = viewController.treeStructureModel!.modelName
                controller?.navigationController?.pushViewController(viewController, animated: true)
            }
            
        default: break}
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData() {
        
        if let data = data {
            
            if data.propertyType == .NSString {
                
                nameLabel.text       = data.propertyName
                typeLabel.text       = "NSString"
                typeLabel.textColor  = UIColor.blackColor().colorWithAlphaComponent(0.4)
                nameLabel.textColor  = UIColor.blackColor().colorWithAlphaComponent(0.6)
                listLabel.hidden     = true
                nextImageView.hidden = true
                editButton.hidden    = true
                
            } else if data.propertyType == .NSNumber {
                
                nameLabel.text       = data.propertyName
                typeLabel.text       = "NSNumber"
                typeLabel.textColor  = UIColor.blackColor().colorWithAlphaComponent(0.4)
                nameLabel.textColor  = UIColor.blackColor().colorWithAlphaComponent(0.6)
                listLabel.hidden     = true
                nextImageView.hidden = true
                editButton.hidden    = true
                
            } else if data.propertyType == .Null {
                
                nameLabel.text       = data.propertyName
                typeLabel.text       = "Null"
                typeLabel.textColor  = UIColor.grayColor()
                nameLabel.textColor  = UIColor.blackColor().colorWithAlphaComponent(0.6)
                listLabel.hidden     = true
                nextImageView.hidden = true
                editButton.hidden    = true
                
            } else if data.propertyType == .NSDictionary {
                
                nameLabel.text       = data.propertyName
                typeLabel.text       = "NSDictionary"
                typeLabel.textColor  = UIColor.redColor()
                listLabel.textColor  = UIColor.redColor()
                nameLabel.textColor  = UIColor.blackColor()
                listLabel.hidden     = false
                nextImageView.hidden = false
                editButton.hidden    = false
                
                if let structureModel = self.model?.dictionaryTypeModelList[data.propertyName!] {
                    
                    listLabel.text = "\(structureModel.modelName!)"
                }
                
            } else if data.propertyType == .NSArray {
                
                nameLabel.text       = data.propertyName
                typeLabel.text       = "NSArray"
                typeLabel.textColor  = UIColor.blueColor()
                listLabel.textColor  = UIColor.blueColor()
                nameLabel.textColor  = UIColor.blackColor()
                listLabel.hidden     = false
                nextImageView.hidden = false
                editButton.hidden    = false
                
                if let structureModel = self.model?.arrayTypeModelList[data.propertyName!] {
                    
                    listLabel.text = "[ \(structureModel.modelName!) ]"
                }
            }
        }
    }
}

// MARK: private - [Class] BackgroundLineView

private class BackgroundLineView: UIView {
    
    // MARK: Properties.
    
    /// Line width, default is 5.
    var lineWidth : CGFloat {
        
        get {return backgroundView.lineWidth}
        
        set(newVal) {
            
            backgroundView.lineWidth = newVal
            backgroundView.setNeedsDisplay()
        }
    }
    
    /// Line gap, default is 3.
    var lineGap : CGFloat {
        
        get {return backgroundView.lineGap}
        
        set(newVal) {
            
            backgroundView.lineGap = newVal
            backgroundView.setNeedsDisplay()
        }
    }
    
    /// Line color, default is grayColor.
    var lineColor : UIColor {
        
        get {return backgroundView.lineColor}
        
        set(newVal) {
            
            backgroundView.lineColor = newVal
            backgroundView.setNeedsDisplay()
        }
    }
    
    /// Rotate value, default is 0.
    var rotate : CGFloat {
        
        get {return backgroundView.rotate}
        
        set(newVal) {
            
            backgroundView.rotate = newVal
            backgroundView.setNeedsDisplay()
        }
    }
    
    convenience init(frame: CGRect, lineWidth : CGFloat, lineGap : CGFloat, lineColor : UIColor, rotate : CGFloat) {
        
        self.init(frame : frame)
        self.lineWidth = lineWidth
        self.lineGap   = lineGap
        self.lineColor = lineColor
        self.rotate    = rotate
    }
    
    // MARK: Override system method.
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        setupBackgroundView()
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.layer.masksToBounds = true
        self.addSubview(backgroundView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private value & func.
    
    private let backgroundView = LineBackground(length: 0)
    
    private func setupBackgroundView() {
        
        let drawLength        = sqrt(self.bounds.size.width * self.bounds.size.width + self.bounds.size.height * self.bounds.size.height)
        backgroundView.frame  = CGRectMake(0, 0, drawLength, drawLength)
        backgroundView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0)
        backgroundView.setNeedsDisplay()
    }
}

// MARK: private - [Class] LineBackground

private class LineBackground : UIView {
    
    private var rotate    : CGFloat = 0
    private var lineWidth : CGFloat = 5
    private var lineGap   : CGFloat = 3
    private var lineColor : UIColor = UIColor.grayColor()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(length : CGFloat) {
        
        self.init(frame : CGRectMake(0, 0, length, length))
    }
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
        guard self.bounds.size.width > 0 && self.bounds.size.height > 0 else {
            
            return
        }
        
        let context      = UIGraphicsGetCurrentContext()
        let width        = self.bounds.size.width
        let height       = self.bounds.size.height
        let drawLength   = sqrt(width * width + height * height)
        let outerX       = (drawLength - width)  / 2.0
        let outerY       = (drawLength - height) / 2.0
        let tmpLineWidth = lineWidth <= 0 ? 5 : lineWidth
        let tmpLineGap   = lineGap   <= 0 ? 3 : lineGap
        
        var red   : CGFloat = 0
        var green : CGFloat = 0
        var blue  : CGFloat = 0
        var alpha : CGFloat = 0
        
        CGContextTranslateCTM(context, 0.5 * drawLength, 0.5 * drawLength)
        CGContextRotateCTM(context, rotate)
        CGContextTranslateCTM(context, -0.5 * drawLength, -0.5 * drawLength)
        
        lineColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        CGContextSetRGBFillColor(context, red, green, blue, alpha)
        
        var currentX = -outerX
        
        while currentX < drawLength {
            
            CGContextAddRect(context, CGRectMake(currentX, -outerY, tmpLineWidth, drawLength))
            currentX += tmpLineWidth + tmpLineGap
        }
        
        CGContextFillPath(context)
    }
}


