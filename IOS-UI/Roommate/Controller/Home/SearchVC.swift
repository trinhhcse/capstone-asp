//
//  SearchVC.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import Foundation
protocol SearchVCDelegate:class{
    func searchVCDelegate(searchVC:SearchVC, onCompletedWithDictionary dictionary:[GPPrediction:GPPlaceResult])
}
class SearchVC:BaseVC,UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate{
    
    lazy var tableView:UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    weak var delegate:SearchVCDelegate?
    var suggestAddress:[[GPPrediction:GPPlaceResult]] = []
    var sections = ["TITLE_SUGGEST".localized,"TITLE_HISTORY".localized]
    var city:CityModel?{
        get{
            if let setting = DBManager.shared.getSingletonModel(ofType: SettingModel.self){
                return DBManager.shared.getRecord(id: setting.cityId, ofType: CityModel.self)
            }else{
                return CityModel()
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        _ = tableView.anchor(view: view)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: Constants.CELL_ICONTITLETV, bundle: Bundle.main), forCellReuseIdentifier: Constants.CELL_ICONTITLETV)
        
        
        
    }
    //MARK: UISearchBarDelegate
    func updateSearchResults(for searchController: UISearchController) {
        guard  let text = searchController.searchBar.text else {
            return
        }
        //        print(text.last == Charact)
        if text.count > 3 , let _ = city{
            suggestAddress = []
            tableView.reloadData()
            search(text: text)
        }
    }
    //MARK: UITableView Delegate and DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
//        return sections.count
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return suggestAddress.count > 3 ? 3 : suggestAddress.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CELL_ICONTITLETV, for: indexPath) as! IconTitleTVCell
        let selectedRecord = suggestAddress[indexPath.row]
        cell.lblTitle.text  =  selectedRecord.keys.first?.address
        cell.lblTitle.font = .medium
        cell.imgvIcon.image = UIImage(named: "address")
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30.0))
        v.addSubview(lbl)
        lbl.text = sections[section]
        return v
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.searchVCDelegate(searchVC: self, onCompletedWithDictionary: suggestAddress[indexPath.row])
    }
    //MARK: Custom method
    func search(text:String) {
        DispatchQueue.global(qos: .userInteractive).async {
            APIConnection.requestObject(apiRouter: APIRouter.search(input:text), errorNetworkConnectedHander: {
                DispatchQueue.main.async {
                    self.showErrorView(inView: self.tableView, withTitle: "NETWORK_STATUS_CONNECTED_REQUEST_ERROR_MESSAGE".localized, onCompleted: { () -> (Void) in
                        self.search(text: text)
                    })
                }
            }, returnType: GPAutocompletePrediction.self) { (predictions, error, statusCode) -> (Void) in
                if predictions?.status == "OK",let predictions = predictions?.predictions,predictions.count>0{
                    predictions.forEach({ (prediction) in
                        
                        let isExisted =  prediction.address.containsIgnoringCase(find: self.city!.name!)
                        if isExisted {
                            print("Add :\(prediction.address)")
                            self.group.enter()
                            APIConnection.requestObject(apiRouter: APIRouter.placeDetail(id:prediction.place_id), errorNetworkConnectedHander: nil, returnType: GPPlaceResult.self) { (place, error, statusCode) -> (Void) in
                                if place?.status == "OK",let place = place{
                                    DispatchQueue.main.async {
                                        if self.suggestAddress.count < 3{
                                            self.suggestAddress.append([prediction:place])
//                                            if let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.CELL_ICONTITLETV, for: IndexPath(row: self.suggestAddress.count-1, section: 0)) as? IconTitleTVCell , self.suggestAddress.count <= 3{
//                                                cell.lblTitle.text = prediction.address
//                                            }else{
//                                                self.tableView.reloadData()
//                                            }
                                        }
                                        
//                                        self.tableView.reloadData() 
                                    }
                                    
                                }
                                self.group.leave()
                            }
                        }
                    })
                    self.group.notify(queue: .main, execute: {
                        self.tableView.beginUpdates()
                        self.tableView.deleteSections(IndexSet(integer: 0), with: .fade)
                        self.tableView.insertSections(IndexSet(integer: 0), with: .fade)
                        self.tableView.endUpdates()

                    })
                }
                
            }
        }
    }
    
}
