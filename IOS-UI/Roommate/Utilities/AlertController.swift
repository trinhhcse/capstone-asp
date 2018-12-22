//
//  AlertViewController.swift
//  Roommate
//
//  Created by TrinhHC on 9/30/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
protocol AlertControllerDelegate {
    func alertControllerDelegate(alertController:AlertController,withAlertType type:AlertType,onCompleted indexs:[IndexPath]?)
    
    func alertControllerDelegate(alertController:AlertController,onSelected selectedIndexs:[IndexPath]?)
    
}
extension AlertControllerDelegate{
    func alertControllerDelegate(alertController:AlertController,onSelected selectedIndexs:[IndexPath]?){}
    func alertControllerDelegate(alertController:AlertController,withAlertType type:AlertType,onCompleted indexs:[IndexPath]?){}
}
class AlertController: UIAlertController,UITableViewDataSource,UITableViewDelegate  {
    var delegate:AlertControllerDelegate?
    var listItem:[String]?
    var listSelectedItemIndex:[Int]?
    var tableView:UITableView!
    var alertType:AlertType = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if alertType != .normal , let listSelectedItemIndex = self.listSelectedItemIndex{
            listSelectedItemIndex.forEach { (row) in
                tableView.selectRow(at: IndexPath(row: row, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.none)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let title = self.title{
            let titleAttrString = NSAttributedString(string: title, attributes: [NSAttributedStringKey.foregroundColor : UIColor.defaultBlue])
            setValue(titleAttrString, forKey: "attributedTitle")
        }
    }
    static func showAlertInfor(withTitle title:String?,forMessage message:String?,inViewController controller:UIViewController) {
        let alertController = AlertController(title: title, message: message, preferredStyle: .alert)
        if let _ = title {
            alertController.addAction(action(title: "OK".localized, style: .default, handler: nil))
        }
        controller.present(alertController, animated: true, completion: nil)
    }
    static func showAlertInfor(withTitle title:String?,forMessage message:String?,inViewController controller:UIViewController,rhsButtonHandler:((UIAlertAction)->Void)?) {
        let alertController = AlertController(title: title, message: message, preferredStyle: .alert)
        if let _ = title {
            alertController.addAction(action(title: "OK".localized, style: .default, handler: rhsButtonHandler))
        }
        controller.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlertInfoWithAttributeString(withTitle title:NSAttributedString?,forMessage message:NSAttributedString?,inViewController controller:UIViewController) {
        let alertController = AlertController(title: nil, message: nil, preferredStyle: .alert)
        if let _ = title {
            alertController.addAction(action(title: "OK".localized, style: .default, handler: nil))
        }
        
        alertController.setValue(title, forKey: "attributedTitle")
        alertController.setValue(message, forKey: "attributedMessage")
        
        controller.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlertConfirm(withTitle title:String?,andMessage message:String?,alertStyle:UIAlertControllerStyle,forViewController controller:UIViewController,lhsButtonTitle:String?,rhsButtonTitle:String?,lhsButtonHandler:((UIAlertAction)->Void)?,rhsButtonHandler:((UIAlertAction)->Void)?){
        let alertController = AlertController(title: title, message: message, preferredStyle: alertStyle)
        if let _ = lhsButtonTitle {
            alertController.addAction(action(title: lhsButtonTitle, style: .cancel, handler: lhsButtonHandler))
        }
        if let _ = rhsButtonTitle {
            alertController.addAction(action(title: rhsButtonTitle, style: .default, handler: rhsButtonHandler))
        }
        controller.present(alertController, animated: true, completion: nil)
    }
    
    static func showAlertList(withTitle title:String?,andMessage message:String?,alertStyle:UIAlertControllerStyle,alertType:AlertType = .normal,isMultiSelected:Bool = false,forViewController controller:UIViewController,data:[String]?,selectedItemIndex:[Int]? = [],rhsButtonTitle:String?)->AlertController{
        let alertController = AlertController(title: title, message: message, preferredStyle: alertStyle)
        if let _ = rhsButtonTitle {
            alertController.addAction(action(title: rhsButtonTitle, style: .default, handler: { (action) in
                alertController.delegate?.alertControllerDelegate(alertController: alertController, withAlertType: alertType, onCompleted: alertController.tableView.indexPathsForSelectedRows)
            }))
            
        }
        alertController.addAction(action(title: "CANCEL".localized, style: .cancel, handler: nil))
        
        alertController.alertType = alertType
        alertController.listItem = data
        alertController.listSelectedItemIndex = selectedItemIndex
        alertController.addTableView(withCellIdentifier: Constants.CELL_POPUP_SELECT_LISTTV,isMultiSelected:isMultiSelected)
        controller.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    static func showAlertInputUtility(withTitle title:String?,andMessage message:String?,alertStyle:UIAlertControllerStyle,forViewController controller:UIViewController,lhsButtonTitle:String?,rhsButtonTitle:String?,lhsButtonHandler:((UIAlertAction)->Void)?,rhsButtonHandler:((UIAlertAction)->Void)?){
        let alertController = AlertController(title: title, message: message, preferredStyle: alertStyle)
        
        if let _ = lhsButtonTitle {
            alertController.addAction(action(title: lhsButtonTitle, style: .default, handler: lhsButtonHandler))
        }
        if let _ = rhsButtonTitle {
            alertController.addAction(action(title: rhsButtonTitle, style: .default, handler: rhsButtonHandler))
        }
        
        let vc = Utilities.vcFromStoryBoard(vcName: Constants.VC_UTILITY_INPUT, sbName: Constants.STORYBOARD_MAIN)
        vc.view.backgroundColor = .red
//        vc.view.frame = alertController.view.frame
//
//        //Size of content in popup viewcontroller
        vc.preferredContentSize  = CGSize(width: 242,
                                          height:  200)
        
//        customView.isUserInteractionEnabled = true
        vc.view.isUserInteractionEnabled = true
        alertController.setValue(vc, forKey: "contentViewController")
        controller.present(alertController, animated: true, completion: nil)
        
    }
    
    func addTableView(withCellIdentifier cellIdentifier:String,isMultiSelected:Bool) {
        tableView =  UITableView()
        tableView.separatorStyle = .none
        //Create View Controller and TableView
        let vc = UIViewController()
        
        let height = listItem!.count*50 < 400 ? listItem!.count*50 : 400
        
        //Size of content in popup viewcontroller
        vc.preferredContentSize  = CGSize(width: 242,
                                          height:  height)
        
        tableView.register(UINib.init(nibName: Constants.CELL_POPUP_SELECT_LISTTV, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.frame = CGRect(x: 0, y: 0, width: 242, height: height)
        tableView.dataSource = self
        tableView.delegate = self
        vc.view.addSubview(tableView)
        vc.view.bringSubview(toFront: tableView)
        
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = isMultiSelected
        vc.view.isUserInteractionEnabled = true
        self.setValue(vc, forKey: "contentViewController")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listItem?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CELL_POPUP_SELECT_LISTTV) as! PopupSelectListTVCell
        cell.lblTitle.text = self.listItem![indexPath.row]
        cell.backgroundColor = .clear
        
//        cell.isSelected = self.listSelectedItemIndex?.contains(indexPath.row) ?? false
        print(self.listItem![indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.alertControllerDelegate(alertController: self, onSelected: tableView.indexPathsForSelectedRows)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    static func action(title: String?, style: UIAlertActionStyle, handler: ((UIAlertAction)->Void)?) ->UIAlertAction{
        let action = UIAlertAction(title: title, style: style, handler: handler)
        action.setValue(UIColor.defaultBlue, forKey: "titleTextColor")
        return action
    }
}
