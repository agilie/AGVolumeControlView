//
//  AGVolumeControl.swift
//  AGVolumeControl
//
//  Created by Michael Liptuga on 08.06.17.
//  Copyright © 2017 Agilie. All rights reserved.
//

import UIKit

@IBDesignable
open class AGVolumeControl: UIControl {

    @IBInspectable
    open var thumbRadius: CGFloat = 3.0
    
    @IBInspectable
    open var customBackgroundColor : UIColor? = nil
    
    @IBInspectable
    open var volumeControlSliderColor : UIColor? = nil
    
    @IBInspectable
    open var decibelsLevel : CGFloat = 1.0
    
    @IBInspectable
    open var hueStart : CGFloat = 0.75
    
    @IBInspectable
    open var hueEnd : CGFloat = 1
    
    @IBInspectable
    open var minimumValue: CGFloat = 0.0

    @IBInspectable
    open var maximumValue: CGFloat = 1.0
    
    @IBInspectable
    open var thumbColor: UIColor = .blue
    
    @IBInspectable
    open var gradientMaskColor: UIColor = .black

    @IBInspectable
    public var saturationStart : CGFloat = 1.0
    
    @IBInspectable
    public var saturationEnd   : CGFloat = 0.2

    /**
     * The radius of circle
     */
    internal var radius: CGFloat {
        get {
            let radius =  min(self.center.x / 4, self.center.y / 4)
            return radius
        }
    }
    
    internal var volumeControlRadius: CGFloat {
        get {
            let radius =  min(self.center.x / 3.5, self.center.y / 3.5)
            return radius
        }
    }
    
    internal var maxVolumeHeight: CGFloat {
        get {
            let maxVolumeHeight = radius * 1.5
            return maxVolumeHeight
        }
    }
    
    var volumeControlGradientBackground : AGVolumeControlGradientBackground? = nil
    
    var volumeControlLinearGradientBackground : AGVolumeControlLinearGradientBackground? = nil
    
    var volumeControlSlider : AGVolumeControlSlider? = nil
    
    override open var isHighlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    internal func setup() {
        self.backgroundColor = UIColor.black
    }
    
    public func volumeSliderProgressValue() -> CGFloat
    {
        return self.volumeControlSlider?.progressValue ?? 0.0
    }
    
    public func updateDecibelsLevel (decibelsLevel : CGFloat)
    {
        if (self.volumeControlGradientBackground != nil)
        {
            
            let minSize =  (self.radius + self.maxVolumeHeight) * 2.5
            
            let maxSize = min(self.frame.size.width, self.frame.size.height)
            let newMaxSize = sqrt(pow(maxSize, 2) + pow(maxSize, 2))
            
            let range = newMaxSize - minSize
            let scale = (minSize + range * decibelsLevel * self.volumeSliderProgressValue()) / maxSize
            
            self.volumeControlGradientBackground!.transform = CGAffineTransform.identity
            self.volumeControlGradientBackground!.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    open override func draw(_ rect: CGRect)
    {
        self.addVolumeControlGradientBackground()
        self.addVolumeControlLinearGradientBackground()
        self.addVolumeControlSlider()
    }
    
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool
    {
        sendActions(for: .editingDidBegin)
        self.volumeControlSlider?.beginTracking(touch)
        return true
    }
    
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool
    {
        let angle = self.volumeControlSlider?.continueTracking(touch)
        self.rotateVolumeControlLinearGradientBackground(angle: angle!)
        sendActions(for: .valueChanged)
        return true
    }
    
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?)
    {
        sendActions(for: .editingDidEnd)
    }
}

extension AGVolumeControl
{
    fileprivate func addVolumeControlGradientBackground ()
    {
        if (self.volumeControlGradientBackground == nil)
        {
            self.volumeControlGradientBackground = AGVolumeControlGradientBackground.init(frame: self.bounds)
            self.volumeControlGradientBackground?.radius = self.radius
            self.volumeControlGradientBackground?.hueStart = self.hueStart
            self.volumeControlGradientBackground?.hueEnd = self.hueEnd
            self.volumeControlGradientBackground?.maxVolumeHeight = self.maxVolumeHeight
            self.volumeControlGradientBackground?.isUserInteractionEnabled = false
            self.addSubview(self.volumeControlGradientBackground!)
        }
    }
    
    fileprivate func addVolumeControlLinearGradientBackground ()
    {
        if (self.volumeControlLinearGradientBackground == nil)
        {
            let minSize = min(self.frame.size.width, self.frame.size.width)
            let newSize = sqrt(pow(minSize, 2) + pow(minSize, 2))
            let frame = CGRect(x: (self.frame.width - newSize) / 2, y: (self.frame.height - newSize) / 2, width: newSize, height: newSize)
            self.volumeControlLinearGradientBackground = AGVolumeControlLinearGradientBackground.init(frame: frame)
            self.volumeControlLinearGradientBackground?.backgroundColor = UIColor.clear
            self.volumeControlLinearGradientBackground?.gradientMaskColor = self.gradientMaskColor
            self.volumeControlLinearGradientBackground?.isUserInteractionEnabled = false
            self.addSubview(self.volumeControlLinearGradientBackground!)
        }
    }
    
    fileprivate func addVolumeControlSlider ()
    {
        if (self.volumeControlSlider == nil)
        {
            self.volumeControlSlider = AGVolumeControlSlider.init(frame: self.bounds)
            self.volumeControlSlider?.hueStart = self.hueStart
            self.volumeControlSlider?.hueEnd = self.hueEnd
            self.volumeControlSlider?.volumeControlRadius = self.volumeControlRadius
            self.volumeControlSlider?.radius = self.radius
            self.volumeControlSlider?.maxVolumeHeight = self.maxVolumeHeight
            self.volumeControlSlider?.minimumValue = self.minimumValue
            self.volumeControlSlider?.maximumValue = self.maximumValue
            self.volumeControlSlider?.thumbColor = self.thumbColor
            self.volumeControlSlider?.thumbRadius = self.thumbRadius
            self.volumeControlSlider?.isUserInteractionEnabled = false
            
            self.addSubview(self.volumeControlSlider!)
        }
    }
    
    fileprivate func rotateVolumeControlLinearGradientBackground (angle : CGFloat)
    {
        guard let volumeControlLinearGradient = self.volumeControlLinearGradientBackground else {
            return
        }
        volumeControlLinearGradient.transform = CGAffineTransform.identity
        volumeControlLinearGradient.transform = CGAffineTransform(rotationAngle: angle)
    }
}
