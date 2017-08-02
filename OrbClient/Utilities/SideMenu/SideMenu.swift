                                                                                                                                                                                                                //
//  DLHamburguerViewController.swift
//  DLHamburguerMenu
//
//  Created by Nacho on 4/3/15.
//  Copyright (c) 2015 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit

/** Direction of menu appearance */
enum DLHamburguerMenuPlacement: Int {
    case Left = 0, Right, Top, Bottom
}

/** Visual style of the menu */
enum DLHamburguerMenuBackgroundStyle: Int {
    case Light = 0, Dark = 1
    
    func toBarStyle() -> UIBarStyle {
        return UIBarStyle(rawValue: self.rawValue)!
    }
}

// Constants
private let kDLHamburguerMenuSpan: CGFloat = 50.0

/**
 * The DLHamburguerViewController is the main VC managing the content view controller and the menu view controller.
 * These view controllers will be contained in the main container view controller.
 * The menuViewController will be shown when panning or invoking the showMenuViewController method.
 * The contentViewController will contain the application main content VC, probably a UINavigationController.
 */
class SideMenu: UIViewController,UIGestureRecognizerDelegate {
    // pan gesture recognizer.
    var gestureRecognizer: UIPanGestureRecognizer?
    var gestureEnabled = true
    
    // appearance
    var overlayAlpha: CGFloat = 0.3                                // % of dark fading of the background (0.0 - 1.0)
    var animationDuration: TimeInterval = 0.35
    
    
    // duration of the menu animation.
    var desiredMenuViewSize: CGSize?                                // if set, menu view size will try to adhere to these limits
    var actualMenuViewSize: CGSize = CGSize.zero                    // Actual size of the menu view
    var menuVisible = false                                         // Is the hamburguer menu currently visible?
    
    // delegate
    var delegate: SideMenuDelegate?
    
    // settings
    var menuDirection: DLHamburguerMenuPlacement = .Left
    var menuBackgroundStyle: DLHamburguerMenuBackgroundStyle = .Dark
    
    // structure & hierarchy
    var containerViewController: DLHamburguerContainerViewController!
    private var _contentViewController: UINavigationController!
    var contentViewController: UINavigationController! {
        get {
            return _contentViewController
        }
        set {
            if _contentViewController == nil {
                _contentViewController = newValue
                return
            }
            // remove old links to previous hierarchy
            _contentViewController.removeFromParentViewController()
            _contentViewController.view.removeFromSuperview()
            
            // update hierarchy
            if newValue != nil {
                self.addChildViewController(newValue)
                newValue.view.frame = self.containerViewController.view.frame
                self.view.insertSubview(newValue.view, at: 0)
                newValue.didMove(toParentViewController: self)
            }
            _contentViewController = newValue
            
            // update status bar appearance
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    private var _menuViewController: UIViewController!
    var menuViewController: UIViewController! {
        get {
            return _menuViewController
        }
        set {
            // remove old links to previous hierarchy
            if _menuViewController != nil {
                _menuViewController.view.removeFromSuperview()
                _menuViewController.removeFromParentViewController()
            }
            _menuViewController = newValue
            
            // update hierarchy
            let frame = _menuViewController.view.frame
            _menuViewController.willMove(toParentViewController: nil)
            _menuViewController.removeFromParentViewController()
            _menuViewController.view.removeFromSuperview()
            _menuViewController = newValue
            if _menuViewController == nil { return }
            
            // add menu to container view hierarchy
            self.containerViewController.addChildViewController(newValue)
            newValue.view.frame = frame
            self.containerViewController?.containerView?.addSubview(newValue.view)
            newValue.didMove(toParentViewController: self)
        }
    }
    
    // MARK: - Lifecycle
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupHamburguerViewController()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHamburguerViewController()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupHamburguerViewController()
       // self.navigationController?.navigationBar.hidden = true
    }
    
    convenience init(contentViewController: UINavigationController, menuViewController: UIViewController) {
        self.init()
        let navVC = UINavigationController.init(rootViewController: contentViewController)
        
        _contentViewController = navVC;

        self.contentViewController = contentViewController
        self.menuViewController = menuViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hamburguerDisplayController(controller: contentViewController, inFrame: self.view.bounds)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - VC management
    
   private  func childViewControllerForStatusBarStyle() -> UIViewController? {
        return self.contentViewController
    }
    
    private func childViewControllerForStatusBarHidden() -> UIViewController? {
        return self.contentViewController
    }
    
    // MARK: - Setup DLHamburguerViewController
    
    internal func setupHamburguerViewController() {
        // initialize container view controller
        containerViewController = DLHamburguerContainerViewController()
        containerViewController.hamburguerViewController = self
        
        // initialize gesture recognizer

        
        gestureRecognizer = UIPanGestureRecognizer(target: containerViewController!, action: #selector(SideMenu.panGestureRecognized(recognizer:)))


        
    }
    
    // MARK: - Presenting and managing menu.
    /** Main function for presenting the menu */
    func showMenuViewController() { self.showMenuViewControllerAnimated(animated: true, completion: nil) }
    
    /** Detailed function for presenting the menu, with options */
    func showMenuViewControllerAnimated(animated: Bool, completion: ((Void) -> Void)? = nil) {
        // inform that the menu will show
        
        delegate?.hamburguerViewController!(hamburguerViewController: self, willShowMenuViewController: self.menuViewController)
        
        self.containerViewController.shouldAnimatePresentation = animated
        // calculate menu size
        adjustMenuSize()
        
        // present menu controller
        self.hamburguerDisplayController(controller: self.containerViewController, inFrame: self.contentViewController.view.frame)
        self.menuVisible = true
        
        // call completion handler.
        completion?()
    }
    
    func adjustMenuSize(forRotation: Bool = false) {
        var w: CGFloat = 0.0
        var h: CGFloat = 0.0
        
        if desiredMenuViewSize != nil { // Try to adjust to desired values
            w = desiredMenuViewSize!.width > 0 ? desiredMenuViewSize!.width : contentViewController.view.frame.size.width
            h = desiredMenuViewSize!.height > 0 ? desiredMenuViewSize!.height : contentViewController.view.frame.size.height
        } else { // Calculate menu size based on direction.
            var span: CGFloat = 0.0
            if self.menuDirection == .Left || self.menuDirection == .Right {
                span = kDLHamburguerMenuSpan
            }
            if forRotation { w = self.contentViewController.view.frame.size.height - span; h = self.contentViewController.view.frame.size.width }
            else { w = self.contentViewController.view.frame.size.width - span; h = self.contentViewController.view.frame.size.height }

        }
        self.actualMenuViewSize = CGSize(width:w, height:h)
        
    }

    /** Hides the menu controller */
    func hideMenuViewControllerWithCompletion(completion: ((Void) -> Void)?) {
        if !self.menuVisible { completion?(); return }
        self.containerViewController.hideWithCompletion(completion: completion)
    }

    func resizeMenuViewControllerToSize(size: CGSize) {
        self.containerViewController.resizeToSize(size: size)
    }
    
    
    // MARK: - Gesture recognizer
    
    func panGestureRecognized(recognizer: UIPanGestureRecognizer) {
        
        self.delegate?.hamburguerViewController!(hamburguerViewController: self, didPerformPanGesture: recognizer)
        if self.gestureEnabled {
            if recognizer.state == .began { self.showMenuViewControllerAnimated(animated: true, completion: nil) }
            self.containerViewController.panGestureRecognized(recognizer: recognizer)
        }
    }

    
    // MARK: - Rotation legacy support (iOS 7)
    
    

    private func shouldAutorotate() -> Bool {
        return self.contentViewController.shouldAutorotate
    }

     override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        // call super and inform delegate
        super.willAnimateRotation(to: toInterfaceOrientation, duration: duration)
        
        
        self.delegate?.hamburguerViewController!(hamburguerViewController: self, willAnimateRotationToInterfaceOrientation: toInterfaceOrientation, duration: duration)
        // adjust size of menu if visible only.
        self.containerViewController.setContainerFrame(frame: self.menuViewController.view.frame)
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotate(from: fromInterfaceOrientation)
        if !self.menuVisible { self.actualMenuViewSize = CGSize.zero }
        adjustMenuSize(forRotation: true)
    }
    
    // MARK: - Rotation (iOS 8)
    
     func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        // call super and inform delegate
        if #available(iOS 8.0, *) {
            self.viewWillTransitionToSize(size: size, withTransitionCoordinator: coordinator)
        } else {
            // Fallback on earlier versions
        }
        
        delegate?.hamburguerViewController!(hamburguerViewController: self, willTransitionToSize: size, withTransitionCoordinator: coordinator)
        // adjust menu size if visible
        
        
        
        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.containerViewController.setContainerFrame(frame: self.menuViewController.view.frame)
            }, completion: {(finalContext) -> Void in
                if !self.menuVisible { self.actualMenuViewSize = CGSize.zero }
                self.adjustMenuSize(forRotation: true)
        })
        
        
    }

}


/** Extension for presenting and hiding view controllers from the Hamburguer container. */
extension UIViewController {
    func hamburguerDisplayController(controller: UIViewController, inFrame frame: CGRect) {
        self.addChildViewController(controller)
        controller.view.frame = frame
        self.view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    
    func hamburguerHideController(controller: UIViewController) {
        controller.willMove(toParentViewController: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParentViewController()
    }
    
    func findHamburguerViewController() -> SideMenu? {
        var vc = self.parent
        while vc != nil {
            if let dlhvc = vc as? SideMenu { return dlhvc }
            else if vc != nil && vc?.parent != vc { vc = vc!.parent }
            else { vc = nil }
        }
        return nil
    }
}

@objc protocol SideMenuDelegate  {
    @objc optional func hamburguerViewController(hamburguerViewController: SideMenu, didPerformPanGesture gestureRecognizer: UIPanGestureRecognizer)
    @objc optional func hamburguerViewController(hamburguerViewController: SideMenu, willShowMenuViewController menuViewController: UIViewController)
    @objc optional func hamburguerViewController(hamburguerViewController: SideMenu, didShowMenuViewController menuViewController: UIViewController)
    @objc optional func hamburguerViewController(hamburguerViewController: SideMenu, willHideMenuViewController menuViewController: UIViewController)
    @objc optional func hamburguerViewController(hamburguerViewController: SideMenu, didHideMenuViewController menuViewController: UIViewController)
    @objc optional func hamburguerViewController(hamburguerViewController: SideMenu, willTransitionToSize size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    // Support for legacy iOS 7 rotation.
    @objc optional func hamburguerViewController(hamburguerViewController: SideMenu, willAnimateRotationToInterfaceOrientation toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval)
}