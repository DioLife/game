import UIKit

public func delay(seconds: TimeInterval, completion: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

public func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(0xFFFFFFFF))
        * (max - min) + min
}
