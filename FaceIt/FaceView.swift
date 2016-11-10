//
//  FaceView.swift
//  FaceIt
//
//  Created by Cristina Rodriguez Fernandez on 7/6/16.
//  Copyright © 2016 CrisRodFe. All rights reserved.
//

//Hemos elegido el tipo de archivo Cococa Class porque estamos creando una clase que hereda de UIView, hariamos lo mismo si hereda de otras clases como View Controller

import UIKit

@IBDesignable //Lo que se dibuje en esta clase podrá ser previsualizado en el Main.storyboard
class FaceView: UIView
{
    //Propiedades de nuestra vista que podrán ser configurables y 'usables' por un controller. Para que pueda ser configurable desde el editor gráfico tenemos que poner la etiqueta a cada propiedad. Tendremos que poner el tipo en estos casos.
    
    //Cada vez que hay un cambio en la propiedad queremos que se vea, habrá que dibujar otra vez, por lo que tendremos que monitorizar los cambios
    @IBInspectable
    var scale: CGFloat = 0.90 {
        didSet {
            setNeedsDisplay() //Para pedirle al sistema que se redibuje la clase.
        }
    }
   
    @IBInspectable
    var mouthCurvature: Double = 1.0 {didSet {setNeedsDisplay()}}

    @IBInspectable
    var eyesOpen: Bool = true {
        didSet {
            leftEye.eyesOpen = eyesOpen
            rightEye.eyesOpen = eyesOpen
        }
    }
    
    @IBInspectable
    var eyeBrowTilt: Double = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var color: UIColor = UIColor.blue {
        didSet {
            setNeedsDisplay()
            leftEye.color = color
            rightEye.color = color
        }
    }
    
    @IBInspectable
    var lineWidth: CGFloat = 5.0 {
        didSet {
            setNeedsDisplay()
            leftEye.lineWidth = lineWidth
            rightEye.lineWidth = lineWidth
        }
    }
    
    //Gesture Handlers. Tiene que ser público
    func changeScale(_ recognizer: UIPinchGestureRecognizer)
    {
        switch recognizer.state
        {
            case .changed, .ended:
                scale *= recognizer.scale
                recognizer.scale = 1.0 //Reseteamos la escala para que no sea incremental.
            default:
                break
        }
    }
    
    
    //Private Implementation
    fileprivate var skullRadius: CGFloat {
            return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    fileprivate var skullCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    fileprivate struct Ratios //Para usar constantes hacemos structs con variables estaticas.
    {
        static let SkullRadiusToEyeOffSet: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffSet: CGFloat = 3
        static let SkullRadiusToBrowOffSet: CGFloat = 5
    }
    
    fileprivate enum Eye {
        case left
        case right
    }
    
    fileprivate func pathForCircleCenteredAtPoint(_ midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath
    {
        let path =  UIBezierPath(
            arcCenter: midPoint,
            radius: radius,
            startAngle: 0.0,
            endAngle: CGFloat(2*M_PI),
            clockwise: false)
        
        path.lineWidth = lineWidth
        
        return path
    }
    
    fileprivate func getEyeCenter(_ eye: Eye) -> CGPoint
    {
        let eyeOffSet = skullRadius / Ratios.SkullRadiusToEyeOffSet
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffSet
        switch eye
        {
            case .left: eyeCenter.x -= eyeOffSet
            case .right: eyeCenter.x += eyeOffSet
        }
        
        return eyeCenter
    }
    
    //Tiene que ser 'lazy' porq como estamos inicilizado si no lo ponemos, a self no le podemos mandar mensajes, entonces solo cuando alguien pida estas var se inicializarán estas variables
    
    fileprivate lazy var leftEye: EyeView = self.createEye()
    fileprivate lazy var rightEye: EyeView = self.createEye()
    
    fileprivate func createEye() -> EyeView
    {
        let eye = EyeView()
        eye.isOpaque = false
        eye.color = color
        eye.lineWidth = lineWidth
        self.addSubview(eye)
        return eye
    }
    
    fileprivate func positionEye(_ eye: EyeView, center: CGPoint)
    {
        let size = skullRadius / Ratios.SkullRadiusToEyeRadius * 2
        eye.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size))
        eye.center = center
    }
    
    //Se llamará a esta metodo cada vez que el marco cambie.
    override func layoutSubviews() {
        super.layoutSubviews()
        positionEye(leftEye, center: getEyeCenter(.left))
        positionEye(rightEye, center: getEyeCenter(.right))
    }
    
    fileprivate func pathForBrow(_ eye: Eye) -> UIBezierPath
    {
        var tilt = eyeBrowTilt
        switch eye {
        case .left: tilt *= -1.0
        case .right: break
        }
        var browCenter = getEyeCenter(eye)
        browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffSet
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.move(to: browStart)
        path.addLine(to: browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
//    private func pathForEye(eye: Eye) -> UIBezierPath
//    {
//        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
//        let eyeCenter = getEyeCenter(eye)
//        
//        if eyesOpen{
//            return pathForCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
//        }else{
//            let path = UIBezierPath()
//            path.moveToPoint(CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
//            path.addLineToPoint(CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
//            path.lineWidth = linewidth
//            return path
//        }
//    }
    
    fileprivate func pathForMouth() -> UIBezierPath
    {
        let mouthWidth  = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffSet = skullRadius / Ratios.SkullRadiusToEyeOffSet
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffSet, width: mouthWidth, height: mouthHeight)
    
        let smileOffSet = CGFloat(max(-1, min(mouthCurvature,1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        
        //Puntos de control en el camino entre el principio y el final de la linea
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffSet)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffSet)
        
        let path =  UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path
    }
    
    // iOS Drawing Method
    override func draw(_ rect: CGRect)
    {
        color.set()
        pathForCircleCenteredAtPoint(skullCenter, withRadius: skullRadius).stroke()
        
        //Con el método stroke se crean las lineas
//        pathForEye(.Left).stroke()
//        pathForEye(.Right).stroke()
        pathForMouth().stroke()
        pathForBrow(.left).stroke()
        pathForBrow(.right).stroke()
    }
}
