//
//  File.swift
//
//
//  Created by Felipe Fernandes on 11/03/2020.
//

import Foundation
import UIKit

struct FactoryOfArch  {

    func createLine (layer: BellaArch, action: BellaArchActions) {

        guard case .showLine(let direction, _) = action else { return}

       let checkForGradient = layer.sublayers?.first(where: { (layer) -> Bool in
                     layer is CAGradientLayer
        })

        guard (checkForGradient == nil) else {return}

        let pointWhite = UIColor.white.withAlphaComponent(0).cgColor
        let white = UIColor.white.withAlphaComponent(0.5).cgColor
        let gradient : CAGradientLayer = {
            let gradient =  CAGradientLayer()
            gradient.anchorPoint = CGPoint(x: 0.5, y: direction == .up ? 0.0 : 1.0);
            gradient.frame = layer.bounds
            gradient.colors = [pointWhite,white, pointWhite]
            gradient.locations = [0,0.5,1.0]
            gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
            return gradient
        }()

        gradient.bounds.size.height = 0
        layer.opacity = 1
        layer.insertSublayer(gradient, at: 0)

    }


    @discardableResult func createPath (layer: CAShapeLayer, for action: BellaArchActions) -> CGPath? {

        guard case .startAnimation(let direction, _, let target, _) = action else {return nil}

        let arch = UIBezierPath()
        let bornPoint = layer.frame
        let height = layer.frame.height
        let bottom = height / 5


        // USED TO GIVE DEEPNESS TO THE ARCH

        let depthRate: CGFloat = 1.2
        let constantDepth: CGFloat = 100

        // DISTANCE BETWEEN START VIEW AND TARGET VIEW

        let distance = (target.minX - bornPoint.minX) + 1

        // CONVERT THE COORDINATE SPACE TO THE KEYWINDOW AS GLOBAL COORDINATION

        let converted = layer.convert(target, from: UIApplication.shared.keyWindow!.layer)

        // KEYSTONE IS THE POINT WHERE THE ARCH STARTS TO TURN

        var keyStone: CGFloat!

        switch direction {

            case .up:

                // FIRST OF ALL VERIFY IF THE START POINT IS HIGHER THAN TARGET POINT
                keyStone = bornPoint.minY < target.minY ?  constantDepth.neg()  : converted.minY.neg()

                arch.move    (to: CGPoint(x: .zero, y: height / 2)) // JUST TO STAY IN THE MIDDLE
                arch.addLine (to: CGPoint(x: .zero, y: keyStone))
                arch.addCurve(to: CGPoint(x: distance, y: keyStone),
                              // CONTROL POINT Y DECIDES THE DEPTH OF THE CURVE
                    controlPoint1: CGPoint(x: .zero,      y: height.neg() + keyStone * depthRate),
                    controlPoint2: CGPoint(x: distance,   y: height.neg() + keyStone * depthRate))

                arch.addLine (to: CGPoint(x: distance, y: converted.maxY))

            case .down:
                // SAME F LOGIC
                keyStone = bornPoint.minY > target.maxY ? height : converted.maxY

                arch.move     (to: CGPoint(x: .zero, y: height / 2 ))
                arch.addLine  (to: CGPoint(x: .zero, y:  keyStone))
                arch.addCurve (to: CGPoint(x: distance, y: keyStone),
                              controlPoint1: CGPoint(x: .zero,    y: height + keyStone * depthRate),
                              controlPoint2: CGPoint(x: distance, y: height + keyStone * depthRate))

                arch.addLine(to: CGPoint(x: distance, y: converted.maxY - bottom))

        }

        layer.lineWidth = layer.frame.width
        layer.strokeStart = 0
        layer.strokeEnd = 1
        layer.path = arch.cgPath
        return arch.cgPath
    }
}
