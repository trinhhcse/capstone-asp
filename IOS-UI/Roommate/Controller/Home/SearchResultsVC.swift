//
//  SearchResultsVC.swift
//  Roommate
//
//  Created by TrinhHC on 11/21/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import MBProgressHUD
class SearchResultsVC: BaseVC,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LocationSearchViewDelegate,RoomCVCellDelegate,UISearchControllerDelegate,UISearchBarDelegate ,SearchVCDelegate{
    
    
    
    
    //MARK: Components for UICollectionView
    lazy var collectionView:BaseVerticalCollectionView = {
        let cv = BaseVerticalCollectionView()
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.bounces = false
        //        (cv.collectionViewLayout as UICollectionViewFlowLayout).headerReferenceSize  = CGSize(width: self.view.frame.size.width, height: 30.0)
        return cv
    }()
    lazy var locationSearchView:LocationSearchView = {
        let lv:LocationSearchView = .fromNib()
        return lv
    }()
    lazy var searchResultVC:SearchVC = {
        let vc = SearchVC()
        vc.delegate = self
        return vc
    }()
    lazy var searchController:UISearchController = {
        let sc = UISearchController(searchResultsController: searchResultVC)
        sc.delegate  = self
        sc.searchResultsUpdater = searchResultVC //Show this vc for result
        sc.dimsBackgroundDuringPresentation = false //Làm mờ khi show result vc
        definesPresentationContext = true //Modal type - show result vc over parent vc
        
        sc.searchBar.delegate = self
        // searchBar represent for searchcontroller in parent vc
        sc.hidesNavigationBarDuringPresentation = false
        sc.searchBar.searchBarStyle = .prominent
        sc.searchBar.placeholder = "Search Place"
        sc.searchBar.sizeToFit()
        sc.searchBar.barTintColor = .white
        sc.searchBar.tintColor = .defaultBlue
        return sc
    }()
    var searchRequestModel:SearchRequestModel = SearchRequestModel()
    var searchResults:SearchResponseModel?{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    var setting:SettingModel?{
        get{
            return DBManager.shared.getSingletonModel(ofType: SettingModel.self)
        }
    }
    var cities:[CityModel]?
    //MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAndLoadInitData(view: self.collectionView){
            self.setupUI()
            self.setDelegateAndDataSource()
        }
        
        //        checkInitData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
            self.navigationController?.navigationBar.backgroundColor = .white
            self.searchController.searchBar.setShowsCancelButton(true, animated: true)
        }
    }
    
    func setupUI(){
        title = "SEARCH".localized
        
        setBackButtonForNavigationBar()
        //Add View
        view.addSubview(collectionView)
        
        navigationItem.titleView = searchController.searchBar
        let leftItem = UIBarButtonItem(customView: locationSearchView)
        _ = leftItem.customView?.anchorHeight(equalToConstrant: navigationItem.titleView!.frame.height)
        _ = leftItem.customView?.anchorWidth(equalToConstrant: Constants.WIDTH_LOCATION_VIEW)
        navigationItem.leftBarButtonItem = leftItem
        
        //Add Constraints
        if #available(iOS 11.0, *) {
            _ = collectionView.anchor(view.safeAreaLayoutGuide.topAnchor, view.leftAnchor, view.safeAreaLayoutGuide.bottomAnchor, view.rightAnchor,UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: -2, right: -Constants.MARGIN_10))
        } else {
            // Fallback on earlier versions
            _ = collectionView.anchor(topLayoutGuide.bottomAnchor, view.leftAnchor, bottomLayoutGuide.topAnchor, view.rightAnchor,UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: -2, right: -Constants.MARGIN_10))
        }
        
    }
    func setDelegateAndDataSource(){
        
        collectionView.register(UINib(nibName: Constants.CELL_ROOMPOSTCV, bundle: Bundle.main), forCellWithReuseIdentifier: Constants.CELL_ROOMPOSTCV)
        collectionView.register(UINib(nibName: Constants.CELL_ICONTITLECV, bundle: Bundle.main),forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.CELL_ICONTITLECV)
        locationSearchView.delegate = self
        searchController.searchBar.showsCancelButton = true
        self.locationSearchView.location = DBManager.shared.getRecord(id: (self.setting?.cityId)!, ofType: CityModel.self)?.name ?? "LIST_CITY_TITLE".localized
        self.cities =  DBManager.shared.getRecords(ofType: CityModel.self)?.toArray(type: CityModel.self)
        
    }
    //    func checkInitData(){
    //        if !APIConnection.isConnectedInternet(){
    //            showErrorView(inView: self.collectionView, withTitle: "NETWORK_STATUS_CONNECTED_REQUEST_ERROR_MESSAGE".localized) {
    //                self.checkAndLoadInitData(inView: self.collectionView) { () -> (Void) in
    //                    DispatchQueue.main.async {
    //                        self.setupUI()
    //                        self.setDelegateAndDataSource()
    //
    //                    }
    //                }
    //            }
    //        }else{
    //            self.checkAndLoadInitData(inView: self.collectionView) { () -> (Void) in
    //                DispatchQueue.main.async {
    //                    self.setupUI()
    //                    self.setDelegateAndDataSource()
    //
    //                }
    //            }
    //        }
    //    }
    //MARK: UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dimissEntireNavigationController()
    }
    //MARK: SearchVCDelegate
    func searchVCDelegate(searchVC: SearchVC, onCompletedWithDictionary dictionary: [GPPrediction : GPPlaceResult]) {
        searchController.searchBar.text = dictionary.keys.first?.address
        searchController.searchResultsController?.dismiss(animated: true, completion: nil)
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.endEditing(true)
        searchRequestModel.address = dictionary.keys.first?.address
        searchRequestModel.latitude = dictionary.values.first?.lat
        searchRequestModel.longitude = dictionary.values.first?.lng
        searchResults = nil
        collectionView.reloadData()
        requestSearchData()
    }
    //MARK: LocationSearchViewDelegate
    func locationSearchViewDelegate(locationSearchView view: LocationSearchView, onClickButtonLocation btnLocation: UIButton) {
        if let cities = cities{
            let alert = AlertController.showAlertList(withTitle: "LIST_CITY_TITLE".localized, andMessage: nil, alertStyle: .alert,alertType: .city, forViewController: self, data: cities.map({ (city) -> String     in
                city.name!
            }), rhsButtonTitle: "DONE".localized)
            alert.delegate = self
        }
        
    }
    //MARK: UIAlertControllerDelegate
    override func alertControllerDelegate(alertController: AlertController,withAlertType type:AlertType, onCompleted indexs: [IndexPath]?) {
        guard let indexs = indexs else {
            return
        }
        if type == AlertType.city{
            guard let city = cities?[(indexs.first?.row)!]  else{
                return
            }
            
            guard let setting = DBManager.shared.getSingletonModel(ofType: SettingModel.self) else{
                return
            }
            
            locationSearchView.location = city.name
            let newSetting = SettingModel()
            newSetting.id = setting.id
            newSetting.cityId = city.cityId
            newSetting.latitude = setting.latitude
            newSetting.longitude = setting.longitude
            _ = DBManager.shared.addSingletonModel(ofType: SettingModel.self, object: newSetting)
        }
    }
    
    //MARK: UICollectionView DataSourse and Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? (searchResults?.roomPostResponseModel?.count ?? 0) : (searchResults?.nearByRoomPostResponseModels?.count ?? 0)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searchResults == nil ? 0 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.CELL_ICONTITLECV, for: indexPath) as! IconTitleCVCell
            cell.backgroundColor = .defaultBlue
            cell.tintColor = .white
            cell.imgvIcon.image = UIImage(named: indexPath.section == 0 ? "result" : "nearby")
            cell.lblTitle.text = indexPath.section == 0 ? "\("SEARCH_RESULT".localized) \(searchResults?.roomPostResponseModel?.count ?? 0) \("RESULT".localized)" : "\("SEARCH_NEARBY".localized) \(searchResults?.nearByRoomPostResponseModels?.count ?? 0) \("RESULT".localized)"
            return cell
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Constants.CELL_ROOMPOSTCV, for: indexPath) as! RoomPostCVCell
        cell.delegate = self
        cell.room = indexPath.section == 0 ? searchResults?.roomPostResponseModel![indexPath.row] : searchResults?.nearByRoomPostResponseModels![indexPath.row]
        cell.indexPath = indexPath
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let searchResults = searchResults else {
            return
        }
        let vc = PostDetailVC()
        vc.viewType = ViewType.roomPostDetailForFinder
        vc.room = indexPath.section == 0 ? searchResults.roomPostResponseModel![indexPath.row] : searchResults.nearByRoomPostResponseModels![indexPath.row]
        presentInNewNavigationController(viewController: vc)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2-5, height: Constants.HEIGHT_CELL_ROOMPOSTCV)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width, height: 30.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //dif row space
        return 2
    }
    //MARK: NewRoomCVCellDelegate
    func roomCVCellDelegate(roomCVCell cell: RoomPostCVCell, onClickUIImageView imgvBookmark: UIImageView, atIndextPath indexPath: IndexPath?) {
        if let row = indexPath?.row,let section = indexPath?.section{
            processBookmark(view: self.collectionView, model:section == 0 ? searchResults!.roomPostResponseModel![row] : searchResults!.nearByRoomPostResponseModels![row], row: row) { (model) -> (Void) in
                if model.isFavourite!{
                    NotificationCenter.default.post(name: Constants.NOTIFICATION_ADD_BOOKMARK, object: model)
                }else{
                    NotificationCenter.default.post(name: Constants.NOTIFICATION_REMOVE_BOOKMARK, object: model)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    //MARK: Remote Data
    func  requestSearchData(){
        //        roomFilter.searchRequestModel = nil
        let hub = MBProgressHUD.showAdded(to: self.collectionView, animated: true)
        hub.mode = .indeterminate
        hub.bezelView.backgroundColor = .white
        hub.contentColor = .defaultBlue
        hub.label.text = "SEARCH_LOADING".localized
        DispatchQueue.global(qos: .background).async {
            APIConnection.requestObject(apiRouter: APIRouter.searchPostByAddress(model: self.searchRequestModel), errorNetworkConnectedHander: {
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.collectionView, animated: true)
                    APIResponseAlert.defaultAPIResponseError(controller: self, error: .HTTP_ERROR)
                }
            }, returnType: SearchResponseModel.self) { (result, error, statusCode) -> (Void) in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(for: self.collectionView, animated: true)
                }
                if error == .SERVER_NOT_RESPONSE {
                    DispatchQueue.main.async {
                        APIResponseAlert.defaultAPIResponseError(controller: self, error: .SERVER_NOT_RESPONSE)
                    }
                }else if error == .PARSE_RESPONSE_FAIL {
                    DispatchQueue.main.async {
                        APIResponseAlert.defaultAPIResponseError(controller: self, error: .PARSE_RESPONSE_FAIL)
                    }
                }else{
                    //200
                    if statusCode == .OK{
                        guard let result = result else{
                            return
                        }
                        self.searchResults = result
                        
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
}
