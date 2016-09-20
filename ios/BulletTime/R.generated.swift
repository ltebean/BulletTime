// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift

import Foundation
import Rswift
import UIKit

/// This `R` struct is code generated, and contains references to static resources.
struct R: Rswift.Validatable {
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 color palettes.
  struct color {
    private init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 2 files.
  struct file {
    /// Resource file `lineto-circular-black.ttf`.
    static let linetoCircularBlackTtf = FileResource(bundle: _R.hostingBundle, name: "lineto-circular-black", pathExtension: "ttf")
    /// Resource file `lineto-circular-bold.ttf`.
    static let linetoCircularBoldTtf = FileResource(bundle: _R.hostingBundle, name: "lineto-circular-bold", pathExtension: "ttf")
    
    /// `bundle.URLForResource("lineto-circular-black", withExtension: "ttf")`
    static func linetoCircularBlackTtf(_: Void) -> NSURL? {
      let fileResource = R.file.linetoCircularBlackTtf
      return fileResource.bundle.URLForResource(fileResource)
    }
    
    /// `bundle.URLForResource("lineto-circular-bold", withExtension: "ttf")`
    static func linetoCircularBoldTtf(_: Void) -> NSURL? {
      let fileResource = R.file.linetoCircularBoldTtf
      return fileResource.bundle.URLForResource(fileResource)
    }
    
    private init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 2 fonts.
  struct font {
    /// Font `Circular-Black`.
    static let circularBlack = FontResource(fontName: "Circular-Black")
    /// Font `Circular-Bold`.
    static let circularBold = FontResource(fontName: "Circular-Bold")
    
    /// `UIFont(name: "Circular-Black", size: ...)`
    static func circularBlack(size size: CGFloat) -> UIFont? {
      return UIFont(resource: circularBlack, size: size)
    }
    
    /// `UIFont(name: "Circular-Bold", size: ...)`
    static func circularBold(size size: CGFloat) -> UIFont? {
      return UIFont(resource: circularBold, size: size)
    }
    
    private init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 15 images.
  struct image {
    /// Image `button-save-as-video`.
    static let buttonSaveAsVideo = ImageResource(bundle: _R.hostingBundle, name: "button-save-as-video")
    /// Image `icon-back-grey`.
    static let iconBackGrey = ImageResource(bundle: _R.hostingBundle, name: "icon-back-grey")
    /// Image `icon-back-white`.
    static let iconBackWhite = ImageResource(bundle: _R.hostingBundle, name: "icon-back-white")
    /// Image `icon-confirm`.
    static let iconConfirm = ImageResource(bundle: _R.hostingBundle, name: "icon-confirm")
    /// Image `icon-delete`.
    static let iconDelete = ImageResource(bundle: _R.hostingBundle, name: "icon-delete")
    /// Image `icon-feedback`.
    static let iconFeedback = ImageResource(bundle: _R.hostingBundle, name: "icon-feedback")
    /// Image `icon-gesture-1`.
    static let iconGesture1 = ImageResource(bundle: _R.hostingBundle, name: "icon-gesture-1")
    /// Image `icon-gesture-2`.
    static let iconGesture2 = ImageResource(bundle: _R.hostingBundle, name: "icon-gesture-2")
    /// Image `icon-gesture-3`.
    static let iconGesture3 = ImageResource(bundle: _R.hostingBundle, name: "icon-gesture-3")
    /// Image `icon-share`.
    static let iconShare = ImageResource(bundle: _R.hostingBundle, name: "icon-share")
    /// Image `icon-share-bold`.
    static let iconShareBold = ImageResource(bundle: _R.hostingBundle, name: "icon-share-bold")
    /// Image `icon-share-white`.
    static let iconShareWhite = ImageResource(bundle: _R.hostingBundle, name: "icon-share-white")
    /// Image `icon-star`.
    static let iconStar = ImageResource(bundle: _R.hostingBundle, name: "icon-star")
    /// Image `test1`.
    static let test1 = ImageResource(bundle: _R.hostingBundle, name: "test1")
    /// Image `test2`.
    static let test2 = ImageResource(bundle: _R.hostingBundle, name: "test2")
    
    /// `UIImage(named: "button-save-as-video", bundle: ..., traitCollection: ...)`
    static func buttonSaveAsVideo(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.buttonSaveAsVideo, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "icon-back-grey", bundle: ..., traitCollection: ...)`
    static func iconBackGrey(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.iconBackGrey, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "icon-back-white", bundle: ..., traitCollection: ...)`
    static func iconBackWhite(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.iconBackWhite, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "icon-confirm", bundle: ..., traitCollection: ...)`
    static func iconConfirm(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.iconConfirm, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "icon-delete", bundle: ..., traitCollection: ...)`
    static func iconDelete(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.iconDelete, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "icon-feedback", bundle: ..., traitCollection: ...)`
    static func iconFeedback(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.iconFeedback, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "icon-gesture-1", bundle: ..., traitCollection: ...)`
    static func iconGesture1(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.iconGesture1, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "icon-gesture-2", bundle: ..., traitCollection: ...)`
    static func iconGesture2(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.iconGesture2, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "icon-gesture-3", bundle: ..., traitCollection: ...)`
    static func iconGesture3(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.iconGesture3, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "icon-share", bundle: ..., traitCollection: ...)`
    static func iconShare(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.iconShare, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "icon-share-bold", bundle: ..., traitCollection: ...)`
    static func iconShareBold(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.iconShareBold, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "icon-share-white", bundle: ..., traitCollection: ...)`
    static func iconShareWhite(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.iconShareWhite, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "icon-star", bundle: ..., traitCollection: ...)`
    static func iconStar(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.iconStar, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "test1", bundle: ..., traitCollection: ...)`
    static func test1(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.test1, compatibleWithTraitCollection: traitCollection)
    }
    
    /// `UIImage(named: "test2", bundle: ..., traitCollection: ...)`
    static func test2(compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIImage? {
      return UIImage(resource: R.image.test2, compatibleWithTraitCollection: traitCollection)
    }
    
    private init() {}
  }
  
  private struct intern: Rswift.Validatable {
    static func validate() throws {
      try _R.validate()
    }
    
    private init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 1 nibs.
  struct nib {
    /// Nib `FocusView`.
    static let focusView = _R.nib._FocusView()
    
    /// `UINib(name: "FocusView", bundle: ...)`
    static func focusView(_: Void) -> UINib {
      return UINib(resource: R.nib.focusView)
    }
    
    private init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 1 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `cell`.
    static let cell: ReuseIdentifier<ProductCell> = ReuseIdentifier(identifier: "cell")
    
    private init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 3 view controllers.
  struct segue {
    /// This struct is generated for `CentralViewController`, and contains static references to 1 segues.
    struct centralViewController {
      /// Segue identifier `camera`.
      static let camera: StoryboardSegueIdentifier<UIStoryboardSegue, CentralViewController, CameraViewController> = StoryboardSegueIdentifier(identifier: "camera")
      
      /// Optionally returns a typed version of segue `camera`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func camera(segue segue: UIStoryboardSegue) -> TypedStoryboardSegueInfo<UIStoryboardSegue, CentralViewController, CameraViewController>? {
        return TypedStoryboardSegueInfo(segueIdentifier: R.segue.centralViewController.camera, segue: segue)
      }
      
      private init() {}
    }
    
    /// This struct is generated for `HomeViewController`, and contains static references to 2 segues.
    struct homeViewController {
      /// Segue identifier `me`.
      static let me: StoryboardSegueIdentifier<UIStoryboardSegue, HomeViewController, UINavigationController> = StoryboardSegueIdentifier(identifier: "me")
      /// Segue identifier `shoot`.
      static let shoot: StoryboardSegueIdentifier<UIStoryboardSegue, HomeViewController, MeViewController> = StoryboardSegueIdentifier(identifier: "shoot")
      
      /// Optionally returns a typed version of segue `me`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func me(segue segue: UIStoryboardSegue) -> TypedStoryboardSegueInfo<UIStoryboardSegue, HomeViewController, UINavigationController>? {
        return TypedStoryboardSegueInfo(segueIdentifier: R.segue.homeViewController.me, segue: segue)
      }
      
      /// Optionally returns a typed version of segue `shoot`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func shoot(segue segue: UIStoryboardSegue) -> TypedStoryboardSegueInfo<UIStoryboardSegue, HomeViewController, MeViewController>? {
        return TypedStoryboardSegueInfo(segueIdentifier: R.segue.homeViewController.shoot, segue: segue)
      }
      
      private init() {}
    }
    
    /// This struct is generated for `PeripheralViewController`, and contains static references to 1 segues.
    struct peripheralViewController {
      /// Segue identifier `camera`.
      static let camera: StoryboardSegueIdentifier<UIStoryboardSegue, PeripheralViewController, CameraViewController> = StoryboardSegueIdentifier(identifier: "camera")
      
      /// Optionally returns a typed version of segue `camera`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func camera(segue segue: UIStoryboardSegue) -> TypedStoryboardSegueInfo<UIStoryboardSegue, PeripheralViewController, CameraViewController>? {
        return TypedStoryboardSegueInfo(segueIdentifier: R.segue.peripheralViewController.camera, segue: segue)
      }
      
      private init() {}
    }
    
    private init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 4 storyboards.
  struct storyboard {
    /// Storyboard `Home`.
    static let home = _R.storyboard.home()
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Me`.
    static let me = _R.storyboard.me()
    /// Storyboard `Shoot`.
    static let shoot = _R.storyboard.shoot()
    
    /// `UIStoryboard(name: "Home", bundle: ...)`
    static func home(_: Void) -> UIStoryboard {
      return UIStoryboard(resource: R.storyboard.home)
    }
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void) -> UIStoryboard {
      return UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Me", bundle: ...)`
    static func me(_: Void) -> UIStoryboard {
      return UIStoryboard(resource: R.storyboard.me)
    }
    
    /// `UIStoryboard(name: "Shoot", bundle: ...)`
    static func shoot(_: Void) -> UIStoryboard {
      return UIStoryboard(resource: R.storyboard.shoot)
    }
    
    private init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 0 localization tables.
  struct string {
    private init() {}
  }
  
  private init() {}
}

struct _R: Rswift.Validatable {
  static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(NSLocale.init) ?? NSLocale.currentLocale()
  static let hostingBundle = NSBundle(identifier: "io.ltebean.bullettime") ?? NSBundle.mainBundle()
  
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct nib {
    struct _FocusView: NibResourceType {
      let bundle = _R.hostingBundle
      let name = "FocusView"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> UIView? {
        return instantiateWithOwner(ownerOrNil, options: optionsOrNil)[0] as? UIView
      }
      
      private init() {}
    }
    
    private init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try shoot.validate()
      try me.validate()
    }
    
    struct home: StoryboardResourceWithInitialControllerType {
      typealias InitialController = HomeViewController
      
      let bundle = _R.hostingBundle
      let name = "Home"
      
      private init() {}
    }
    
    struct launchScreen: StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIViewController
      
      let bundle = _R.hostingBundle
      let name = "LaunchScreen"
      
      private init() {}
    }
    
    struct me: StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = MeViewController
      
      let bundle = _R.hostingBundle
      let name = "Me"
      let settings = StoryboardViewControllerResource<SettingsViewController>(identifier: "settings")
      
      func settings(_: Void) -> SettingsViewController? {
        return UIStoryboard(resource: self).instantiateViewController(settings)
      }
      
      static func validate() throws {
        if UIImage(named: "icon-share") == nil { throw ValidationError(description: "[R.swift] Image named 'icon-share' is used in storyboard 'Me', but couldn't be loaded.") }
        if UIImage(named: "icon-feedback") == nil { throw ValidationError(description: "[R.swift] Image named 'icon-feedback' is used in storyboard 'Me', but couldn't be loaded.") }
        if UIImage(named: "icon-delete") == nil { throw ValidationError(description: "[R.swift] Image named 'icon-delete' is used in storyboard 'Me', but couldn't be loaded.") }
        if UIImage(named: "icon-share-white") == nil { throw ValidationError(description: "[R.swift] Image named 'icon-share-white' is used in storyboard 'Me', but couldn't be loaded.") }
        if UIImage(named: "icon-star") == nil { throw ValidationError(description: "[R.swift] Image named 'icon-star' is used in storyboard 'Me', but couldn't be loaded.") }
        if _R.storyboard.me().settings() == nil { throw ValidationError(description:"[R.swift] ViewController with identifier 'settings' could not be loaded from storyboard 'Me' as 'SettingsViewController'.") }
      }
      
      private init() {}
    }
    
    struct shoot: StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UINavigationController
      
      let broadcast = StoryboardViewControllerResource<BroadcastViewController>(identifier: "broadcast")
      let bundle = _R.hostingBundle
      let central = StoryboardViewControllerResource<CentralViewController>(identifier: "central")
      let discoveries = StoryboardViewControllerResource<DiscoveriesViewController>(identifier: "discoveries")
      let display = StoryboardViewControllerResource<DisplayViewController>(identifier: "display")
      let editor = StoryboardViewControllerResource<EditorViewController>(identifier: "editor")
      let name = "Shoot"
      let peripheral = StoryboardViewControllerResource<PeripheralViewController>(identifier: "peripheral")
      let picker = StoryboardViewControllerResource<PickerViewController>(identifier: "picker")
      
      func broadcast(_: Void) -> BroadcastViewController? {
        return UIStoryboard(resource: self).instantiateViewController(broadcast)
      }
      
      func central(_: Void) -> CentralViewController? {
        return UIStoryboard(resource: self).instantiateViewController(central)
      }
      
      func discoveries(_: Void) -> DiscoveriesViewController? {
        return UIStoryboard(resource: self).instantiateViewController(discoveries)
      }
      
      func display(_: Void) -> DisplayViewController? {
        return UIStoryboard(resource: self).instantiateViewController(display)
      }
      
      func editor(_: Void) -> EditorViewController? {
        return UIStoryboard(resource: self).instantiateViewController(editor)
      }
      
      func peripheral(_: Void) -> PeripheralViewController? {
        return UIStoryboard(resource: self).instantiateViewController(peripheral)
      }
      
      func picker(_: Void) -> PickerViewController? {
        return UIStoryboard(resource: self).instantiateViewController(picker)
      }
      
      static func validate() throws {
        if UIImage(named: "button-save-as-video") == nil { throw ValidationError(description: "[R.swift] Image named 'button-save-as-video' is used in storyboard 'Shoot', but couldn't be loaded.") }
        if UIImage(named: "icon-back-white") == nil { throw ValidationError(description: "[R.swift] Image named 'icon-back-white' is used in storyboard 'Shoot', but couldn't be loaded.") }
        if UIImage(named: "icon-back-grey") == nil { throw ValidationError(description: "[R.swift] Image named 'icon-back-grey' is used in storyboard 'Shoot', but couldn't be loaded.") }
        if UIImage(named: "icon-confirm") == nil { throw ValidationError(description: "[R.swift] Image named 'icon-confirm' is used in storyboard 'Shoot', but couldn't be loaded.") }
        if _R.storyboard.shoot().central() == nil { throw ValidationError(description:"[R.swift] ViewController with identifier 'central' could not be loaded from storyboard 'Shoot' as 'CentralViewController'.") }
        if _R.storyboard.shoot().discoveries() == nil { throw ValidationError(description:"[R.swift] ViewController with identifier 'discoveries' could not be loaded from storyboard 'Shoot' as 'DiscoveriesViewController'.") }
        if _R.storyboard.shoot().editor() == nil { throw ValidationError(description:"[R.swift] ViewController with identifier 'editor' could not be loaded from storyboard 'Shoot' as 'EditorViewController'.") }
        if _R.storyboard.shoot().picker() == nil { throw ValidationError(description:"[R.swift] ViewController with identifier 'picker' could not be loaded from storyboard 'Shoot' as 'PickerViewController'.") }
        if _R.storyboard.shoot().display() == nil { throw ValidationError(description:"[R.swift] ViewController with identifier 'display' could not be loaded from storyboard 'Shoot' as 'DisplayViewController'.") }
        if _R.storyboard.shoot().broadcast() == nil { throw ValidationError(description:"[R.swift] ViewController with identifier 'broadcast' could not be loaded from storyboard 'Shoot' as 'BroadcastViewController'.") }
        if _R.storyboard.shoot().peripheral() == nil { throw ValidationError(description:"[R.swift] ViewController with identifier 'peripheral' could not be loaded from storyboard 'Shoot' as 'PeripheralViewController'.") }
      }
      
      private init() {}
    }
    
    private init() {}
  }
  
  private init() {}
}