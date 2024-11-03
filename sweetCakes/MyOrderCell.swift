import UIKit

class MyOrderCell: UICollectionViewCell {

    @IBOutlet weak var contentView2: UIView!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
   
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cakeNamesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cakeQuantitiesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var cancelOrderAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 13
        self.layer.masksToBounds = true
        setupScrollView()
    }
    
    private func setupScrollView() {
   
        contentView2.addSubview(scrollView)
        
     
        scrollView.addSubview(contentContainerView)
        
       
        contentContainerView.addSubview(cakeNamesLabel)
        contentContainerView.addSubview(cakeQuantitiesLabel)
        

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView2.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: contentView2.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: contentView2.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: contentView2.bottomAnchor, constant: 0),
            
        ])
        

        NSLayoutConstraint.activate([
            contentContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        

        NSLayoutConstraint.activate([
            cakeNamesLabel.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 8),
            cakeNamesLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant: 8),
            cakeNamesLabel.widthAnchor.constraint(equalTo: contentContainerView.widthAnchor, multiplier: 0.8),
            
            cakeQuantitiesLabel.topAnchor.constraint(equalTo: contentContainerView.topAnchor, constant: 8),
            cakeQuantitiesLabel.leadingAnchor.constraint(equalTo: cakeNamesLabel.trailingAnchor, constant: 8),
            cakeQuantitiesLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant: -8),
            cakeQuantitiesLabel.widthAnchor.constraint(equalTo: contentContainerView.widthAnchor, multiplier: 0.2),
            cakeQuantitiesLabel.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with order: Order) {
        if let cakesSet = order.cakesSelected as? Set<CakeOrder> {
            let cakeNames = cakesSet.compactMap { $0.name }
            let cakeQuantities = cakesSet.map { "x\($0.quantity)" }
            
            cakeNamesLabel.text = cakeNames.joined(separator: "\n")
            cakeQuantitiesLabel.text = cakeQuantities.joined(separator: "\n")
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        // Форматтер для времени (строки в формате "1:00 AM")
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a" // Формат времени из строки

        // Проверка наличия даты и времени
        if let deliveryDate = order.date, let deliveryTimeString = order.time,
           let deliveryTime = timeFormatter.date(from: deliveryTimeString) {
            
            // Объединяем дату и время в одну дату-время
            var calendar = Calendar.current
            let deliveryDateTime = calendar.date(bySettingHour: calendar.component(.hour, from: deliveryTime),
                                                 minute: calendar.component(.minute, from: deliveryTime),
                                                 second: 0,
                                                 of: deliveryDate) ?? deliveryDate

            // Устанавливаем текст доставки
            deliveryTimeLabel.text =  (dateFormatter.string(from: deliveryDateTime))
            
            // Проверка на доставку, сравниваем с текущим временем
            if deliveryDateTime < Date() {
                statusLabel.text = "Completed"
                statusLabel.textColor = .green
            } else {
                statusLabel.text = ""
            }
        }
    }

    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        cancelOrderAction?()
    }
}
