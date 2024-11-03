import UIKit

class AddRecipeCell: UICollectionViewCell {
    private let borderView = UIView()
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
  
        borderView.layer.cornerRadius = 25
        borderView.layer.masksToBounds = true
        borderView.backgroundColor = .clear
        contentView.addSubview(borderView)


        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        borderView.addSubview(imageView)


        addDashedBorder(to: borderView)


        borderView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
        
            borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            borderView.topAnchor.constraint(equalTo: contentView.topAnchor),
            borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

      
            imageView.leadingAnchor.constraint(equalTo: borderView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: borderView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: borderView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: borderView.bottomAnchor),
        ])
    }

    func configure(with image: UIImage) {
        imageView.image = image
       
    }

    private func addDashedBorder(to view: UIView) {
        let dashedLayer = CAShapeLayer()
        dashedLayer.strokeColor = UIColor.systemPink.cgColor
        dashedLayer.lineWidth = 2
        dashedLayer.lineDashPattern = [6, 3]
        dashedLayer.fillColor = nil
        dashedLayer.path = UIBezierPath(roundedRect: view.bounds, cornerRadius: 25).cgPath
        view.layer.addSublayer(dashedLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        

        if let shapeLayer = borderView.layer.sublayers?.first as? CAShapeLayer {
            shapeLayer.path = UIBezierPath(roundedRect: borderView.bounds, cornerRadius: 25).cgPath
        }
    }
}
