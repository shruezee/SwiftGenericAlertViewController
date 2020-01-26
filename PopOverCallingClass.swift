//
//  PopOverCallingClass.swift
//  GenericPopovers
//
//  Created by Shruthi on 15/09/2016.
//  Copyright © 2016 Shruthi. All rights reserved.
//

import Foundation
import UIKit
import GenericPopover

/**
 Generic popover presenting viewcontroller
 */
class SomeViewController: UIViewController,PopoverDelegate {
    
    @IBAction func popOverTableContentPressed(sender: AnyObject) {
      
      let utility = Utility.getTableContentViewController()
      
        if let vc = utility as? TableContentViewController {
            vc.modalPresentationStyle = .overCurrentContext
          vc.popOverDelegate = self as PopoverDelegate
            self.present(vc, animated: false, completion: nil)
        }

    }

    @IBAction func popOverImageContentPressed(sender: AnyObject) {
//        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageContentViewController") as? ImageContentViewController {
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.popOverDelegate = self
//            self.present(vc, animated: false, completion: nil)
//        }
//
    }

    @IBAction func popOverTextContentPressed(sender: AnyObject) {
//        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "InputContentViewController") as? InputContentViewController {
//            vc.modalPresentationStyle = .overCurrentContext
//            vc.popOverDelegate = self
//            self.present(vc, animated: false, completion: nil)
//        }
//
    }

    @IBAction func showAlertPressed(sender: AnyObject) {
//        let vc = AlertViewController()
//        vc.modalPresentationStyle = .overCurrentContext
//            vc.popOverDelegate = self
//        self.present(vc, animated: false, completion: nil)
    }


    func didDissmissPopover(withData: AnyObject) {
        print("\(withData)")
       /// handle popOver dissmiss data here
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  

}

