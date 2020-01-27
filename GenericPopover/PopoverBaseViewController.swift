//
//  PopoverBaseViewController.swift
//  GenericPopovers
//
//  Created by Shruthi on 8/09/2016.
//  Copyright © 2016 Shruthi. All rights reserved.
//

import UIKit

/**
 Usage :
 -Returns closePressedCallback : must be implemented by subclass to dismiss popover
 -Stored Properties : subclass must override stored properties to get new title, subtitle, contentHeight
 * viewContent should be added with contentsubview
 
 -Dependency : 1. ThemeColor structure and UIColor with Hex extension
 2. Custom font added to pList and Font folder should be imported
 3. PresentationManager and Transition delegate should be implemented in calling class performSegueMethod
 */
public class PopOverViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private let margin              = CGSize(width: 16, height: 20)
    private let headerViewHeight    = CGFloat(118) // 20 for cardview, 30 header title, 60 subtitle 3 lines max , 8 spacing
    private let buttonWidth         = CGFloat(15)
    private let cardHeight          = CGFloat(20)
    private let titleHeight         = CGFloat(40)
    private let subTitleHeight      = CGFloat(50)
    private let viewHeader          = UIView()
    private let lblTitle = UILabel()
    
    private func updateFrame() {
        viewContent.bounds.size.height = heightOfContent
        viewHeader.frame.size.height = headerViewHeight + heightOfContent
    }
    private func updateLabel() {
        lblTitle.textAlignment = textAlignment
    }
    
    //MARK: Stored properties overriden by subview
    var heightOfContent     : CGFloat = 0 {
        didSet {
            print("the height is \(heightOfContent)")
            updateFrame()
        }
    }
    var textAlignment       : NSTextAlignment = .justified {
        didSet {
            updateLabel()
        }
    }
    var strHeaderTitle      : String = "Sample Image Popover"
    var strSubTitle         : String = "Try all the options and use this popover sample in your Apps"
    var isShowClose         : Bool = true
    var colorOfCard         : UIColor = UIColor.red
    var viewContent         : UIView = UIView()
    
    var closePressedCallback:(AnyObject)->() = { _ in }
    
    //MARK:- Life Cycle
  override public func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        setupDimmingView()
        
        viewHeader.alpha = 0
    }
    
    let dimmingVIew = UIView()
    func setupDimmingView() {
        dimmingVIew.frame = view.bounds
        dimmingVIew.backgroundColor = UIDimensionConstant.tDimColor
        dimmingVIew.alpha = 0.65
        
        view.insertSubview(dimmingVIew, at: 0)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss(sender:)))
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
    }
    @objc func dismiss(sender: AnyObject) {
        self.dimmingVIew.alpha = 0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.dismiss( animated: true, completion: nil)
            self.closePressedCallback(sender)
        })
    }
    
    
  override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let temp = viewHeader.frame.origin.y
        viewHeader.frame.origin.y = view.frame.size.height
        UIView.animate(withDuration: 0.3, animations: {
            self.viewHeader.frame.origin.y = temp
            self.viewHeader.alpha = 1
        })

    }
    
    
    /** - set HeaderView
     */
    private func setHeader() {
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismiss(sender:)))
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
        
        view.backgroundColor = UIColor.clear
        
        viewHeader.frame.size = CGSize(width: view.frame.size.width - 40 , height: headerViewHeight + heightOfContent)
        viewHeader.center = view.center
        
        viewHeader.backgroundColor = ThemeColour().primaryColour
        
        var viewY = CGFloat(0)
        
        let viewCard = UIView(frame: CGRect(x: 0, y: viewY, width: view.frame.size.width - (margin.width * 2.5), height: cardHeight))
        viewCard.backgroundColor = colorOfCard
        viewHeader.addSubview(viewCard)
        /// for top curved header view
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: viewCard.bounds, byRoundingCorners: UIRectCorner.topLeft.union(.topRight), cornerRadii: CGSize(width: UIDimensionConstant.tCornerRadius, height: UIDimensionConstant.tCornerRadius)).cgPath
        viewCard.layer.mask = maskLayer
        
        viewY += cardHeight
        
        lblTitle.frame =  CGRect(x: margin.width, y: viewY, width: view.frame.size.width - (margin.width * 4), height: titleHeight)
        lblTitle.text = strHeaderTitle
        
        let param :[String: AnyObject] = [
          "font"              : UIFont.systemFont(ofSize: 21),
            "backgroundColor"   : UIColor.clear,
            "textColor"         : ThemeColour().secondaryTextColor,
            "textAlignment"     : textAlignment.rawValue as AnyObject
        ]
        
        lblTitle.applyTheme(params: param)
        
        viewHeader.addSubview(lblTitle)
        
        let btnClose = UIButton(frame: CGRect(x: view.frame.size.width - (margin.width * 2) - (buttonWidth * 2), y: viewY + 10, width: buttonWidth, height: buttonWidth))
      btnClose.setTitle("X", for: .normal)
//        btnClose.setBackgroundImage(UIImage(named: "popover-close-icon.png"), for: UIControl.State())
        btnClose.addTarget(self, action: #selector(dismiss(sender:)), for: .touchUpInside)
        viewHeader.addSubview(btnClose)
        
        viewY += titleHeight
        
        let lblSubTitle = UILabel(frame: CGRect(x: margin.width, y: viewY, width: view.frame.size.width - (margin.width * 4), height: subTitleHeight))
        lblSubTitle.lineBreakMode = .byWordWrapping
        lblSubTitle.numberOfLines = 3
        lblSubTitle.text = strSubTitle
        
        let paramSub :[String: AnyObject] = [
            "font" : UIFont.systemFont(ofSize: 16),
            "backgroundColor": UIColor.clear,
            "textColor" : ThemeColour().secondaryTextColor,
            "textAlignment"     : textAlignment.rawValue as AnyObject
        ]
        lblSubTitle.applyTheme(params: paramSub)
        
        viewHeader.addSubview(lblSubTitle)
        
        viewY += subTitleHeight
        
        viewY += cardHeight
        
        viewContent.backgroundColor = UIColor.clear
        viewContent.center = CGPoint(x: viewHeader.center.x, y:view.center.y)
        viewContent.frame = CGRect(x: 0, y: viewY, width: viewHeader.frame.size.width, height: heightOfContent)
        viewHeader.addSubview(viewContent)
        
                viewHeader.layer.cornerRadius = UIDimensionConstant.tCornerRadius
        viewHeader.clipsToBounds = true
        
        view.addSubview(viewHeader)
        if isShowClose == false {
            btnClose.isHidden = true
        }
    }
    
  override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- gesture recogniser delegate
  public func gestureRecognizer( _ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view != view) { // accept only touchs on superview, not accept touchs on subviews
            return false
        }
        
        return true
    }

}

//
//  PopOverSubClasses Begin
//

public protocol PopoverDelegate {
    func didDissmissPopover(withData: AnyObject)
}

/**
 PopoverAlertTableCell
 */
class PopoverAlertCell: UITableViewCell {
    @IBOutlet weak var lblAlertname: UILabel!
    @IBOutlet weak var imgViewAlertIcon: UIImageView!
}

public class Utility {

    public static func getTableContentViewController() -> TableContentViewController {

            let storyboard = UIStoryboard.init(name: "PopOverSample", bundle: Bundle(for: self))
      let tableContentViewController:TableContentViewController = storyboard.instantiateViewController(withIdentifier: "TableContentViewController") as! TableContentViewController
            return tableContentViewController
    }
  
  public static func getImageContentViewController() -> ImageContentViewController {

             let storyboard = UIStoryboard.init(name: "PopOverSample", bundle: Bundle(for: self))
    let imageContentViewController:ImageContentViewController = storyboard.instantiateViewController(withIdentifier: "ImageContentViewController") as! ImageContentViewController
             return imageContentViewController
     }
  
  public static func getInputContentViewController() -> InputContentViewController {

             let storyboard = UIStoryboard.init(name: "PopOverSample", bundle: Bundle(for: self))
    let inputContentViewController:InputContentViewController = storyboard.instantiateViewController(withIdentifier: "InputContentViewController") as! InputContentViewController
             return inputContentViewController
     }

}

/**
 sample class to subclass and Implement popoverviewcontroller with tableview in content view
 */
public class TableContentViewController: PopOverViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView! // this is just to set cell
    
    private var tableData:[String] = ["Set Alarm", "Share", "Edit", "Remove"]
    private var imageData:[String] = ["Popover-menu-edit-icon.png","Popover-menu-share-icon","Popover-menu-edit-icon","Popover-menu-remove-icon"]
    var _viewContent: UIView = UIView()
//
    override var strHeaderTitle: String {
        get {
            return "Sample Table Popover"
        }
        set {
            //Do nothing
        }
    }

    override var textAlignment: NSTextAlignment {
        get {
            return NSTextAlignment.center
        }
        set {
            // Nothing
        }
    }
    
    override var strSubTitle: String {
        get {
            return "Awesomness is to have tableview in Popover"
        }
        set {
            // Nothing
        }
    }
    
    override var colorOfCard: UIColor {
        get {
            return ThemeColour().greenColour
        }
        set {
            //Do nothing
        }
    }

    override var viewContent: UIView {
        get {
            return _viewContent
        }
        set {
            //Do nothing
        }
    }

    override var heightOfContent: CGFloat {
        get {
            return CGFloat(tableData.count * 50) // height of cell
        }
        set {
            // Do nothing
        }
        
    }
    
   public var popOverDelegate : PopoverDelegate?
    
    //MARK: View Life Cycle
  override public func viewDidLoad() {
        super.viewDidLoad()
       
        setupContentView()

        super.closePressedCallback = { _ in
            if let current = self.popOverDelegate {
                current.didDissmissPopover(withData: "send popover data here" as AnyObject)
            }
        }
    }
    
    private func setupContentView() {
        _viewContent.backgroundColor = UIColor.clear
        let _table = UITableView(frame: _viewContent.bounds, style: .plain)
        _table.backgroundColor = UIColor.clear
        _table.removeFromSuperview()
        _viewContent.addSubview(_table)
        _table.dataSource = self
        _table.delegate = self
        _table.tableFooterView = UIView()
        
    }
    
  override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Table Datasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell( withIdentifier: "PopoverAlertCell") as! PopoverAlertCell
        
        cell.lblAlertname.text = tableData[(indexPath as NSIndexPath).row]
        cell.lblAlertname.textColor = UIColor.white
        if let _image = UIImage(named: imageData[(indexPath as NSIndexPath).row]) {
            cell.imgViewAlertIcon.image = _image
        }
        
        return cell
    }
    
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(tableData[(indexPath as NSIndexPath).row]) tapped")
    }
    
}


/**
 sample class to subclass and Implement popoverviewcontroller with Image
 */
public class ImageContentViewController: PopOverViewController {
    
    @IBOutlet weak var imageContentView: UIView!
    
    override var colorOfCard: UIColor {
        get {
            return ThemeColour().redColour
        }
        set {
            //Do nothing
        }
    }
    
    override var heightOfContent: CGFloat {
        get {
            return CGFloat(300)//CGFloat(50) // height of view
        }
        set {
            // Do nothing
        }
        
    }
    public var popOverDelegate : PopoverDelegate?
    
    //MARK: View Life Cycle
  override public func viewDidLoad() {
        super.viewDidLoad()
        
        imageContentView.removeFromSuperview()
        imageContentView.frame = viewContent.bounds
        viewContent.addSubview(imageContentView)
        
        super.closePressedCallback = { _ in
            if let current = self.popOverDelegate {
                current.didDissmissPopover(withData: "send popover data here" as AnyObject)
            }
        }
    }
    
  override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
  override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


/**
 sample class to subclass and Implement Button and ipText
 */
public class InputContentViewController: PopOverViewController, UITextFieldDelegate {
    var viewButtons: UIView = UIView()
    
    @objc func button1Pressed(sender: UIButton) {
        print("button 1 pressed with title \(String(describing: sender.titleLabel?.text))")
        dismiss(sender: sender)
    }
    func button2Pressed(sender: UIButton) {
        print("button 2 pressed with title \(String(describing: sender.titleLabel?.text))")
        dismiss(sender: sender)
    }
    
    override var strHeaderTitle: String {
        get {
            return "Sample Feedback Popover"
        }
        set {
            //Do nothing
        }
    }
    
    override var strSubTitle: String {
        get {
            return "Are you sure that you want to logout of Sample? Please give feedback"
        }
        set {
            // Nothing
        }
    }

    override var colorOfCard: UIColor {
        get {
            return ThemeColour().blueColour
        }
        set {
            //Do nothing
        }
    }
    
    override var heightOfContent: CGFloat {
        get {
            return CGFloat(100) // height of view
        }
        set {
            // Do nothing
        }
        
    }
    
    private func setupAppearences(forButton:UIButton) {
        forButton.setTitleColor(UIColor.white, for: UIControl.State())
        forButton.backgroundColor  = ThemeColour().lightOfGrey
        forButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 15)
    }
    
    private func setupContentView() {
        viewButtons.backgroundColor = UIColor.clear
        
        let button1 = UIButton(type: .system)
        button1.setTitle("YES", for: UIControl.State())
        button1.addTarget(self, action: #selector(button1Pressed(sender:)), for: .touchUpInside)
        button1.frame = CGRect(x: 0, y: 50, width: viewButtons.frame.size.width / 2, height: 50)
        
        setupAppearences(forButton: button1)
        
        let button2 = UIButton(type: .system)
        button2.setTitle("NO", for: UIControl.State())
        button2.addTarget(self, action: #selector(button1Pressed(sender:)), for: .touchUpInside)
        button2.frame = button1.frame
        button2.frame.origin.x = (viewButtons.frame.size.width / 2)
        setupAppearences(forButton: button2)
        
        let ipText = UITextField(frame: CGRect(x: 8, y: viewButtons.frame.origin.y, width: viewButtons.frame.size.width-16, height: 40))
        ipText.backgroundColor = UIColor.white
        ipText.placeholder = "Feedback here.."
        ipText.delegate = self
        viewButtons.addSubview(ipText)
        
        viewButtons.addSubview(button1)
        viewButtons.addSubview(button2)
    }
    
    public var popOverDelegate : PopoverDelegate?
    
    //MARK: View Life Cycle
  override public func viewDidLoad() {
        super.viewDidLoad()
        
        viewButtons.frame = viewContent.bounds
        setupContentView()
        viewContent.addSubview(viewButtons)
        
        super.closePressedCallback = { _ in
            if let current = self.popOverDelegate {
                current.didDissmissPopover(withData: "send popover data here" as AnyObject)
            }
        }
    }
    
  public func textFieldDidBeginEditing(_ textField: UITextField) {
        view.frame.origin.y -= viewButtons.frame.size.height
    }
    
  public func textFieldDidEndEditing(_ textField: UITextField) {
        view.frame.origin.y += viewButtons.frame.size.height
    }
    
  override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
  override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

/**
 sample class to subclass and Implement as alert view
 */
public class AlertViewController: PopOverViewController {
    var viewButtons: UIView = UIView()
    
    @objc func button1Pressed(sender: UIButton) {
        print("button 1 pressed with title \(String(describing: sender.titleLabel?.text))")
        dismiss(sender: sender)
    }
    @objc func button2Pressed(sender: UIButton) {
        print("button 2 pressed with title \(String(describing: sender.titleLabel?.text))")
        dismiss(sender: sender)
    }
    
    override var strHeaderTitle: String {
        get {
            return "Sample Alert Popover"
        }
        set {
            //Do nothing
        }
    }
    
    override var strSubTitle: String {
        get {
            return "Simple AlertView with custom colors."
        }
        set {
            // Nothing
        }
    }
    
    override var colorOfCard: UIColor {
        get {
            return ThemeColour().primaryColour
        }
        set {
            //Do nothing
        }
    }
    
    override var heightOfContent: CGFloat {
        get {
            return CGFloat(60) // height of view
        }
        set {
            // Do nothing
        }
        
    }
    
    override var isShowClose: Bool {
        get {
            return false
        }
        set {
            // NOthing to set
        }
    }
    
    override var textAlignment: NSTextAlignment {
        get {
            return NSTextAlignment.center
        }
        set {
            //
        }
    }
    
    private func setupAppearences(forButton:UIButton) {
        forButton.setTitleColor(UIColor.white, for: UIControl.State())
        forButton.backgroundColor  = ThemeColour().greyColour
        forButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 15)
    }
    
    private func setupContentView() {
        viewButtons.backgroundColor = UIColor.clear
        
        let button1 = UIButton(type: .system)
        button1.setTitle("Cancel", for: UIControl.State())
        button1.addTarget(self, action: #selector(button1Pressed(sender:)), for: .touchUpInside)
        button1.frame = CGRect(x: 0, y: 0, width: (viewButtons.frame.size.width / 2) - 1, height: 50)
        
        setupAppearences(forButton: button1)
        
        let button2 = UIButton(type: .system)
        button2.setTitle("OK", for: UIControl.State())
        button2.addTarget(self, action: #selector(button2Pressed(sender:)), for: .touchUpInside)
        button2.frame = button1.frame
        button2.frame.origin.x = (viewButtons.frame.size.width / 2)
        setupAppearences(forButton: button2)
        
        viewButtons.addSubview(button1)
        viewButtons.addSubview(button2)
    }
    
   public var popOverDelegate : PopoverDelegate?
    
    //MARK: View Life Cycle
  override public func viewDidLoad() {
        super.viewDidLoad()
        
        viewButtons.frame = viewContent.bounds
        setupContentView()
        viewContent.addSubview(viewButtons)

        super.closePressedCallback = { _ in
            if let current = self.popOverDelegate {
                current.didDissmissPopover(withData: "send popover data here" as AnyObject)
            }
        }
    }
    
  override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
