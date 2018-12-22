//
//  Extension.swift
//  Roommate
//
//  Created by TrinhHC on 9/20/18.
//  Copyright © 2018 TrinhHC. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SkyFloatingLabelTextField

//MARK: Extension UIView
extension UIView{
    
    class func fromNib<T:UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?.first as! T
    }

    func addBorder(side: BorderSide, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor

        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .Bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .Right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }

        self.layer.addSublayer(border)
    }
    
    //For localization
    func onUpdateLocale(){
        for subview in self.subviews {
            subview.onUpdateLocale()
        }
    }
    //Function to calculate height for label based on text
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    //For autolayout
    func anchorCenterXAndY(_ centerX:NSLayoutXAxisAnchor?,_ centerY:NSLayoutYAxisAnchor?,
                           _ widthConstant:CGFloat = 0,_ heightConstant:CGFloat = 0) -> [NSLayoutConstraint]{
        return anchor( centerX,  centerY,
                       nil,  nil,
                       nil,  nil,
                       nil, nil,
                       0,  0,
                       0,  0,
                       widthConstant,  heightConstant)
    }
    
    func anchorTopLeft(_ top:NSLayoutYAxisAnchor?,_ left:NSLayoutXAxisAnchor?,
                       _ topConstant:CGFloat = 0,_ leftConstant:CGFloat = 0,
                       _ widthConstant:CGFloat = 0,_ heightConstant:CGFloat = 0) -> [NSLayoutConstraint]{
        return anchor(nil , nil,
                      top,  left,
                      nil,  nil,
                      nil,nil,
                      topConstant,  leftConstant,
                      0,  0,
                      widthConstant,  heightConstant)
    }
    
    func anchorTopLeft(_ top:NSLayoutYAxisAnchor?,_ left:NSLayoutXAxisAnchor?,
                       _ widthConstant:CGFloat,_ heightConstant:CGFloat) -> [NSLayoutConstraint]{
        return anchor( nil ,  nil,
                       top,  left,
                       nil,  nil,
                       nil, nil,
                       0,  0,
                       0,  0,
                       widthConstant,  heightConstant)
    }
    
    func anchorTopLeft(_ top:NSLayoutYAxisAnchor?,_ left:NSLayoutXAxisAnchor?,
                       _ width:NSLayoutDimension,_ heightConstant:CGFloat) -> [NSLayoutConstraint]{
        return anchor( nil ,  nil,
                       top,  left,
                       nil,  nil,
                       width, nil,
                       0,  0,
                       0,  0,
                       0,  heightConstant)
    }
    
    func anchorTopLeft(_ top:NSLayoutYAxisAnchor?,_ left:NSLayoutXAxisAnchor?,
                       _ width:NSLayoutDimension?,_ height:NSLayoutDimension?) -> [NSLayoutConstraint]{
        return anchor( nil ,  nil,
                       top, left,
                       nil,nil,
                       width, height,
                       0, 0,
                       0, 0,
                       0, 0)
    }
    func anchorTopRight(_ top:NSLayoutYAxisAnchor?,_ right:NSLayoutXAxisAnchor?,
                        _ topConstant:CGFloat,_ rightConstant:CGFloat,
                        _ widthConstant:CGFloat,_ heightConstant:CGFloat) -> [NSLayoutConstraint]{
        return anchor( nil ,  nil,
                       top, nil,
                       nil,right,
                       nil, nil,
                       topConstant, 0,
                       0, rightConstant,
                       widthConstant, heightConstant)
    }
    
    func anchorTopRight(_ top:NSLayoutYAxisAnchor?,_ right:NSLayoutXAxisAnchor?,
                        _ widthConstant:CGFloat,_ heightConstant:CGFloat) -> [NSLayoutConstraint]{
        return anchor( nil ,  nil,
                       top, nil,
                       nil,right,
                       nil, nil,
                       0, 0,
                       0, 0,
                       widthConstant, heightConstant)
    }
    
    func anchorBottomRight(_ bottom:NSLayoutYAxisAnchor?,_ right:NSLayoutXAxisAnchor?,
                           _ bottomConstant:CGFloat = 0,_ rightConstant:CGFloat = 0,
                           _ widthConstant:CGFloat,_ heightConstant:CGFloat) -> [NSLayoutConstraint]{
        return anchor( nil ,  nil,
                       nil, nil,
                       bottom,right,
                       nil, nil,
                       0, 0,
                       bottomConstant, rightConstant,
                       widthConstant, heightConstant)
    }
    
    func anchorEntire(_ top:NSLayoutYAxisAnchor?,_ left:NSLayoutXAxisAnchor?,
                      _ bottom:NSLayoutYAxisAnchor?,_ right:NSLayoutXAxisAnchor?) -> [NSLayoutConstraint]{
        return anchor( nil ,  nil,
                       top, left,
                       bottom,right,
                       nil, nil,
                       0, 0,
                       0, 0,
                       0, 0)
    }
    func anchorEntire(_ centerX:NSLayoutXAxisAnchor?,_ centerY:NSLayoutYAxisAnchor?,
                      _ top:NSLayoutYAxisAnchor?,_ left:NSLayoutXAxisAnchor?,
                      _ bottom:NSLayoutYAxisAnchor?,_ right:NSLayoutXAxisAnchor?) -> [NSLayoutConstraint]{
        return anchor( centerX ,centerY,
                       top, left,
                       bottom,right,
                       nil, nil,
                       0, 0,
                       0, 0,
                       0, 0)
    }
    
    func anchor(_ centerX:NSLayoutXAxisAnchor?,_ centerY:NSLayoutYAxisAnchor?,
                _ top:NSLayoutYAxisAnchor?,_ left:NSLayoutXAxisAnchor?,
                _ bottom:NSLayoutYAxisAnchor?,_ right:NSLayoutXAxisAnchor?,
                _ width:NSLayoutDimension?,_ height:NSLayoutDimension?,
                _ topConstant:CGFloat = 0,_ leftConstant:CGFloat = 0,
                _ bottomConstant:CGFloat = 0,_ rightConstant:CGFloat = 0,
                _ widthConstant:CGFloat = 0,_ heightConstant:CGFloat = 0) -> [NSLayoutConstraint] {
        
        var anchor = [NSLayoutConstraint]()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerX = centerX{
            anchor.append(centerXAnchor.constraint(equalTo: centerX))
        }
        
        if let centerY = centerY{
            anchor.append(centerYAnchor.constraint(equalTo: centerY))
        }
        
        if let top = top{
            anchor.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left{
            anchor.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom{
            anchor.append(bottomAnchor.constraint(equalTo: bottom, constant: bottomConstant))
        }
        
        if let right = right{
            anchor.append(rightAnchor.constraint(equalTo: right, constant: rightConstant))
        }
        
        if let width = width{
            anchor.append(widthAnchor.constraint(equalTo: width))
        }
        
        if let height = height{
            anchor.append(heightAnchor.constraint(equalTo: height))
        }
        
        if widthConstant>0{
            anchor.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant>0{
            anchor.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchor.forEach({$0.isActive=true})
        
        return anchor
    }

    
    //MARK: New version
    
    func anchor(_ top:NSLayoutYAxisAnchor?,_ left:NSLayoutXAxisAnchor?,
                _ bottom:NSLayoutYAxisAnchor?,_ right:NSLayoutXAxisAnchor?,
                _ padding:UIEdgeInsets = .zero,
                _ size:CGSize = .zero) -> [NSLayoutConstraint] {
        var anchor = [NSLayoutConstraint]()
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            anchor.append(topAnchor.constraint(equalTo: top, constant: padding.top))
        }
        
        if let left = left{
            anchor.append(leftAnchor.constraint(equalTo: left, constant: padding.left))
        }
        
        if let bottom = bottom{
            anchor.append(bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom))
        }
        
        if let right = right{
            anchor.append(rightAnchor.constraint(equalTo: right, constant: padding.right))
        }
        
        if size.width != 0{
            anchor.append(widthAnchor.constraint(equalToConstant: size.width))
        }
        
        if size.height != 0{
            anchor.append(heightAnchor.constraint(equalToConstant: size.height))
        }
        
        anchor.forEach({$0.isActive=true})
        
        return anchor
    }

    func anchor(view:UIView,
                      _ padding:UIEdgeInsets = .zero,
                      _ size:CGSize = .zero) -> [NSLayoutConstraint]{
        return anchor(view.topAnchor,view.leftAnchor,view.bottomAnchor,view.rightAnchor,padding,size)
    }


    //END

//    func anchorEntire(view:UIView) -> [NSLayoutConstraint]{
//        return anchor(view.topAnchor,view.leftAnchor,view.bottomAnchor,view.rightAnchor)
//    }
    
    func anchorWidth(equalTo width:NSLayoutDimension?) -> NSLayoutDimension {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let width = width{
            widthAnchor.constraint(equalTo: width).isActive = true
        }
        return widthAnchor
    }
    func anchorWidth(equalTo width:NSLayoutDimension?, constant:CGFloat) -> NSLayoutDimension {
        translatesAutoresizingMaskIntoConstraints = false

        if let width = width{
            widthAnchor.constraint(equalTo: width, constant: constant).isActive = true
        }
        return widthAnchor
    }


    func anchorWidth(equalToConstrant widthConstant:CGFloat?) -> NSLayoutDimension {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let widthConstant = widthConstant{
            widthAnchor.constraint(equalToConstant: widthConstant) .isActive = true
        }
        return widthAnchor
    }
    
    func anchorHeight(equalTo height:NSLayoutDimension?) -> NSLayoutDimension {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let height = height{
            heightAnchor.constraint(equalTo: height).isActive = true
        }
        return heightAnchor
    }
    
    func anchorHeight(equalToConstrant heightConstant:CGFloat?) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalToConstant: heightConstant ?? 0.0)
        constraint.isActive = true
        return constraint
    }
}

//MARK: Extension UIViewController
//Extension for add and remove childViewController from parent controller
extension UIViewController{
    
    //Ex : parentVC.add(childVC)
    func add(_ child:UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        didMove(toParentViewController: self)
    }
    
    func add(_ child:UIView) {
        view.addSubview(view)
    }
    //Ex : childVC.remove()
    func remove() {
        guard let _ = parent else {
            return
        }
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
        
    }
}

//MARK: Extension String
extension String{
    //Ex : "KEY_IN_LOCALE_STRING_FILE".localized
    var localized:String{
        let currentLocale = LocalizationPreferences.shared.currentLocale()
        guard let bundlePath = Bundle.main.path(forResource: currentLocale, ofType: ".lproj"),
            let bundle = Bundle(path: bundlePath) else {
                return self
        }
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    
    var formated:String?{
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle  = .decimal
        numberFormat.groupingSeparator = ","
        numberFormat.decimalSeparator = "."
        numberFormat.negativeSuffix = " VND"
        numberFormat.positiveSuffix = " VND"
        numberFormat.isLenient = false // If not match fomart return except
        return numberFormat.editingString(for: self)
    }
    
    init(key:String,args:CVarArg){
        self.init(format:key.localized,args)
    }
}
//MARK: Extension Date
extension Date{
    func string(_ format:String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
}

//MARK: Extension Color
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    static let lightSubTitle:UIColor!  = UIColor(hexString: "555")
    static let normalTitle:UIColor!  = UIColor(hexString: "000")
    static let defaultBlue:UIColor!  = UIColor(hexString: "00A8B5")
    static let defaultPink:UIColor!  = UIColor(hexString: "ff008b")
    static let defaultPurple:UIColor!  = UIColor(hexString: "feb062")
    
}

extension CGFloat{
    static let verySmall:CGFloat = UIScreen.main.bounds.width > 768 ?  12 : UIScreen.main.bounds.width > 375  ? 11 : 10
    static let  small:CGFloat  = UIScreen.main.bounds.width > 768 ? 15 : UIScreen.main.bounds.width > 375  ? 13 : 10
    static let medium:CGFloat  = UIScreen.main.bounds.width > 768 ? 17 : UIScreen.main.bounds.width > 375  ? 15 : 12
    static let boldMedium:CGFloat  = UIScreen.main.bounds.width > 768 ? 20 : UIScreen.main.bounds.width > 375  ? 16 : 14
    static let large:CGFloat  = UIScreen.main.bounds.width > 768 ? 23 : UIScreen.main.bounds.width > 375  ? 21 : 16
    static let extraLarge:CGFloat  = 28
    static let smallTitle:CGFloat  = UIScreen.main.bounds.width > 768 ? 16 : UIScreen.main.bounds.width > 375  ? 14 : 12
}

extension UIFont{
    static let verySmall:UIFont = .systemFont(ofSize: .verySmall)
    static let  small:UIFont  = .systemFont(ofSize: .small)
    static let  boldSmall:UIFont  = .boldSystemFont(ofSize: .small)
    static let medium:UIFont  = .systemFont(ofSize: .medium)
    static let boldMedium:UIFont  = .boldSystemFont(ofSize: .boldMedium)
    static let large:UIFont  = .systemFont(ofSize: .large)
    static let extraLarge:UIFont  = .systemFont(ofSize: .extraLarge)
    static let smallTitle:UIFont  = .boldSystemFont(ofSize: .smallTitle)
}
extension Int{
    func cgFloat() -> CGFloat {
        return CGFloat(self)
    }
    var toDouble:Double{
        return Double(self)
    }
    var toString:String{
        return "\(self)"
    }
    var formatString:String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: self))!
    }
    
}

extension Float{
    var toString:String{
        return "\(self)"
    }
    var formatString:String{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: self))!
    }
    
}
extension Double{
    var toString:String{
        return "\(self)"
    }
    var cgFloat:CGFloat{
        return CGFloat(self)
    }
}

extension SkyFloatingLabelTextField{
    func addToobarButton(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50.0))
        let button = UIBarButtonItem(title: "DONE".localized, style: .done, target: self, action: #selector(onClickKeyboardToolbarButton))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexible,button]
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    func setupUI(placeholder:String,title:String,keyboardType:UIKeyboardType? = .default,returnKeyType:UIReturnKeyType? = .done,isSecureTextEntry:Bool? = false ,delegate:UITextFieldDelegate){
        self.isSecureTextEntry = isSecureTextEntry ?? false
        self.returnKeyType = returnKeyType ?? .done
        self.placeholder = placeholder.localized
        self.placeholderColor = UIColor.lightGray
        self.titleColor = .defaultBlue
        self.keyboardType = keyboardType ?? .default
        self.title = title.localized
        self.errorColor = .red
        self.selectedLineColor = .defaultBlue
        self.selectedTitleColor = .defaultBlue//Title color
        self.delegate = delegate
    }
    
    @objc func onClickKeyboardToolbarButton(){
        self.resignFirstResponder()
    }
}
extension UITextView{
    func addToobarButton(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50.0))
        let button = UIBarButtonItem(title: "DONE".localized, style: .done, target: self, action: #selector(onClickKeyboardToolbarButton))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexible,button]
        toolbar.sizeToFit()
        self.inputAccessoryView = toolbar
    }
    
    @objc func onClickKeyboardToolbarButton(){
        self.resignFirstResponder()
    }
}
extension String{
    func isValidUsername() -> Bool{
        let format = "^[A-Z0-9a-z_]{6,50}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", format)
        return predicate.evaluate(with: self)
    }
    func isValidPassword() -> Bool{
        let format = "^[A-Z0-9a-z]{6,50}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", format)
        return predicate.evaluate(with: self)
    }
    func isValidEmail()->Bool{
        let format = "[A-Z0-9a-z.-_]{2,}@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let predicate = NSPredicate(format:"SELF MATCHES[c] %@", format)
        return predicate.evaluate(with: self)
    }
    func isValidName() -> Bool{
        let format = "^[\\w\\s]{6,50}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", format)
        return predicate.evaluate(with: self)
    }
    func isValidDescription() -> Bool{
        let format = "^[\\w\\s]{6,50}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", format)
        return predicate.evaluate(with: self)
    }
    func isValidBrand() -> Bool{
        let format = "^[\\w\\s]{2,50}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", format)
        return predicate.evaluate(with: self)
    }
    func isValidPrice() -> Bool{
        if let value = self.toDouble() , (value >= Constants.MIN_PRICE && value <= Constants.MAX_PRICE){
            return true
        }else{
            return false
        }
    }
    func isValidQuantity() -> Bool{
        if let intValue = self.toInt() , (intValue >= Constants.MIN_QUANTITY && intValue <= Constants.MAX_QUANTITY){
            return true
        }else{
            return false
        }
    }
    
    func isValidArea() -> Bool{
        if let intValue = self.toInt() , (intValue >= Constants.MIN_AREA && intValue <= Constants.MAX_AREA){
            return true
        }else{
            return false
        }
    }
    
    func isValidPhoneNumber() -> Bool{
        let format = "^[0-9]{10,11}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", format)
        return predicate.evaluate(with: self)
    }
    func isValidAddress() -> Bool{
        let format = "^[\\w\\s,-./]{5,250}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", format)
        return predicate.evaluate(with: self)
    }
    
    func toInt()->Int?{
        return Int(self)
    }
    func toDouble() ->Double?{
        return Double(self)
    }
}
extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}
protocol Copying {
    init(original: Self)
}

extension Copying {
    func copy() -> Self {
        return Self.init(original: self)
    }
}

extension Array {
    func copiedElements() -> Array<Element> {
        return self.map{
            let copiable = $0 as! NSCopying
            return copiable.copy() as! Element
        }
    }
    func toRealmList<T>(ofType:T.Type)-> List<T>{
        var list = List<T>()
        self.forEach{list.append($0 as! T)}
        return list
    }
}
extension UIViewController {
    /// The visible view controller from a given view controller
    var visibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.visibleViewController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.visibleViewController
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.visibleViewController
        } else if self is UIAlertController {
            return nil
        } else {
            return self
        }
    }
    
}
extension UINavigationController{
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
public extension Sequence where Element: Equatable {
    var uniqueElements: [Element] {
        return self.reduce(into: []) {
            uniqueElements, element in
            
            if !uniqueElements.contains(element) {
                uniqueElements.append(element)
            }
        }
    }
}
extension UILabel{
    func addAttributeString(string:String,withIcon icon:UIImage,textColor:UIColor? = UIColor.red,textFont:UIFont? = UIFont.boldMedium,size:CGSize?,rect:CGRect? = nil){
        let attributes:[NSAttributedStringKey:Any] = [NSAttributedStringKey.foregroundColor:textColor,NSAttributedStringKey.font:textFont]
        self.text = string
        let estimateSize = self.sizeThatFits(size ?? CGSize(width: self.frame.width, height: .infinity))
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = icon
        if let rect = rect{
            imageAttachment.bounds = rect
        }else{
            imageAttachment.bounds = CGRect(x: 10, y: 0, width: estimateSize.height, height: estimateSize.height)
        }
        
        let attributedString = NSMutableAttributedString(string: "")
        attributedString.append(NSAttributedString(string: string, attributes: attributes))
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        self.attributedText = attributedString
    }
}

extension UIButton{
    open override var isEnabled: Bool{
        didSet{
            if isEnabled{
                self.alpha = 1
            }else{
                self.alpha = 0.5
            }
        }
    }
}
