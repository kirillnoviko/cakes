import UIKit

class OrderCakesController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var coordinator: AppCoordinator?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var orderButton: UIButton!
    
    @IBOutlet weak var constraintWidthCollection: NSLayoutConstraint!
    var cakes: [Cake] = [
        Cake(id: UUID(), name: "Rainbow Delight", description: "Bright cake with colorful layers of sponge cake decorated with whipped cream and colorful sprinkles.", image: UIImage(named: "cake3")!, quantity: 0),
        Cake(id: UUID(), name: "Choco Lava Dream", description: "A brownie with rich chocolate filling that melts with the first bite. Topped with melted chocolate.", image: UIImage(named: "cake5")!, quantity: 0),
        Cake(id: UUID(), name: " Lemon Cloud", description: " Delicate lemon cake with lemon cream inside and airy protein cream on top, sprinkled with lemon zest.", image: UIImage(named: "cake2")!, quantity: 0),
        Cake(id: UUID(), name: "Vanilla Dream", description: " Classic vanilla cake with cream based on natural vanilla, decorated with whipped cream.", image: UIImage(named: "cake4")!, quantity: 0),
        Cake(id: UUID(), name: "  Strawberry Cupcake", description: "Cupcake with cream cheese filling and fresh strawberry pieces, decorated with strawberry cream.", image: UIImage(named: "cake1")!, quantity: 0),
       
      
        
       
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        orderButton.isHidden = true
        if UIDevice.current.userInterfaceIdiom == .pad {
            constraintWidthCollection.constant = 600
          
           
        }else{
            constraintWidthCollection.constant = 342
      
        }
        
        let nib = UINib(nibName: "CakeCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CakeCell")
             
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cakes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CakeCell", for: indexPath) as! CakeCell
        let cake = cakes[indexPath.item]
        cell.configure(with: cake)
        
       
        cell.addButtonTapped = { [weak self] in
            self?.incrementQuantity(for: cake)
        }
        cell.incrementButtonTapped = { [weak self] in
            self?.incrementQuantity(for: cake)
        }
        cell.decrementButtonTapped = { [weak self] in
            self?.decrementQuantity(for: cake)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let interItemSpacing: CGFloat = 10
        
      
        let totalPadding = padding * 2
        let cellWidth = (collectionView.frame.width - totalPadding)
        
        var cellheigth = (collectionView.frame.height - totalPadding) / 4
        if UIDevice.current.userInterfaceIdiom == .pad {
            cellheigth = (collectionView.frame.height - totalPadding) / 5
        }
        return CGSize(width: cellWidth, height: cellheigth)
    }
    
    private func incrementQuantity(for cake: Cake) {
        if let index = cakes.firstIndex(where: { $0.id == cake.id }) {
            cakes[index].quantity += 1
            collectionView.reloadData()
            orderButton.isHidden = cakes.contains { $0.quantity > 0 } == false
        }
    }
    
    private func decrementQuantity(for cake: Cake) {
        if let index = cakes.firstIndex(where: { $0.id == cake.id }) {
            cakes[index].quantity = max(0, cakes[index].quantity - 1)
            collectionView.reloadData()
            orderButton.isHidden = cakes.contains { $0.quantity > 0 } == false
        }
    }
    
   
    @IBAction func buttonGoBack(_ sender: UIButton) {
        coordinator?.goBack()
    }
    func getSelectedCakes() -> [Cake] {
            return cakes.filter { $0.quantity > 0 }
        }
        
    
        @IBAction func orderButtonTapped(_ sender: UIButton) {
            let selectedCakes = getSelectedCakes()
            coordinator?.showOrderPlace(with: selectedCakes)
        }
}

