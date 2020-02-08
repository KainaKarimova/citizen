//
//  SideMenuController.swift
//  SideMenu
//
//  Created by kukushi on 10/02/2018.
//  Copyright © 2018 kukushi. All rights reserved.
//

import UIKit

// MARK: Storyboard Segue

/// Custom Segue that is required for SideMenuController to be used in Storyboard.
open class SideMenuSegue: UIStoryboardSegue {
    public enum ContentType: String {
        case content = "SideMenu.Content"
        case menu = "SideMenu.Menu"
    }
    
    public var contentType = ContentType.content
    
    open override func perform() {
        guard let sideMenuController = source as? SideMenuController else {
            return
        }
        
        switch contentType {
        case .content:
            sideMenuController.contentViewController = destination
        case .menu:
            sideMenuController.menuViewController = destination
        }
    }
    
}

// MARK: SideMenuController

// Delegate Methods
public protocol SideMenuControllerDelegate: class {
    func sideMenuWillReveal(_ sideMenu: SideMenuController)
    func sideMenuDidReveal(_ sideMenu: SideMenuController)
    func sideMenuWillHide(_ sideMenu: SideMenuController)
    func sideMenuDidHide(_ sideMenu: SideMenuController)
}

// Provides default implementation for delegates
public extension SideMenuControllerDelegate {
    func sideMenuWillReveal(_ sideMenu: SideMenuController) {}
    func sideMenuDidReveal(_ sideMenu: SideMenuController) {}
    func sideMenuWillHide(_ sideMenu: SideMenuController) {}
    func sideMenuDidHide(_ sideMenu: SideMenuController) {}
}

/// A container view controller owns a menu view controller and a content view controller.
///
/// The overall architect of SideMenuController is:
/// SideMenuController
/// ├── Menu View Controller
/// └── Content View Controller
open class SideMenuController: UIViewController {
    
    /// Configure this property to change the behavior of SideMenuController;
    open static var preferences = SideMenuPreferences()
    private var preferences: SideMenuPreferences {
        return type(of: self).preferences
    }
    
    private lazy var adjustedDirection = SideMenuPreferences.MenuDirection.left
    
    private var isInitiatedFromStoryboard: Bool {
        return storyboard != nil
    }
    
    /// The identifier of content view controller segue. If the SideMenuController instance is initiated from IB, this identifier will
    /// be used to retrieve the content view controller.
    @IBInspectable public var contentSegueID: String = SideMenuSegue.ContentType.content.rawValue
    
    /// The identifier of menu view controller segue. If the SideMenuController instance is initiated from IB, this identifier will
    /// be used to retrieve the menu view controller.
    @IBInspectable public var menuSegueID: String = SideMenuSegue.ContentType.menu.rawValue

    /// Caching
    private lazy var lazyCachedViewControllerGenerators: [String: () -> UIViewController?] = [:]
    private lazy var lazyCachedViewControllers: [String: UIViewController] = [:]
    
    /// The side menu controller's delegate object.
    public weak var delegate: SideMenuControllerDelegate?
    
    /// The content view controller. Changes its value will change the display immediately.
    /// If you want a caching approach, use `setContentViewController(with)`. Its value should not be nil.
    open var contentViewController: UIViewController! {
        didSet {
            guard contentViewController !== oldValue else {
                return
            }
            
            load(contentViewController, on: contentContainerView)
            contentContainerView.sendSubview(toBack: contentViewController.view)
            unload(oldValue)
            
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    /// The menu view controller. Its value should not be nil.
    open var menuViewController: UIViewController! {
        didSet {
            guard menuViewController !== oldValue else {
                return
            }
            
            load(menuViewController, on: menuContainerView)
            unload(oldValue)
        }
    }
    
    private let menuContainerView = UIView()
    private let contentContainerView = UIView()
    private var statusBarScreenShotView: UIView?
    
    /// Return true if the menu is now revealing.
    open var isMenuRevealed = false
    
    private var shouldShowShadowOnContent: Bool {
        return preferences.animation.shouldAddShadowWhenRevealing
            && preferences.basic.position == .above
    }
    
    /// States used in panning gesture
    private var isValidatePanningBegan = false
    private var panningBaganPointX: CGFloat = 0

    /// The view responsible for tapping to hide the menu and shadow
    private weak var contentContainerOverlay: UIView?
    
    // The pan gesture recognizer responsible for revealing and hiding side menu
    private weak var panGestureRecognizer: UIPanGestureRecognizer?
    
    // MARK: Initialization

    /// Creates a SideMenuController instance with the content view controller and menu view controller.
    ///
    /// - Parameters:
    ///   - contentViewController: the content view controller
    ///   - menuViewController: the menu view controller
    public convenience init(contentViewController: UIViewController, menuViewController: UIViewController) {
        self.init(nibName: nil, bundle: nil)
        
        self.contentViewController = contentViewController
        self.menuViewController = menuViewController
    }
    
    deinit {
        unregisterNotifications()
    }
    
    // MARK: Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup from the IB
        if isInitiatedFromStoryboard {
            // Note that if you are using the `SideMenuController` from the IB, you must supply the default or custom view controller
            // ID in the storyboard.
            performSegue(withIdentifier: contentSegueID, sender: self)
            performSegue(withIdentifier: menuSegueID, sender: self)
        }
        
        if menuViewController == nil || contentViewController == nil {
            fatalError("[SideMenuSwift] `menuViewController` or `contnetViewController` should not be nil.")
        }
        
        contentContainerView.frame = view.bounds
        view.addSubview(contentContainerView)
        
        resolveDirection(with: contentContainerView)
        
        menuContainerView.frame = sideMenuFrame(visibility: false)
        view.addSubview(menuContainerView)
        
        load(contentViewController, on: contentContainerView)
        load(menuViewController, on: menuContainerView)
        
        if preferences.basic.position == .under {
            view.bringSubview(toFront: contentContainerView)
        }
        
        // Forwarding status bar style/hidden status to content view controller
        setNeedsStatusBarAppearanceUpdate()
        
        if let key = preferences.basic.defaultCacheKey {
            lazyCachedViewControllers[key] = contentViewController
        }
        
        configureGesturesRecognizer()
        setUpNotifications()
    }
    
    private func resolveDirection(with view: UIView) {
        var shouldReverseDirection = false
        if preferences.basic.shouldRespectLanguageDirection {
            let attribute = view.semanticContentAttribute
            let layoutDirection = UIView.userInterfaceLayoutDirection(for: attribute)
            if layoutDirection == .rightToLeft {
                shouldReverseDirection = true
            }
        }
        
        if shouldReverseDirection {
            adjustedDirection = (preferences.basic.direction == .left ? .right : .left)
        } else {
            adjustedDirection = preferences.basic.direction
        }
    }
    
    // MARK: Storyboard
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segue = segue as? SideMenuSegue, let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case contentSegueID:
            segue.contentType = .content
        case menuSegueID:
            segue.contentType = .menu
        default:
            break
        }
    }
    
    // MARK: Reveal/Hide Menu
    
    /// Reveals the menu.
    ///
    /// - Parameters:
    ///   - animated: If set to true, the process will be animated. The default is true.
    ///   - completion: Completion closure that will be executed after revaeling the menu.
    open func revealMenu(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        changeMenuVisibility(reveal: true, animated: animated, completion: completion)
    }
    
    /// Hides the menu.
    ///
    /// - Parameters:
    ///   - animated: If set to true, the process will be animated. The default is true.
    ///   - completion: Completion closure that will be executed after hiding the menu.
    open func hideMenu(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        changeMenuVisibility(reveal: false, animated: animated, completion: completion)
    }
    
    private func changeMenuVisibility(reveal: Bool,
                                      animated: Bool = true,
                                      shouldCallDelegate: Bool = true,
                                      shouldChangeStatusBar: Bool = true,
                                      completion: ((Bool) -> Void)? = nil) {
        menuViewController.beginAppearanceTransition(true, animated: true)
        
        if shouldCallDelegate {
            reveal ? delegate?.sideMenuWillReveal(self) : delegate?.sideMenuWillHide(self)
        }
        
        if reveal {
            addContentOverlayViewIfNeeded()
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let animationClosure = {
            self.menuContainerView.frame = self.sideMenuFrame(visibility: reveal)
            self.contentContainerView.frame = self.contentFrame(visibility: reveal)
            if self.shouldShowShadowOnContent {
                self.contentContainerOverlay?.alpha = reveal ? self.preferences.animation.shadowAlpha : 0
            }
        }
        
        let animationCompletionClosure : (Bool) -> Void = { finish in
            self.menuViewController.endAppearanceTransition()
            
            if shouldCallDelegate {
                reveal ? self.delegate?.sideMenuDidReveal(self) : self.delegate?.sideMenuDidHide(self)
            }
            
            if !reveal {
                self.contentContainerOverlay?.removeFromSuperview()
                self.contentContainerOverlay = nil
            }
            
            completion?(true)
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            self.isMenuRevealed = reveal
        }
        
        if animated {
            animateMenu(with: reveal, shouldChangeStatusBar: shouldChangeStatusBar, animations: animationClosure, completion: animationCompletionClosure)
        } else {
            setStatusBar(hidden: reveal)
            animationClosure()
            animationCompletionClosure(true)
            completion?(true)
        }
        
    }
    
    private func animateMenu(with reveal: Bool,
                             shouldChangeStatusBar: Bool = true,
                             animations: @escaping () -> Void,
                             completion: ((Bool) -> Void)? = nil) {
        let shouldAnimateStatusBarChange = preferences.basic.statusBarBehavior != .hideOnMenu
        if shouldChangeStatusBar && !shouldAnimateStatusBarChange && reveal {
            setStatusBar(hidden: reveal)
        }
        let duration = reveal ? preferences.animation.revealDuration : preferences.animation.hideDuration
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: preferences.animation.dampingRatio,
                       initialSpringVelocity: preferences.animation.initialSpringVelocity,
                       options: preferences.animation.options,
                       animations: {
                        if shouldChangeStatusBar && shouldAnimateStatusBarChange {
                            self.setStatusBar(hidden: reveal)
                        }
                        
                        animations()
        }) { (finished) in
            if shouldChangeStatusBar && !shouldAnimateStatusBarChange && !reveal {
                self.setStatusBar(hidden: reveal)
            }
            
            completion?(finished)
        }
    }
    
    // MARK: Gesture Recognizer
    
    private func configureGesturesRecognizer() {
        // The gesture will be added anyway, its delegate will tell whether it should be recognized
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(SideMenuController.handlePanGesture(_:)))
        panGesture.delegate = self
        panGestureRecognizer = panGesture
        view.addGestureRecognizer(panGesture)
    }
    
    private func addContentOverlayViewIfNeeded() {
        guard contentContainerOverlay == nil else {
            return
        }
        
        let overlay = UIView()
        overlay.bounds = contentContainerView.bounds
        overlay.center = contentContainerView.center
        if !shouldShowShadowOnContent {
            overlay.backgroundColor = .clear
        } else {
            overlay.backgroundColor = .black
            overlay.alpha = 0
        }
        overlay.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // UIKit can coordinate overlay's tap gesture and controller view's pan gesture correctly
        let tapToHideGesture = UITapGestureRecognizer()
        tapToHideGesture.addTarget(self, action: #selector(SideMenuController.handleTapGesture(_:)))
        overlay.addGestureRecognizer(tapToHideGesture)
        
        contentContainerView.insertSubview(overlay, aboveSubview: contentViewController.view)
        contentContainerOverlay = overlay
        contentContainerOverlay?.accessibilityIdentifier = "ContentShadowOverlay"
    }
    
    @objc private func handleTapGesture(_ tap: UITapGestureRecognizer) {
        hideMenu()
    }
    
    @objc private func handlePanGesture(_ pan: UIPanGestureRecognizer) {
        let menuWidth = preferences.basic.menuWidth
        let isLeft = adjustedDirection == .left
        var translation = pan.translation(in: pan.view).x
        let viewToAnimate: UIView
        let viewToAnimate2: UIView?
        var leftBorder: CGFloat
        var rightBorder: CGFloat
        let containerWidth: CGFloat
        switch preferences.basic.position {
        case .above:
            viewToAnimate = menuContainerView
            viewToAnimate2 = nil
            containerWidth = viewToAnimate.frame.width
            leftBorder = -containerWidth
            rightBorder = menuWidth - containerWidth
        case .under:
            viewToAnimate = contentContainerView
            viewToAnimate2 = nil
            containerWidth = viewToAnimate.frame.width
            leftBorder = 0
            rightBorder = menuWidth
        case .sideBySide:
            viewToAnimate = contentContainerView
            viewToAnimate2 = menuContainerView
            containerWidth = viewToAnimate.frame.width
            leftBorder = 0
            rightBorder = menuWidth
        }
        
        if !isLeft {
            swap(&leftBorder, &rightBorder)
            leftBorder *= -1
            rightBorder *= -1
        }
        
        switch pan.state {
        case .began:
            panningBaganPointX = viewToAnimate.frame.origin.x
            isValidatePanningBegan = false
        case .changed:
            let resultX = panningBaganPointX + translation
            let notReachLeftBorder = (!isLeft && preferences.basic.enableRubberEffectWhenPanning) || resultX >= leftBorder
            let notReachRightBorder = (isLeft && preferences.basic.enableRubberEffectWhenPanning) || resultX <= rightBorder
            guard notReachLeftBorder && notReachRightBorder else {
                return
            }
            
            if !isValidatePanningBegan {
                // Do some setup works in the initial step of validate panning. This can't be done in the `.began` period
                // because we can't know whether its a validate panning
                addContentOverlayViewIfNeeded()
                setStatusBar(hidden: true, animate: true)
                
                isValidatePanningBegan = true
            }
            
            let factor: CGFloat = isLeft ? 1 : -1
            let notReachDesiredBorder = isLeft ? resultX <= rightBorder : resultX >= leftBorder
            if notReachDesiredBorder {
                viewToAnimate.frame.origin.x = resultX
            } else {
                if !isMenuRevealed {
                    translation -= menuWidth * factor
                }
                viewToAnimate.frame.origin.x = (isLeft ? rightBorder : leftBorder) + factor * menuWidth * log10(translation * factor / menuWidth + 1) * 0.5
            }
            
            if let viewToAnimate2 = viewToAnimate2 {
                viewToAnimate2.frame.origin.x = viewToAnimate.frame.origin.x - containerWidth * factor
            }
            
            if shouldShowShadowOnContent {
                let shadowPercent = min(menuContainerView.frame.maxX / menuWidth, 1)
                contentContainerOverlay?.alpha = self.preferences.animation.shadowAlpha * shadowPercent
            }
        case .ended, .cancelled, .failed:
            let offset: CGFloat
            switch preferences.basic.position {
            case .above:
                offset = isLeft ? viewToAnimate.frame.maxX : containerWidth - viewToAnimate.frame.minX
            case .under, .sideBySide:
                offset = isLeft ? viewToAnimate.frame.minX : containerWidth - viewToAnimate.frame.maxX
            }
            let offsetPercent = offset / menuWidth
            let decisionPoint: CGFloat = isMenuRevealed ? 0.6 : 0.4
            if offsetPercent > decisionPoint {
                // We need to call the delegates, change the status bar only when the menu was previous hidden
                changeMenuVisibility(reveal: true, shouldCallDelegate: !isMenuRevealed, shouldChangeStatusBar: !isMenuRevealed)
            } else {
                changeMenuVisibility(reveal: false, shouldCallDelegate: isMenuRevealed, shouldChangeStatusBar: true)
            }
        default:
            break
        }
    }
    
    // MARK: Notification
    
    private func setUpNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(SideMenuController.appDidEnteredBackground),
                                               name: .UIApplicationDidEnterBackground,
                                               object: nil)
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func appDidEnteredBackground() {
        if preferences.basic.hideMenuWhenEnteringBackground {
            hideMenu(animated: false)
        }
    }
    
    // MARK: Status Bar
    
    private func setStatusBar(hidden: Bool, animate: Bool = false) {
        // UIKit provides `setNeedsStatusBarAppearanceUpdate` and couple of methods to animate the status bar changes.
        // The problem with this approach is it will hide the status bar and it's underlying space completely, as a result,
        // the navigation bar will go up as we don't expect.
        // So we need to manipulate the windows of status bar manually.
        
        let behavior = self.preferences.basic.statusBarBehavior
        guard let sbw = UIWindow.sb, sbw.isStatusBarHidden(with: behavior) != hidden else {
            return
        }
        
        if animate && behavior != .hideOnMenu {
            UIView.animate(withDuration: 0.4, animations: {
                sbw.setStatusBar(hidden, with: behavior)
            })
        } else {
            sbw.setStatusBar(hidden, with: behavior)
        }
        
        if behavior == .hideOnMenu {
            if !hidden {
                statusBarScreenShotView?.removeFromSuperview()
                statusBarScreenShotView = nil
            } else if statusBarScreenShotView == nil {
                statusBarScreenShotView = statusBarScreenShot()
                contentContainerView.insertSubview(statusBarScreenShotView!, aboveSubview: contentViewController.view)
            }
        }
    }
    
    private func statusBarScreenShot() -> UIView? {
        let statusBarFrame = UIApplication.shared.statusBarFrame
        let screenshot = UIScreen.main.snapshotView(afterScreenUpdates: false)
        screenshot.frame = statusBarFrame
        screenshot.contentMode = .top
        screenshot.clipsToBounds = true
        return screenshot
    }
    
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        // Forward to the content view controller
        return contentViewController
    }
    
    open override var childViewControllerForStatusBarHidden: UIViewController? {
        return contentViewController
    }
    
    // MARK: Caching
    
    /// Caches the closure that generate the view controller with identifier.
    ///
    /// It's useful when you want to configure the caching relation without instantiating the view controller immediately.
    ///
    /// - Parameters:
    ///   - viewControllerGenerator: The closure that generate the view controller. It will only executed when needed.
    ///   - identifier: Identifier used to change content view controller
    open func cache(viewControllerGenerator: @escaping () -> UIViewController?, with identifier: String) {
        lazyCachedViewControllerGenerators[identifier] = viewControllerGenerator
    }
    
    /// Caches the view controller with identifier.
    ///
    /// - Parameters:
    ///   - viewController: the view controller to cache
    ///   - identifier: the identifier
    open func cache(viewController: UIViewController, with identifier: String) {
        lazyCachedViewControllers[identifier] = viewController
    }
    
    /// Changes the content view controller to the cached one with given `identifier`.
    ///
    /// - Parameter identifier: the identifier that associates with a cache view controller or generator.
    open func setContentViewController(with identifier: String) {
        if let viewController = lazyCachedViewControllers[identifier] {
            contentViewController = viewController
        } else if let viewController = lazyCachedViewControllerGenerators[identifier]?() {
            lazyCachedViewControllerGenerators[identifier] = nil
            lazyCachedViewControllers[identifier] = viewController
            contentViewController = viewController
        }
    }

    /// Return the identifier of current content view controller.
    ///
    /// - Returns: if not exist, returns nil.
    open func currentCacheIdentifier() -> String? {
        guard let index = lazyCachedViewControllers.values.index(of: contentViewController) else {
            return nil
        }
        return lazyCachedViewControllers.keys[index]
    }

    /// Clears cached view controller or generators with identifier.
    ///
    /// - Parameter identifier: the identifier that associates with a cache view controller or generator.
    open func clearCache(with identifier: String) {
        lazyCachedViewControllerGenerators[identifier] = nil
        lazyCachedViewControllers[identifier] = nil
    }
    
    // MARK: - Helper Methods
    
    private func sideMenuFrame(visibility: Bool) -> CGRect {
        let position = preferences.basic.position
        switch position {
        case .above, .sideBySide:
            var baseFrame = view.frame
            if visibility {
                baseFrame.origin.x = preferences.basic.menuWidth - baseFrame.width
            } else {
                baseFrame.origin.x = -baseFrame.width
            }
            let factor: CGFloat = adjustedDirection == .left ? 1 : -1
            baseFrame.origin.x = baseFrame.origin.x * factor
            return baseFrame
        case .under:
            return view.frame
        }
    }
    
    private func contentFrame(visibility: Bool) -> CGRect {
        let position = preferences.basic.position
        switch position {
        case .above:
            return view.frame
        case .under, .sideBySide:
            var baseFrame = view.frame
            if visibility {
                let factor: CGFloat = adjustedDirection == .left ? 1 : -1
                baseFrame.origin.x = preferences.basic.menuWidth * factor
            } else {
                baseFrame.origin.x = 0
            }
            return baseFrame
        }
    }
    
    // MARK: Container View Controller
    
    private func load(_ viewController: UIViewController?, on view: UIView) {
        guard let viewController = viewController else {
            return
        }
        
        addChildViewController(viewController)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
    
    private func unload(_ viewController: UIViewController?) {
        guard let viewController = viewController else {
            return
        }
        
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    // MARK: Orientation
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return preferences.basic.supportedOrientations
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        hideMenu(animated: false, completion: { finished in
            // Temporally hide the menu container veiw for smooth animation
            self.menuContainerView.isHidden = true
            coordinator.animate(alongsideTransition: { (context) in
                self.contentContainerView.frame = self.contentFrame(visibility: self.isMenuRevealed)
            }) { (context) in
                self.menuContainerView.isHidden = false
                self.menuContainerView.frame = self.sideMenuFrame(visibility: self.isMenuRevealed)
            }
        })
            
        super.viewWillTransition(to: size, with: coordinator)
    }
}

// MARK: UIGestureRecognizerDelegate

extension SideMenuController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer.view == view && gestureRecognizer is UIPanGestureRecognizer {
            return preferences.basic.enablePanGesture
        }
        
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let contentView = panGestureRecognizer?.view, let currentView = otherGestureRecognizer.view else {
            return false
        }
        
        // When returning `true`, `panGestureRecognizer` will fail.
        // And it will prevent paning to reveal when the content view is a scroll view
        return gestureRecognizer === panGestureRecognizer && currentView.isDescendant(of: contentView)
    }
}
