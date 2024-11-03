import UIKit
import PhotosUI
import CoreData

class AddRecipeController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var coordinator: AppCoordinator?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addRecipeButton: UIButton!
    @IBOutlet weak var instructionTextView: UITextView!
    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var constraintWidth3: NSLayoutConstraint!
    @IBOutlet weak var constraintWidth2: NSLayoutConstraint!
    @IBOutlet weak var constraintWidth1: NSLayoutConstraint!
    var images: [UIImage] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    weak var delegate: RecipeDelegate?
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        collectionView.delegate = self
        collectionView.dataSource = self
        if UIDevice.current.userInterfaceIdiom == .pad {
            constraintWidth1.constant = 600
            constraintWidth2.constant = 600
            constraintWidth3.constant = 600
        } else {
            constraintWidth1.constant = 342
            constraintWidth2.constant = 342
            constraintWidth3.constant = 342
        }
        
        let nib = UINib(nibName: "AddRecipeCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "AddRecipeCell")

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout

  
    }
    @IBAction func tapedGoBack(_ sender: Any) {
        coordinator?.goBack()
    }
    func requestPhotoAccess() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                DispatchQueue.main.async {
                    self.showImagePicker()
                }
            } else {
                print("Access to the gallery was denied.")
            }
        }
    }

    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)

        if let image = info[.originalImage] as? UIImage {
            images.append(image)
            collectionView.reloadData()
        }
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1  // Добавляем 1 для кнопки добавления фото
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddRecipeCell", for: indexPath) as? AddRecipeCell else {
            return UICollectionViewCell()
        }

        if indexPath.row == 0 {
            // Первая ячейка как кнопка добавления фото
            cell.configure(with: UIImage(named: "frameAddRecipe")!)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(uploadPhotoTapped))
            cell.addGestureRecognizer(tapGesture)
        } else {
            cell.configure(with: images[indexPath.row - 1])  // Отображаем изображения начиная с первого добавленного
            cell.gestureRecognizers?.forEach { cell.removeGestureRecognizer($0) }  // Убираем жесты для ячеек с изображениями
        }

        return cell
    }

    @objc func uploadPhotoTapped() {
        requestPhotoAccess()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    // Сохранение рецепта в Core Data
    @IBAction func addRecipeButtonTapped(_ sender: UIButton) {
        guard let name = nameTextfield.text, !name.isEmpty,
              let instructions = instructionTextView.text, !instructions.isEmpty else {
            showAlert(message: "Please fill in all fields before adding the recipe.")
            return
        }

        let backgroundContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let recipe = Recipe(context: backgroundContext)
            recipe.name = name
            recipe.instructions = instructions

            let resizedImages = self.images.compactMap { $0.resizedImage(targetSize: CGSize(width: 100, height: 100)) }
            let imageDataArray = resizedImages.compactMap { $0.pngData() }

            do {
                let serializedImagesData = try NSKeyedArchiver.archivedData(withRootObject: imageDataArray, requiringSecureCoding: false)
                recipe.imagesData = serializedImagesData
                try backgroundContext.save()
                
                DispatchQueue.main.async {
                    if let navigationController = self.navigationController {
                        navigationController.popToRootViewController(animated: true)
                    } 
                }
                print("Recipe saved successfully!")
            } catch {
                print("Failed to save recipe: \(error)")
            }
        }
    }

    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Incomplete Form", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
}
extension UIImage {
    func resizedImage(targetSize: CGSize) -> UIImage? {
        let size = self.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let newSize = widthRatio > heightRatio ?
                      CGSize(width: size.width * heightRatio, height: size.height * heightRatio) :
                      CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
