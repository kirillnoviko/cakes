import UIKit
import CoreData

class RecipeDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var coordinator: AppCoordinator?
    var recipe: Recipe?
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    @IBOutlet weak var constraintWidth2: NSLayoutConstraint!
    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "AddRecipeCell", bundle: nil)
        imagesCollectionView.register(nib, forCellWithReuseIdentifier: "AddRecipeCell")
        if UIDevice.current.userInterfaceIdiom == .pad {
            constraintWidth.constant = 600
            constraintWidth2.constant = 600
          
           
        }else{
            constraintWidth.constant = 342
            constraintWidth2.constant = 342
          
        }
        
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        
        descriptionTextView.layer.cornerRadius = 13 // Замените 10 на нужное значение для скругления
        descriptionTextView.layer.masksToBounds = true
        titleTextField.isUserInteractionEnabled = false
        descriptionTextView.isUserInteractionEnabled = false
        
        loadRecipeDetails()
    }
    
    @IBAction func goBack(_ sender: Any) {
        coordinator?.goBack()
    }
    func loadRecipeDetails() {
        guard let recipe = recipe else { return }
        
        titleTextField.text = recipe.name
        descriptionTextView.text = recipe.instructions
        
        // Десериализуем изображения асинхронно
        if let imageData = recipe.imagesData {
            DispatchQueue.global(qos: .background).async {
                if let imageDataArray = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(imageData) as? [Data] {
                    self.images = imageDataArray.compactMap { UIImage(data: $0) }
                    DispatchQueue.main.async {
                        self.imagesCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddRecipeCell", for: indexPath) as! AddRecipeCell
        
        cell.configure(with: images[indexPath.row])
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:  collectionView.frame.height, height: collectionView.frame.height)
    }
}

