//
//  FilterForRoom.swift
//  Roommate
//
//  Created by TrinhHC on 10/3/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
protocol FilterVCDelegate:class{
    func filterVCDelegate(filterVC:FilterVC,onCompletedWithFilter filter:FilterArgumentModel)
}
class FilterVC: BaseVC ,DropdownListViewDelegate,UtilitiesViewDelegate,GenderViewDelegate,SliderViewDelegate{
    
    
    let scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.bounces = false
        sv.showsVerticalScrollIndicator  = false
        sv.showsHorizontalScrollIndicator  = false
        return sv
    }()
    let contentView:UIView={
        let cv = UIView()
        return cv
    }()
    
    lazy var cityDropdownListView:DropdownListView = {
        let cv:DropdownListView = .fromNib()
        cv.dropdownListViewType = .city
        return cv
    }()
    lazy var districtDropdownListView:DropdownListView = {
        let dv:DropdownListView = .fromNib()
        dv.dropdownListViewType = .district
        return dv
    }()
    
    lazy var priceSliderView:SliderView = {
        let sv:SliderView = .fromNib()
        sv.sliderViewType  = .price
        return sv
    }()
    lazy var genderView:GenderView = {
        let gv:GenderView = .fromNib()
        return gv
    }()
    
    lazy var utilitiesView:UtilitiesView = {
        let uv:UtilitiesView = .fromNib()
//        uv.utilityForSC = .filter
        return uv
    }()
    
    lazy var btnSave:UIButton = {
        let bt = UIButton()
        bt.backgroundColor = .defaultBlue
        bt.tintColor = .white
        return bt
    }()
//    var filterVCType:FilterVCType!
    var filterArgumentModel:FilterArgumentModel!{
        didSet{
            updateUI()
        }
    }
    var utilities:[UtilityMappableModel]?
    var districts:[DistrictModel]?
    var cities:[CityModel]?
    var selectedUtilities:[Int]?
    var selectedCity:CityModel?
    var selectedDistricts:[DistrictModel]?
    var selectedGender:GenderSelect?
    var selectedPrice:[Float]?
    weak var delegate:FilterVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAndLoadInitData(view: self.view){
            self.initData()
            self.setupUI()
            self.setData()
        }
    }
    
    
    func initData(){
        self.utilities = DBManager.shared.getRecords(ofType: UtilityModel.self)?.compactMap({ (utility) -> UtilityMappableModel? in
            UtilityMappableModel(utilityModel: utility)
        })
        self.utilities?.forEach{print($0.name)}
        self.cities = (DBManager.shared.getRecords(ofType: CityModel.self)?.toArray(type: CityModel.self))!
        self.districts = (DBManager.shared.getRecords(ofType: DistrictModel.self)?.toArray(type: DistrictModel.self))!
    }
    
    func setupUI(){
        setBackButtonForNavigationBar()
        edgesForExtendedLayout = .top// view above navigation bar
        let barButtonItem = UIBarButtonItem(title: "RESET".localized, style: .done, target: self, action: #selector(onClickBtnReset))
        barButtonItem.tintColor  = .defaultBlue
        navigationItem.rightBarButtonItem = barButtonItem
        
        let bottomView = UIView()

        //Caculate height
        let defaultBottomViewHeight:CGFloat = 60.0
        let defaultPadding = UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: 0, right: -Constants.MARGIN_10)
        let numberOfRow =  (utilities?.count)!%2==0 ? (utilities?.count)!/2 : (utilities?.count)!/2+1
        let utilitiesViewHeight:CGFloat =  Constants.HEIGHT_CELL_UTILITYCV * CGFloat(numberOfRow) + 70.0
        let contentViewHeight:CGFloat = CGFloat(Constants.HEIGHT_VIEW_SLIDER+Constants.HEIGHT_VIEW_DROPDOWN_LIST*2+Constants.HEIGHT_VIEW_GENDER+utilitiesViewHeight+Constants.HEIGHT_LARGE_SPACE)

        //Add View
        view.addSubview(scrollView)
        view.addSubview(bottomView)
        
        
        scrollView.addSubview(contentView)
        bottomView.addSubview(btnSave)
        contentView.addSubview(cityDropdownListView)
        contentView.addSubview(districtDropdownListView)
        contentView.addSubview(priceSliderView)
        contentView.addSubview(genderView)
        contentView.addSubview(utilitiesView)
        //Add Constrant
       
        if #available(iOS 11.0, *) {
             _ = scrollView.anchor(view.safeAreaLayoutGuide.topAnchor, view.leftAnchor, view.safeAreaLayoutGuide.bottomAnchor, view.rightAnchor, UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: -defaultBottomViewHeight, right: -Constants.MARGIN_10))
            _ = bottomView.anchor(scrollView.bottomAnchor, view.leftAnchor,view.safeAreaLayoutGuide.bottomAnchor, view.rightAnchor,defaultPadding,.init(width: 0, height: defaultBottomViewHeight))
        } else {
            // Fallback on earlier versions
             _ = scrollView.anchor(bottomLayoutGuide.topAnchor, view.leftAnchor, bottomLayoutGuide.bottomAnchor, view.rightAnchor, UIEdgeInsets(top: 0, left: Constants.MARGIN_10, bottom: -defaultBottomViewHeight, right: -Constants.MARGIN_10))
            _ = bottomView.anchor(scrollView.bottomAnchor, view.leftAnchor,bottomLayoutGuide.topAnchor, view.rightAnchor,defaultPadding,.init(width: 0, height: defaultBottomViewHeight))
        }
        
        _ = contentView.anchor(scrollView.topAnchor,scrollView.leftAnchor,scrollView.bottomAnchor,scrollView.rightAnchor)
        _ = contentView.anchorWidth(equalTo: scrollView.widthAnchor)
        _  = contentView.anchorHeight(equalToConstrant: contentViewHeight)

        _ = cityDropdownListView.anchor(contentView.topAnchor,contentView.leftAnchor,nil,contentView.rightAnchor,.zero,.init(width: 0, height: Constants.HEIGHT_VIEW_DROPDOWN_LIST))
        _ = districtDropdownListView.anchor(cityDropdownListView.bottomAnchor,contentView.leftAnchor,nil,contentView.rightAnchor,.zero,.init(width: 0, height: Constants.HEIGHT_VIEW_DROPDOWN_LIST))
        _ = priceSliderView.anchor(districtDropdownListView.bottomAnchor,contentView.leftAnchor,nil,contentView.rightAnchor,.zero,.init(width: 0, height: Constants.HEIGHT_VIEW_SLIDER))
        _ = genderView.anchor(priceSliderView.bottomAnchor,contentView.leftAnchor,nil,contentView.rightAnchor,.zero,.init(width: 0, height: Constants.HEIGHT_VIEW_GENDER))
        _ = utilitiesView.anchor(genderView.bottomAnchor,contentView.leftAnchor,nil,contentView.rightAnchor,.zero,.init(width: 0, height: utilitiesViewHeight))

        _ = btnSave.anchor(view: bottomView,UIEdgeInsets(top: Constants.MARGIN_6, left: 0, bottom: -Constants.MARGIN_6, right: 0))
        btnSave.layer.cornerRadius = CGFloat(10)
        btnSave.clipsToBounds = true
        btnSave.addTarget(self, action: #selector(onClickBtnSave), for: .touchUpInside)
        
        
    }
    func updateUI(){
        selectedCity = CityModel()
        selectedDistricts = []
        selectedUtilities = []
        selectedPrice = []
        selectedPrice?.append(400_000)
        selectedPrice?.append(40_000_000)
        selectedGender = .none
        cityDropdownListView.dropdownListViewType = .city
        districtDropdownListView.dropdownListViewType = .district
        if let setting = DBManager.shared.getSingletonModel(ofType: SettingModel.self), let city = DBManager.shared.getRecord(id: setting.cityId, ofType: CityModel.self){
            selectedCity = city
            cityDropdownListView.text = selectedCity?.name
        }
        
        if let searchRequestModel = filterArgumentModel.filterRequestModel{
            if let cityId = filterArgumentModel.cityId{
                selectedCity = DBManager.shared.getRecord(id: cityId, ofType: CityModel.self)
                if let districts = searchRequestModel.districts,districts.count != 0{
                    selectedDistricts = districts.map({ (districtId) -> DistrictModel   in
                        DBManager.shared.getRecord(id: districtId, ofType: DistrictModel.self)!
                    })
                    districtDropdownListView.text = selectedDistricts?.compactMap{$0.name}.joined(separator: ",")
                }
                cityDropdownListView.text = selectedCity?.name
            }
            
            if let utilities = searchRequestModel.utilities{
                selectedUtilities = utilities
            }
            if let price = searchRequestModel.price{
                selectedPrice = price
            }
            if let gender = searchRequestModel.gender{
                selectedGender = GenderSelect(rawValue: gender)
            }
            
        }
        priceSliderView.setSelectedRange(leftSelectedValue: selectedPrice![0], rightSelectedValue: selectedPrice![1])
        utilitiesView.selectedUtilities = selectedUtilities!
        genderView.genderSelect = selectedGender
    }
    func setData(){
        title = "FILTER".localized
        btnSave.setTitle("APPLY".localized, for: .normal)
        utilitiesView.utilities = utilities
        
        utilitiesView.delegate = self
        districtDropdownListView.delegate = self
        cityDropdownListView.delegate = self
        genderView.delegate = self
        priceSliderView.delegate = self
//        filterArgumentModel.searchRequestModel?.districts.first.
        
    }
    
    //MARK: Handler utilitiesViewDelegate
    func utilitiesViewDelegate(utilitiesView view: UtilitiesView, didSelectUtilityAt indexPath: IndexPath) {
        guard let utility = utilities?[indexPath.row] else {
            return
        }
        if (selectedUtilities?.contains(utility.utilityId))!{
            utilitiesView.setState(isSelected: false, atIndexPath: indexPath)
            let index = selectedUtilities?.index(of: utility.utilityId)
            selectedUtilities?.remove(at: index!)
        }else{
            utilitiesView.setState(isSelected: true, atIndexPath: indexPath)
            selectedUtilities?.append(utility.utilityId)
        }
        
    }
    //MARK: Handler dropdownListViewDelegate
    func dropdownListViewDelegate(view dropdownListView: DropdownListView, onClickBtnChangeSelect btnSelect: UIButton) {
        if dropdownListView == cityDropdownListView{
            let data = cities?.map{$0.name!}
            var selectDataIndexs:[Int] = []
            if let city = selectedCity,let name = city.name, let index = data?.index(of: name){
                selectDataIndexs = [index]
            }
            let alert = AlertController.showAlertList(withTitle: "LIST_CITY_TITLE".localized, andMessage: nil, alertStyle: .alert,alertType: .city,forViewController: self, data: data,selectedItemIndex: selectDataIndexs, rhsButtonTitle: "DONE".localized)
            alert.delegate = self
            
        }else{
            if self.selectedCity?.cityId != 0{
                let data = districts?.filter({ (district) -> Bool in
                    district.cityId == self.selectedCity?.cityId
                }).map({ (district) -> String in
                    district.name!
                })
                let selectDataIndexs = selectedDistricts?.compactMap{data?.index(of: $0.name!)}
                let alert = AlertController.showAlertList(withTitle: "LIST_DISTRICT_TITLE".localized, andMessage: nil, alertStyle: .alert,alertType: .district, isMultiSelected:true, forViewController: self, data: data,selectedItemIndex: selectDataIndexs, rhsButtonTitle: "DONE".localized)
                alert.delegate = self
            }
            
        }
    }
    
    //MARK: Handler genderViewDelegate
    func genderViewDelegate(genderView view: GenderView, onChangeGenderSelect genderSelect: GenderSelect?) {
        filterArgumentModel.filterRequestModel?.gender = genderView.genderSelect?.rawValue
    }
    //MARK: Handler sliderView
    func sliderView(view sliderView: SliderView, didChangeSelectedMinValue selectedMin: Float, andMaxValue selectedMax: Float) {
        selectedPrice?.removeAll()
        selectedPrice?.append(selectedMin)
        selectedPrice?.append(selectedMax)
    }
    //MARK: UIAlertControllerDelegate
    override func alertControllerDelegate(alertController: AlertController,withAlertType type:AlertType, onCompleted indexs: [IndexPath]?) {
        guard let indexs = indexs else {
            selectedDistricts =  []
            self.districtDropdownListView.dropdownListViewType = .district
            return
        }
        if type == AlertType.city{
            guard let city = cities?[(indexs.first?.row)!]  else{
                return
            }
            selectedCity = city
            selectedDistricts =  []
            self.cityDropdownListView.text = self.selectedCity?.name
            self.districtDropdownListView.dropdownListViewType = .district
        }else if type == AlertType.district{
            guard let districtOfCity = districts?.filter({ (district) -> Bool in
                district.cityId == self.selectedCity?.cityId
            }) else{
                return
            }
            selectedDistricts?.removeAll()
            indexs.forEach { (index) in
                selectedDistricts?.append(districtOfCity[index.row])
            }
            let dictrictsString = selectedDistricts?.map({ (district) -> String     in
                district.name!
            })
            self.districtDropdownListView.text  = dictrictsString?.joined(separator: ",")
        }
    }
    //MARK: Handler for save button
    @objc  func onClickBtnSave(){
        //handler for save filter
        filterArgumentModel.page = 1
        filterArgumentModel.filterRequestModel = FilterRequestModel()
        filterArgumentModel.filterRequestModel?.price = selectedPrice!
        filterArgumentModel.filterRequestModel?.gender = genderView.genderSelect?.rawValue
        filterArgumentModel.cityId = selectedCity?.cityId
        filterArgumentModel.filterRequestModel?.districts = selectedDistricts?.compactMap{$0.districtId}
        var utilities:[Int] = []
        selectedUtilities?.forEach({ (utilityId) in
            utilities.append(utilityId)
        })
        filterArgumentModel.filterRequestModel?.utilities = utilities
        
        self.delegate?.filterVCDelegate(filterVC: self, onCompletedWithFilter: filterArgumentModel)
        dimissEntireNavigationController()
    }
    //MARK: Handler for reset button
    @objc  func onClickBtnReset(){
        filterArgumentModel.filterRequestModel = nil
        updateUI()
        utilitiesView.resetView()
    }
}
