//
//  File.swift
//
//
//  Created by Felipe Fernandes on 11/03/2020.
//

import Foundation
import UIKit

struct ArchMotorAnimation {

    func showLine   ( line: BellaArch, action: BellaArchActions ) {
        if line.isRunningAnimation { return }
           line.isRunningAnimation = true
        guard case .showLine( _, let time) = action else {return}

            let height = line.frame.height
            guard let gradient = line.sublayers?.first(where: { (layer) -> Bool in
                layer is CAGradientLayer
            }) else {return}

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            let heightAnimation = CABasicAnimation(keyPath: "bounds.size.height")
            heightAnimation.fromValue =  [0]
            heightAnimation.toValue = [height]
            heightAnimation.duration = CFTimeInterval(time / 4)
            heightAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            gradient.bounds.size.height = height
            CATransaction.setCompletionBlock { [weak line] in
                guard let line = line else {return}
                line.bellaArchDelegate?.didFinishEntrance()
                line.isRunningAnimation = false
            }

            gradient.add(heightAnimation, forKey: "height")
            CATransaction.commit()

    }


    func remove (line: BellaArch, action: BellaArchActions, afterPath: Bool)  {


          guard case .removeLine(let direction, let time) = action else {return}


            CATransaction.begin()
                guard let gradient = line.sublayers?.first(where: { (layer) -> Bool in
                           layer is CAGradientLayer
                       }) else {return }

                  let boundAnimation = CABasicAnimation(keyPath: "bounds.size.height")
                  boundAnimation.fromValue = [gradient.bounds.size.height]
                  boundAnimation.toValue = 0
                  boundAnimation.duration =  CFTimeInterval(time / 5)
                  boundAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                  gradient.anchorPoint = CGPoint(x: 0.5, y: direction == .down ? 1.0 : 0.0)
                  gradient.frame = line.bounds
                  gradient.bounds.size.height = .zero

                  let opacity = CABasicAnimation(keyPath: "opacity")
                  opacity.fromValue = 1
                  opacity.toValue = 0
                  opacity.duration = CFTimeInterval(time / 5)
                  CATransaction.setCompletionBlock { [weak line] in
                      guard let line = line else {return}
                      line.bellaArchDelegate?.didRemoveLine()
                      gradient.opacity = 0
                      gradient.removeFromSuperlayer()
                    if !afterPath {
                        line.isRunningAnimation = false
                    }
                  }
                  gradient.add(boundAnimation, forKey: nil)
                  gradient.add(opacity, forKey: nil)
                  CATransaction.commit()

        return

    }


    func movePath (line: BellaArch, action: BellaArchActions)  {


        guard case .startAnimation(let direction,
                                   let duration,
                                   let target,
                                   let raiseWithTime) = action else {return}


        let time = CGFloat(duration)

        line.isRunningAnimation = true

        CATransaction.begin()
        let strokeColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        line.strokeColor = strokeColor

        let startAnimation = CABasicAnimation(keyPath: "strokeStart")
        startAnimation.fromValue = 0
        startAnimation.toValue = 0.9
        startAnimation.duration = CFTimeInterval(time)

        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.fromValue = 0.025 // CHECK
        endAnimation.toValue = 1
        endAnimation.duration =  CFTimeInterval(time - (time / 2.5))

        let strokeAnimation = CAAnimationGroup()
        strokeAnimation.animations = [startAnimation, endAnimation]
        strokeAnimation.duration = CFTimeInterval(time)
        strokeAnimation.speed = 1
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)

        line.strokeEnd = 1
        line.strokeStart = 0.9


        line.add(strokeAnimation, forKey: "Stroke")
        CATransaction.commit()

        line.presentation()?.backgroundColor = UIColor.red.cgColor
        line.presentation()?.fillColor = UIColor.green.cgColor

        let delay : Double = Double(time / 1.5)


        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak line] (progress) in

                let arch = BellaArch(rect: target)
                line?.superlayer?.addSublayer(arch)
                arch.execute(action: .showLine(direction: direction, time: raiseWithTime))
                line?.bellaArchDelegate?.finishingPath()

                let opacity = CABasicAnimation(keyPath: "opacity")
                opacity.fromValue = 1
                opacity.toValue = 0
                opacity.duration = CFTimeInterval(time / 2)
                line?.opacity = 0

                CATransaction.setCompletionBlock {
                    line?.path = nil
                    line?.bellaArchDelegate?.didFinishPath()
                    line?.bellaArchDelegate?.updateNewLocation(arch: arch)
                    line?.isRunningAnimation = false
                    line?.removeFromSuperlayer()
                }

                line?.add(opacity, forKey: "opacity")
                CATransaction.commit()
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

