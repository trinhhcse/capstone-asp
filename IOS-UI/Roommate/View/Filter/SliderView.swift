//
//  SliderView.swift
//  Roommate
//
//  Created by TrinhHC on 10/3/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import UIKit
import TTRangeSlider
protocol SliderViewDelegate:class {
    func sliderView(view sliderView:SliderView,didChangeSelectedMinValue selectedMin:Float,andMaxValue selectedMax:Float)
}
class SliderView: UIView, TTRangeSliderDelegate{

    @IBOutlet weak var lblTitle: UILabel!
    var ttrsValue: TTRangeSlider = {
        let v = TTRangeSlider(frame: .zero)
        return v
    }()
    weak var delegate:SliderViewDelegate?
    var sliderViewType:SliderViewType?{
        didSet{
            if sliderViewType == SliderViewType.area{
                //distance
                lblTitle.text = "AREA_TITLE".localized
                ttrsValue.numberFormatterOverride.negativeSuffix = " m2"
                ttrsValue.numberFormatterOverride.positiveSuffix = " m2"
                self.initRangeValue(step: 1, minValue: Float(Constants.MIN_AREA), maxValue: Float(Constants.MAX_AREA), minDistance: 1,minSelectedValue: 15,maxSelectedValue: 50)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblTitle.text  = "PRICE".localized
        lblTitle.font = .smallTitle
        addSubview(ttrsValue)
        _ = ttrsValue.anchor(lblTitle.bottomAnchor, leftAnchor,nil, rightAnchor, UIEdgeInsets(top: 20, left: 25, bottom: 0, right: -25), .init(width: 0, height: 30))
        
        ttrsValue.delegate = self
        //default setting : PRICE
        ttrsValue.enableStep = true
        
        //For selected path
        ttrsValue.tintColorBetweenHandles = .defaultBlue//line selected color
        ttrsValue.handleColor = .defaultBlue//For selected circle controll color
        ttrsValue.handleDiameter = 18.0//For selected circle controll Size
        ttrsValue.maxLabelColour = .defaultBlue
        ttrsValue.minLabelColour = .defaultBlue
        
        //for not selected line path
        ttrsValue.lineBorderWidth = 2.0//Line borderwith
        ttrsValue.lineBorderColor = .lightGray//line color
        
        //Custom label format
        ttrsValue.numberFormatterOverride = NumberFormatter()
        ttrsValue.numberFormatterOverride.numberStyle = .decimal
        ttrsValue.numberFormatterOverride.decimalSeparator = "."
        ttrsValue.numberFormatterOverride.groupingSeparator = ","
        ttrsValue.numberFormatterOverride.isLenient = true
        ttrsValue.numberFormatterOverride.negativeSuffix = " VND"
        ttrsValue.numberFormatterOverride.positiveSuffix = " VND"
        
        
        //init value
        self.initRangeValue(step: 50_000, minValue: Float(Constants.MIN_PRICE), maxValue: Float(Constants.MAX_PRICE), minDistance: 200_000,minSelectedValue: 1_000_000,maxSelectedValue: 40_000_000)
    }
    
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        print(selectedMinimum)
        print(selectedMaximum)
        delegate?.sliderView(view: self, didChangeSelectedMinValue: selectedMinimum, andMaxValue: selectedMaximum)
    }
    
    
    
    private func initRangeValue(step:Float,minValue:Float,maxValue:Float,minDistance:Float,minSelectedValue:Float,maxSelectedValue:Float){
        ttrsValue.step = step
        ttrsValue.minValue = minValue
        ttrsValue.maxValue = maxValue
        ttrsValue.minDistance = minDistance
        setSelectedRange(leftSelectedValue: minSelectedValue, rightSelectedValue: maxSelectedValue)
    }
    func setSelectedRange(leftSelectedValue:Float,rightSelectedValue:Float) {
        ttrsValue.selectedMinimum = leftSelectedValue
        ttrsValue.selectedMaximum = rightSelectedValue
    }
    
}
