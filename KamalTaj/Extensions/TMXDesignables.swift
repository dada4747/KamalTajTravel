//
//  TMXDesignables.swift
//  Internacia
//
//  Created by Admin on 16/10/22.
//

import UIKit

// UIView Corner Radiuls Designable
@IBDesignable
class CRView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var maskBounds: Bool = false {
        didSet {
            layer.masksToBounds = maskBounds
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}


// UIButton Corner Radius Designable
@IBDesignable
class CRButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var maskBounds: Bool = false {
        didSet {
            layer.masksToBounds = maskBounds
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}

// UIButton Corner Radius Designable
@IBDesignable
class CRLabel: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var maskBounds: Bool = false {
        didSet {
            layer.masksToBounds = maskBounds
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}

// UIImageView Corner Radios Designable
@IBDesignable
class CRImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var maskBounds: Bool = false {
        didSet {
            layer.masksToBounds = maskBounds
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var circleRadius: Bool = false
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // dynamic radius...
        if circleRadius == true {
            layer.cornerRadius = frame.size.height / 2
        }
    }
}

@IBDesignable
class MultiShadowCardView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 24

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.borderColor = UIColor(hexString: "#CCCCD6").cgColor
        layer.borderWidth = 1
        backgroundColor = .white  // Ensuring the view has a white background
        
            applyMultipleShadows()
        self.backgroundColor = .white
    }

    private func applyMultipleShadows() {
        let shadows = [
            (CGSize(width: 1, height: 1), 4, UIColor(hexString: "#858585").withAlphaComponent(0.10)),
            (CGSize(width: 6, height: 4), 7, UIColor(hexString: "#858585").withAlphaComponent(0.09)),
            (CGSize(width: 12, height: 9), 9, UIColor(hexString: "#858585").withAlphaComponent(0.05)),
            (CGSize(width: 22, height: 16), 11, UIColor(hexString: "#858585").withAlphaComponent(0.01)),
            (CGSize(width: 35, height: 24), 12, UIColor(hexString: "#858585").withAlphaComponent(0.00))
        ]

        for (offset, radius, color) in shadows {
            let shadowLayer = createShadowLayer(offset: offset, radius: CGFloat(radius), color: color)
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }

    private func createShadowLayer(offset: CGSize, radius: CGFloat, color: UIColor) -> CALayer {
        let shadowLayer = CALayer()
        shadowLayer.frame = bounds
        shadowLayer.cornerRadius = cornerRadius
        shadowLayer.backgroundColor = UIColor.white.cgColor
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowOffset = offset
        shadowLayer.shadowOpacity = 1.0
        shadowLayer.shadowRadius = radius
        shadowLayer.masksToBounds = false
        shadowLayer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        return shadowLayer
    }
}

@IBDesignable
class CardView: UIView {
    @IBInspectable var borderColor: UIColor? {
        get {
            if let cgColor = layer.borderColor {
                return UIColor(cgColor: cgColor)
            }
            return UIColor(hexString: "#EAEAEA") // Default color
        }
        set {
            layer.borderColor = newValue?.cgColor ?? UIColor(hexString: "#EAEAEA").cgColor
        }
    }

    @IBInspectable var maskBounds: Bool {
        get { return layer.masksToBounds }
        set { layer.masksToBounds = newValue }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set {
            layer.borderWidth = newValue > 0 ? newValue : 0 // Default width
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue > 0 ? newValue : 10 // Default radius
        }
    }
//    @IBInspectable var cornerRadius: CGFloat = 10
    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 0
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.11
    @IBInspectable var shadowRadius: CGFloat = 16.2 // Added for completeness
    @IBInspectable var isMultiShadow: Bool = false
//    @IBInspectable var borderWidth: CGFloat = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        
        // Shadow properties
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity // Use the @IBInspectable value
        layer.shadowRadius = shadowRadius
        layer.borderColor = borderColor?.cgColor
        layer.borderWidth = borderWidth
        // Shadow path for better performance
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath = shadowPath.cgPath
    }
}



@IBDesignable
class DesignableButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var maskBounds: Bool = false {
        didSet {
            layer.masksToBounds = maskBounds
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var circleRadius: Bool = false
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // dynamic radius...
        if circleRadius == true {
            layer.cornerRadius = frame.size.height / 2
        }
    }
}

@IBDesignable
class DesignableView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var maskBounds: Bool = false {
        didSet {
            layer.masksToBounds = maskBounds
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet {
            
            let sub_layer = layer
            sub_layer.shadowOpacity = 0.5
            sub_layer.shadowColor = shadowColor.cgColor
            sub_layer.shadowOffset = CGSize.zero
            sub_layer.shadowRadius = 5.5
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffSet: CGSize = CGSize(width: 0,height: 0) {
        didSet {
            layer.shadowOffset = shadowOffSet
        }
    }
    
    @IBInspectable var circleRadius: Bool = false
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // dynamic radius...
        if circleRadius == true {
            layer.cornerRadius = frame.size.height / 2
        }
    }
}

@IBDesignable
class DesignableLable: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var maskBounds: Bool = false {
        didSet {
            layer.masksToBounds = maskBounds
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var circleRadius: Bool = false
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // dynamic radius...
        if circleRadius == true {
            layer.cornerRadius = frame.size.height / 2
        }
    }
}

@IBDesignable
class DesignableImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var maskBounds: Bool = false {
        didSet {
            layer.masksToBounds = maskBounds
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var circleRadius: Bool = false
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        // dynamic radius...
        if circleRadius == true {
            layer.cornerRadius = frame.size.height / 2
        }
    }
}
@IBDesignable
class RoundedImageView: UIImageView {
    @IBInspectable public var topLeft: Bool = false      { didSet { updateCorners() } }
    @IBInspectable public var topRight: Bool = false     { didSet { updateCorners() } }
    @IBInspectable public var bottomLeft: Bool = false   { didSet { updateCorners() } }
    @IBInspectable public var bottomRight: Bool = false  { didSet { updateCorners() } }
    @IBInspectable public var cornerRadius: CGFloat = 0  { didSet { updateCorners() } }
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updateCorners()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateCorners()
    }
}

private extension RoundedImageView {
    func updateCorners() {
        var corners = CACornerMask()
        
        if topLeft     { corners.formUnion(.layerMinXMinYCorner) }
        if topRight    { corners.formUnion(.layerMaxXMinYCorner) }
        if bottomLeft  { corners.formUnion(.layerMinXMaxYCorner) }
        if bottomRight { corners.formUnion(.layerMaxXMaxYCorner) }
        
        layer.maskedCorners = corners
        layer.cornerRadius = cornerRadius
    }
}
@IBDesignable
public class RoundedView: UIView {
    
    @IBInspectable public var topLeft: Bool = false      { didSet { updateCorners() } }
    @IBInspectable public var topRight: Bool = false     { didSet { updateCorners() } }
    @IBInspectable public var bottomLeft: Bool = false   { didSet { updateCorners() } }
    @IBInspectable public var bottomRight: Bool = false  { didSet { updateCorners() } }
    @IBInspectable public var cornerRadius: CGFloat = 0  { didSet { updateCorners() } }
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updateCorners()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateCorners()
    }
}

private extension RoundedView {
    func updateCorners() {
        var corners = CACornerMask()
        
        if topLeft     { corners.formUnion(.layerMinXMinYCorner) }
        if topRight    { corners.formUnion(.layerMaxXMinYCorner) }
        if bottomLeft  { corners.formUnion(.layerMinXMaxYCorner) }
        if bottomRight { corners.formUnion(.layerMaxXMaxYCorner) }
        
        layer.maskedCorners = corners
        layer.cornerRadius = cornerRadius
    }
}
@IBDesignable
public class GradientButton: UIButton {
    public override class var layerClass: AnyClass         { CAGradientLayer.self }
    private var gradientLayer: CAGradientLayer             { layer as! CAGradientLayer }
    
    @IBInspectable public var startColor: UIColor = UIColor(hexString: "#052b7b") { didSet { updateColors() } }
    @IBInspectable public var endColor: UIColor = UIColor(hexString: "#006ecb") { didSet { updateColors() } }
    
    // expose startPoint and endPoint to IB
    
//    @IBInspectable public var startPoint: CGPoint {
//        get { gradientLayer.startPoint }
//        set { gradientLayer.startPoint = newValue }
//    }
    
//    @IBInspectable public var endPoint: CGPoint {
//        get { gradientLayer.endPoint }
//        set { gradientLayer.endPoint = newValue }
//    }
    
    // while we're at it, let's expose a few more layer properties so we can easily adjust them in IB
    
    @IBInspectable public var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable public var borderColor: UIColor? {
        get { layer.borderColor.flatMap { UIColor(cgColor: $0) } }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    // init methods
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updateColors()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateColors()
    }
}

private extension GradientButton {
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // Left center
        gradientLayer.endPoint   = CGPoint(x: 1.0, y: 1.0) // Right center
    }
}
import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable public var startColor: UIColor = UIColor(hexString: "#052b7b") {
        didSet { updateGradient() }
    }
    
    @IBInspectable public var endColor: UIColor = UIColor(hexString: "#006ecb") {
        didSet { updateGradient() }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    
    private var gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
    }
    
    private func setupGradient() {
        layer.insertSublayer(gradientLayer, at: 0)
        updateGradient()
    }
    
    private func updateGradient() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint   = CGPoint(x: 1.0, y: 0.5)
    }
}

@IBDesignable
public class GradientHeaderView: UIView {
    @IBInspectable var startColor:   UIColor = UIColor(hexString: "#E28A58") { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = UIColor(hexString: "#D03373") { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.0 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   1.0 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  true { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    @IBInspectable public var topLeft: Bool = false      { didSet { updateCorners() } }
    @IBInspectable public var topRight: Bool = false     { didSet { updateCorners() } }
    @IBInspectable public var bottomLeft: Bool = false   { didSet { updateCorners() } }
    @IBInspectable public var bottomRight: Bool = false  { didSet { updateCorners() } }
    @IBInspectable public var cornerRadius: CGFloat = 35  { didSet { updateCorners() } }
    
    
    
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 1) : .init(x: 0, y: 1)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 1, y: 1)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    func updateCorners() {
        var corners = CACornerMask()
        
        if topLeft     { corners.formUnion(.layerMinXMinYCorner) }
        if topRight    { corners.formUnion(.layerMaxXMinYCorner) }
        if bottomLeft  { corners.formUnion(.layerMinXMaxYCorner) }
        if bottomRight { corners.formUnion(.layerMaxXMaxYCorner) }
        
        layer.maskedCorners = corners
        layer.cornerRadius = cornerRadius
        
    }
    //    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    //        super.traitCollectionDidChange(previousTraitCollection)
    //        updatePoints()
    //        updateLocations()
    //        updateColors()
    //    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updatePoints()
        updateLocations()
        updateColors()
        updateCorners()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updatePoints()
        updateLocations()
        
        updateColors()
        updateCorners()
    }
    
}
@IBDesignable
class CustomFontTextField: UITextField {

    @IBInspectable var fontName: String = "NotoSans-Regular" {
        didSet {
            applyFont()
        }
    }

    @IBInspectable var fontSize: CGFloat = 16 {
        didSet {
            applyFont()
        }
    }

    private func applyFont() {
        if let customFont = UIFont(name: fontName, size: fontSize) {
            self.font = customFont
        } else {
            print("⚠️ Font '\(fontName)' not found. Make sure it's added and registered correctly.")
        }
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyFont()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        applyFont()
    }
}

@IBDesignable
class CustomFontLabel: UILabel {

    @IBInspectable var fontName: String = "NotoSans-Medium" {
        didSet {
            applyFont()
        }
    }

    @IBInspectable var fontSize: CGFloat = 16 {
        didSet {
            applyFont()
        }
    }

    private func applyFont() {
        if let customFont = UIFont(name: fontName, size: fontSize) {
            self.font = customFont
        } else {
            print("⚠️ Font '\(fontName)' not found. Make sure it is added and registered properly.")
        }
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        applyFont()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        applyFont()
    }
}
