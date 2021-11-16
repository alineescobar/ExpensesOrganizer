//
//  CustomSizePresentationController.swift
//  ExpensesOrganizer
//
//  Created by Diego Henrique on 04/11/21.
//

import UIKit

class CustomSizePresentationController: UIPresentationController {
    let blurEffectView: UIVisualEffectView!
    var heightMultiplier: CGFloat = -1
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    var panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()
    var interactor: Interactor = Interactor()
    
    @objc
    func dismiss() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: presentedViewController.view)
        let verticalMovement = translation.y / presentedViewController.view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            self.presentedViewController.dismiss(animated: true)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish ? interactor.finish() :
            interactor.cancel()
        default:
            break
        }
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismiss))
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(_:)))
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView.isUserInteractionEnabled = true
        self.blurEffectView.addGestureRecognizer(tapGestureRecognizer)
        self.presentedViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override func dismissalTransitionWillBegin() {
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.alpha = 0
        }, completion: { _ in
            self.blurEffectView.removeFromSuperview()
        })
    }
    
    override func presentationTransitionWillBegin() {
        self.blurEffectView.alpha = 0
        self.containerView?.addSubview(blurEffectView)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.blurEffectView.alpha = 1
        }, completion: { _ in
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.layer.masksToBounds = true
        presentedView?.layer.cornerRadius = 10
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        self.presentedView?.frame = frameOfPresentedViewInContainerView
        blurEffectView.frame = containerView?.bounds ?? CGRect()
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let bounds = containerView?.bounds else {
            return .zero
        }
        return CGRect(x: 0, y: bounds.height - (bounds.height * heightMultiplier), width: bounds.width, height: bounds.height * heightMultiplier)
    }
}

class Interactor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}
