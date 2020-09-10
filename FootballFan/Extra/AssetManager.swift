import UIKit

/// Used to load assets from Lightbox bundle
class AssetManager {

  static func image(_ named: String) -> UIImage? {
    let bundle = Bundle(for: AssetManager.self)
    return UIImage(named: "\(named)", in: bundle, compatibleWith: nil)
  }
}
