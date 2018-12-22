
//
//  NotificationVC.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//


import UIKit
import FirebaseDatabase
import ObjectMapper
import AVFoundation
class NotificationVC:BaseVC,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    lazy var collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 2 // space between cell in difference row
        flowLayout.minimumInteritemSpacing = 0 // space between cell in same row
        let cv = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        cv.alwaysBounceVertical = true //when reach  bottom element it still scroll down or up a size
        cv.backgroundColor = .white
        return cv
    }()
//    var notifications:[NotificationModel] =  {
//        var arr = [
//            NotificationModel(id: 1, title: "Bài đăng của bạn đã được duyệt", date: Date()),
//            NotificationModel(id: 2, title: "Bài đăng của bạn đã được duyệt", date: Date()),
//            NotificationModel(id: 3, title: "Bài đăng của bạn đã được duyệt", date: Date()),
//            ]
//        return arr
//    }()
    
    lazy var user = DBManager.shared.getUser()
    lazy var ref = Database.database().reference().child("notifications/users").child("\(self.user!.userId)")
    var notifications:[NotificationMappableModel] = []
    var newNotifications:[NotificationMappableModel] = []
    //MARK: ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initData
        
        //SetupUI
        setupUI()
        observeNotification()
    }
    func setupUI() {
        //For collectionView
        
        navigationController?.navigationBar.isHidden = true
        view.addSubview(collectionView)
        _ = collectionView.anchorTopLeft( view.topAnchor,  view.leftAnchor,  view.widthAnchor,  view.heightAnchor)
        collectionView.register(NotificationCVCell.self, forCellWithReuseIdentifier:Constants.CELL_NOTIFICATIONCV)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //For top right title of notification
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    //MARK: Notification
    func observeNotification(){
        BaseVC.refToObserveNotification = ref
        ref.observe(.childAdded)
                { (snapshot) in
                    if let dic = snapshot.value as? [String:AnyObject],let model = Mapper<NotificationMappableModel>().map(JSON: dic){
                        if model.userId == self.user?.userId{
                            model.notificationId = snapshot.key
                            self.notifications.append(model)
                            self.updateUI()
                            if model.status == Constants.NEW || model.status == Constants.NEW_LOADED{
                                AudioServicesPlayAlertSound(SystemSoundID(1322))
                                if model.status == Constants.NEW{
                                    
                                    switch model.type {
                                    case Constants.ROOM_ACCEPT_NOTIFICATION:
                                        NotificationCenter.default.post(name: Constants.NOTIFICATION_ACCEPT_ROOM, object: model)
                                    case Constants.ROOM_DENIED_NOTIFICATION:
                                        NotificationCenter.default.post(name: Constants.NOTIFICATION_DECLINE_ROOM, object: model)
                                    case Constants.ADD_MEMBER_NOTIFICATION:
                                        NotificationCenter.default.post(name: Constants.NOTIFICATION_ADD_MEMBER_TO_ROOM, object: model)
                                    case Constants.REMOVE_MEMBER_NOTIFICATION:
                                        NotificationCenter.default.post(name: Constants.NOTIFICATION_REMOVE_MEMBER_IN_ROOM, object: model)
                                    case Constants.UPDATE_MEMBER_NOTIFICATION:
                                        NotificationCenter.default.post(name: Constants.NOTIFICATION_UPDATE_MEMBER_IN_ROOM, object: model)
                                    default:
                                        break
                                    }
                                }
                            }
                        }
                        
                        
                    }
        }
    }
    
    
    //MARK: UICollectionView delegate and datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return notifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CELL_NOTIFICATIONCV, for: indexPath) as! NotificationCVCell
        cell.notification = notifications[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch UIScreen.main.bounds.width {
        case 0...375: //4 to less than 4.7 inch
            return CGSize(width: view.frame.width, height: 80)
        case 376..<768://more than 4,7 to  7.9 inch
            return CGSize(width: view.frame.width, height: 100)
        default://more than 7,9 inch
            return CGSize(width: view.frame.width, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! NotificationCVCell
        ref.child(cell.notification.notificationId).child("status").setValue("\(Constants.SEEN)") { (error, ref) in
            if error == nil{
                if let row = self.notifications.index(of: cell.notification){
                    self.notifications[row].status = Constants.SEEN
                    self.updateUI()
                }
            }
        }
        let vc = NotificationDetailVC()
        vc.notification = cell.notification
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: Custom
    func updateUI(){
        DispatchQueue.main.async {
            if self.notifications.first(where: {$0.status == Constants.NEW || $0.status == Constants.NEW_LOADED}) == nil{
                self.tabBarItem.badgeValue = nil
            }else{
                self.tabBarItem.badgeValue = "●"
                self.tabBarItem.badgeColor = .clear
                self.tabBarItem.setBadgeTextAttributes([NSAttributedStringKey.foregroundColor.rawValue: UIColor.red], for: .normal)
            }
            if self.notifications.count == 0{
                self.showNoDataView(inView: self.collectionView, withTitle: "NO_DATA".localized)
            }else{
                self.hideNoDataView(inView: self.collectionView)
            }
            self.notifications.sort { (lhs, rhs) -> Bool in
                lhs.date > rhs.date
            }
            self.collectionView.reloadData()
        }
    }
}
