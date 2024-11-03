import UIKit
import CoreData

class MyOrdersController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var coordinator: AppCoordinator?
    var orders: [Order] = []
    
    @IBOutlet weak var contstraintWidth: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad {
            contstraintWidth.constant = 600
          
           
        }else{
            contstraintWidth.constant = 342
      
        }
        let nib = UINib(nibName: "MyOrderCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "MyOrderCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchOrders()
    }
    
    @IBAction func buttonGoBack(_ sender: Any) {
        coordinator?.goBack()
    }
    
    func fetchOrders() {
        let request: NSFetchRequest<Order> = Order.fetchRequest()
        
        do {
            orders = try context.fetch(request)
            collectionView.reloadData()
        } catch {
            print("Failed to fetch orders: \(error)")
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
        
        let order = orders[indexPath.item]
        cell.configure(with: order)
        
    
        cell.cancelOrderAction = { [weak self] in
            self?.cancelOrder(order)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let totalPadding = padding * 2
        let cellWidth = collectionView.frame.width - totalPadding
        let cellHeight: CGFloat = 150
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func cancelOrder(_ order: Order) {
        context.delete(order)
        
        do {
            try context.save()
            fetchOrders()
        } catch {
            print("failed: \(error)")
        }
    }
}
