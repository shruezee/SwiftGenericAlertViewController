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

