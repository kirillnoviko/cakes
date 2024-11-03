import UIKit



class CakeCell: UICollectionViewCell {
    
    @IBOutlet weak var cakeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    
    var addButtonTapped: (() -> Void)?
    var incrementButtonTapped: (() -> Void)?
    var decrementButtonTapped: (() -> Void)?
    
    override func awakeFromNib() {
           super.awakeFromNib()
         
           self.layer.cornerRadius = 13
           self.layer.masksToBounds = true
       }
    
    func configure(with cake: Cake) {
        cakeImageView.image = cake.image
        nameLabel.text = cake.name
        descriptionLabel.text = cake.description
        quantityLabel.text = "\(cake.quantity)"
        
        addButton.isHidden = cake.quantity > 0
        quantityLabel.isHidden = cake.quantity == 0
        incrementButton.isHidden = cake.quantity == 0
        decrementButton.isHidden = cake.quantity == 0
    }
    func disableButton(){
        incrementButton.isHidden = true
        decrementButton.isHidden = true
    }
   
    @IBAction func addButtonPressed(_ sender: UIButton) {
        addButtonTapped?()
    }
    
    @IBAction func incrementButtonPressed(_ sender: UIButton) {
        incrementButtonTapped?()
    }
    
    @IBAction func decrementButtonPressed(_ sender: UIButton) {
        decrementButtonTapped?()
    }
}
