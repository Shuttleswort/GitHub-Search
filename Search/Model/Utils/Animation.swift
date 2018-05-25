//
//  Animation.swift
//  Search
//
//  Created by Vladimir Abdrakhmanov on 5/25/18.
//  Copyright © 2018 Vladimir Abdrakhmanov. All rights reserved.
//

import UIKit

enum ModalAnimationConstants {
    static let scale: CGFloat = 0.1
    static let translate: CGFloat = UIScreen.main.bounds.height
    static let dimmingViewRestorationId = "dimmingView"
    static let cornerRadius: CGFloat = 10.0
    static let fadeUpDuration: TimeInterval = 0.5
    static let fadeDownDuration: TimeInterval = 0.1
    static let slideUpDuration: TimeInterval = 0.5
    static let slideDownDuration: TimeInterval = 0.3
}


class ModalPresentationController: UIPresentationController {

    var dimmingView: UIView!

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.setupDimmingView()
    }

    func setupDimmingView() {
        self.dimmingView = UIView(frame: presentingViewController.view.bounds)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(tapRecognizer:)))
        self.dimmingView.addGestureRecognizer(tapRecognizer)
    }

    @objc func dimmingViewTapped(tapRecognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true, completion: nil)
    }

    override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView else {
            return
        }
        containerView.insertSubview(self.dimmingView, at: 0)
    }

    override func containerViewWillLayoutSubviews() {
        guard let containerView = containerView else {
            return
        }
        self.dimmingView.frame = containerView.bounds
        presentedView?.frame = self.frameOfPresentedViewInContainerView
    }

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return self.presentedViewController.preferredContentSize
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        var presentedViewFrame = CGRect.zero

        guard let presentedView = presentedView,
            let containerBounds = containerView?.bounds else {
                return presentedViewFrame
        }
        presentedViewFrame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
        presentedViewFrame.origin.x = (presentedView.bounds.width - self.presentedViewController.preferredContentSize.width) / 2
        presentedViewFrame.origin.y = (presentedView.bounds.height - self.presentedViewController.preferredContentSize.height) / 2

        return presentedViewFrame
    }
}


class ModalUpAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return ModalAnimationConstants.slideUpDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView = transitionContext.containerView

        let animationDuration = self.transitionDuration(using: transitionContext)

        toViewController?.view.transform = CGAffineTransform(translationX: 0, y: ModalAnimationConstants.translate)
        toViewController?.view.layer.cornerRadius = ModalAnimationConstants.cornerRadius
        toViewController?.view.clipsToBounds = true

        let dimmingView = UIView(frame: toViewController?.view.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0))
        dimmingView.restorationIdentifier = ModalAnimationConstants.dimmingViewRestorationId

        if let toView = toViewController?.view {
            containerView.addSubview(dimmingView)
            containerView.addSubview(toView)

        }

        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        dimmingView.alpha = 0.0

        let animator = UIViewPropertyAnimator(duration: animationDuration, dampingRatio: 0.7) {
            dimmingView.alpha = 1.0
            toViewController?.view.transform = .identity
        }

        animator.addCompletion { position in
            transitionContext.completeTransition(position == .end)
        }
        animator.startAnimation()
    }
}



class ModalDownAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return ModalAnimationConstants.slideDownDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let animationDuration = self.transitionDuration(using: transitionContext)

        let dimmingView: UIView? = containerView.subviews.filter { (view: UIView) -> Bool in
            return view.restorationIdentifier == ModalAnimationConstants.dimmingViewRestorationId
            }.first

        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .linear) {
            dimmingView?.alpha = 0.0
            fromViewController?.view.transform = CGAffineTransform(translationX: 0, y: ModalAnimationConstants.translate)
        }

        animator.addCompletion { position in
            if case .end = position {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        animator.startAnimation()
    }
}
