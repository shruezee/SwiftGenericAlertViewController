//
//  PopOverSubClasses.swift
//  GenericPopovers
//
//  Created by Shruthi on 15/09/2016.
//  Copyright © 2016 Shruthi. All rights reserved.
//

import Foundation
import UIKit

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
