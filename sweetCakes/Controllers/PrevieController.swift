import UIKit

class PrevieController: UIViewController {



    @IBOutlet weak var rotatImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startRotatingAnimation()
    }
    
  

    func startRotatingAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = 2 * CGFloat.pi
        rotation.duration = 1.0
        rotation.repeatCount = Float.infinity 
        rotatImgView.layer.add(rotation, forKey: "rotate")
    }
}
