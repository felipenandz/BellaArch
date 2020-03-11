import UIKit
import Foundation

public protocol BellaArchDelegate: class {

    func didFinishEntrance ()
    func didRemoveLine ()
    func didFinishPath ()
    func finishingPath ()
    func updateNewLocation (arch: BellaArch)
}


public enum BellaArchActions {

    public enum Direction {
          case up
          case down
      }

    case showLine       (direction: Direction, time: CGFloat)
    case removeLine     (direction: Direction, time: CGFloat)
    case updateLocation (newLocation: CGRect)
    case startAnimation (direction: Direction, duration: CGFloat, target: CGRect, raiseWithTime: CGFloat)

}


open class BellaArch: CAShapeLayer {

    // MARK: FACTORY AND MOTOR ANIMATIONS
    /*
     - Factory is where i create arch and paths
     - MotorAnimations is where all the animations happens
     */

    var factory = FactoryOfArch()
    var motorAnimation = ArchMotorAnimation()

    // MARK: FLAG TO SET WHILE THE ARCH IS RUNNING
    var isRunningAnimation: Bool = false

    // MARK: DELEGATE RESPONSIBLE FOR INFORMING THE PROGRESS DURING THE ANIMATIONS

   public weak var bellaArchDelegate: BellaArchDelegate? = nil

    // MARK: OVERRIDE MADE FOR PRESENTATION LAYER FOLLOW THE GUIDELINES OF MODEL LAYER

   public override init(layer: Any) {
        super.init(layer: layer)
        guard let layer = layer as? BellaArch else {return}
        self.anchorPoint = layer.anchorPoint
        self.frame = layer.frame
        self.position = layer.position
        self.fillColor = layer.fillColor
        self.zPosition = 1001
    }

    // MARK: INIT THIS CLASS WITH A RECT WHICH DESCRIBES THE START POINT OF YOUR ANIMATION

    public init(rect: CGRect) {
    super.init()
    let inPoint = rect.origin
    let height = rect.height
    self.anchorPoint = CGPoint(x: 0, y: 0)
    self.frame = CGRect(x: 0,
                         y: 0,
                         width: 1,
                         height: height)

    self.position = CGPoint(x: inPoint.x, y: inPoint.y)
    self.fillColor = nil
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func execute (action: BellaArchActions) {

        switch action {

        case .removeLine:
            if isRunningAnimation { return }
               isRunningAnimation = true

            // REMOVE LINE FROM SUPERLAYER
            motorAnimation.remove(line: self, action: action, afterPath: false)

        case .showLine:

            // SHOW LINE IN SUPERLAYER
            factory.createLine     (layer: self, action: action)
            motorAnimation.showLine(line: self, action: action)

        case .startAnimation( let direction, let duration, let target, _):

            // START ANIMATION TO PATH

            if isRunningAnimation {return}
            if target.contains(self.frame) {return}
            isRunningAnimation = true

            self.path = factory.createPath (layer: self, for: action)
            motorAnimation.remove(line: self, action: .removeLine(direction: direction, time: duration),
                                  afterPath: true)

            motorAnimation.movePath(line: self, action: action)


        case .updateLocation(let newLocation):
            if isRunningAnimation {return}
            self.frame = newLocation
        }
    }

    private func drawRoute (for action: BellaArchActions) -> ArchMotorAnimation {
        self.path = factory.createPath(layer: self, for: action)
        return motorAnimation
    }

}


extension CGFloat {
    func neg () -> CGFloat {
        if self <= 0 {
            return self
        }
        return -self
    }
}
