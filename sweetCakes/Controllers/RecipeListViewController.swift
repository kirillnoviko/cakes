import UIKit
import CoreData

class RecipeListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, RecipeDelegate {

    
    var coordinator: AppCoordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noRecipesLabel: UILabel!
    @IBOutlet weak var addRecipeButton: UIButton!
    
    var recipes: [Recipe] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad {
            constraintWidth.constant = 600
          
           
        }else{
            constraintWidth.constant = 342
      
        }

        let nib = UINib(nibName: "RecipeCell", bundle: nil)
          collectionView.register(nib, forCellWithReuseIdentifier: "RecipeCell")
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true
        noRecipesLabel.isHidden = true
        addRecipeButton.isHidden = false
        
        loadRecipes()
    }
    
    @IBAction func goBack(_ sender: Any) {
        coordinator?.goBack()
    }
    func loadRecipes() {
        let request: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        do {
            recipes = try context.fetch(request)
            
            if recipes.isEmpty {
                noRecipesLabel.isHidden = false
                addRecipeButton.isHidden = false
            } else {
                collectionView.isHidden = false
                collectionView.reloadData()
            }
        } catch {
            print("Failed to fetch recipes: \(error)")
        }
    }
    
    @IBAction func addRecipeTapped(_ sender: UIButton) {
        coordinator?.showAddRecipes()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
        let recipe = recipes[indexPath.row]
        
        cell.titleLabel.text = recipe.name
        cell.descriptionLabel.text = recipe.instructions

        if let imageData = recipe.imagesData {
            DispatchQueue.global(qos: .background).async {
                if let imageDataArray = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(imageData) as? [Data],
                   let firstImage = imageDataArray.first,
                   let image = UIImage(data: firstImage) {
                    let thumbnail = image.resizedImage(targetSize: CGSize(width: 100, height: 100))
                    DispatchQueue.main.async {
                        cell.thumbnailImageView.image = thumbnail
                    }
                }
            }
        } else {
            cell.thumbnailImageView.image = UIImage(named: "placeholder")
        }
        
        return cell
    }

    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.showDetailRecipe(with: recipes[indexPath.row])
        
        
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,height: collectionView.frame.height/3) 
    }
    func reloadRecipes() {
            loadRecipes()
           collectionView.reloadData()
       }

      
       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let addRecipeVC = segue.destination as? AddRecipeController {
               addRecipeVC.delegate = self
           }
       }
}
protocol RecipeDelegate: AnyObject {
    func reloadRecipes()
}
