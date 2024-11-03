import UIKit

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var selectionCircle: UIImageView! 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      
        backgroundColor = .clear
        selectionStyle = .none
        
        
        selectionCircle.image = UIImage(systemName: "circle")
        selectionCircle.tintColor = .gray
    }
    
    func configure(with address: String, isSelected: Bool) {
        addressLabel.text = address
        
        
        selectionCircle.image = isSelected ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle")
        selectionCircle.tintColor = .white
    }
}

