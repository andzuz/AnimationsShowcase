import UIKit
import PlaygroundSupport

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 2.0
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Set up transition
        let containerView = transitionContext.containerView
        guard let toVC = transitionContext.viewController(forKey: .to) as? SecondViewController else { return }
        
        let initialFrame = originFrame
        let finalFrame = toVC.view.frame
        
        // need to calculate scale
        // x: initial Widh / final Widh
        // y: initial Height / final Height
        toVC.view.transform = CGAffineTransform(scaleX: initialFrame.width / finalFrame.width, y: initialFrame.height / finalFrame.height)
        toVC.view.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
        containerView.addSubview(toVC.view)
        
        // Animate
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.0,
            animations: {
                toVC.view.transform = .identity
                toVC.view.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }) { _ in
            // Complete transition
            transitionContext.completeTransition(true)
        }
    }
    
}

class FirstViewController : UIViewController {
    
    let commonView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let transition = Animator()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        view.addSubview(commonView)
        commonView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commonView.heightAnchor.constraint(equalToConstant: 300.0),
            commonView.widthAnchor.constraint(equalToConstant: 300.0),
            commonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            commonView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
            guard let self = self else { return }
            
            let secondVC = SecondViewController()
            secondVC.transitioningDelegate = self
            self.present(secondVC, animated: true)
        }
    }
    
}

// MARK: - UIViewControllerTransitioningDelegate

extension FirstViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // Set the frame for the view
        transition.originFrame = commonView.superview!.convert(commonView.frame, to: nil)
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
}

class SecondViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
}
