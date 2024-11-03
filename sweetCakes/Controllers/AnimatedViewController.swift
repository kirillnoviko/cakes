import UIKit



class AnimatedViewController: UIViewController {

    @IBOutlet weak var animatedImageView: UIImageView!  
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var selectionContainerView: UIView!
    @IBOutlet weak var imageHorizontalConstraint: NSLayoutConstraint!

    @IBOutlet weak var constaraintWidth: NSLayoutConstraint!
    
    @IBOutlet weak var constraintWidth2: NSLayoutConstraint!
    
    @IBOutlet weak var constraintWidthButton: NSLayoutConstraint!
    
    @IBOutlet weak var constraintHeightButton: NSLayoutConstraint!
    
    @IBOutlet weak var constraintVerticalButton: NSLayoutConstraint!
    
    
    @IBOutlet weak var imageVerticalContstraint: NSLayoutConstraint!
    var coordinator: AppCoordinator?
    var selectedShapeImage: UIImage?
    var selectedCreamImage: UIImage?
    @IBOutlet weak var viewLabel: UIView!
    var selectedSprinkleImage: UIImage?
    var selectedBatter: String?
    var selectedFilling: String?        
    private var stepHistory: [SelectionStep] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        selectionContainerView.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewLabel.isHidden = true
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            constaraintWidth.constant = 600
            constraintWidth2.constant = 600
            constraintWidthButton.constant = 240
            constraintHeightButton.constant = 240
            imageVerticalContstraint.constant = 310
           
        }else{
            constaraintWidth.constant = 342
            constraintWidth2.constant = 342
            constraintWidthButton.constant = 140
            constraintHeightButton.constant = 140
            imageVerticalContstraint.constant = 183
        }
        self.view.layoutIfNeeded()
            selectionContainerView.isHidden = true
            animateImageToCenter()

            animatedImageView.isUserInteractionEnabled = true
          
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            animatedImageView.addGestureRecognizer(tapGesture)
       
    }
  
    @IBAction func backButtonTapped(_ sender: UIButton) {
          if let lastStep = stepHistory.popLast() {
              if stepHistory.isEmpty {
                  coordinator?.goBack()
              } else {
                  showSelectionView(step: stepHistory.last!)
              }
          }
      }
  
    @IBAction func backToMain(_ sender: UIButton) {
        coordinator?.goBack()
    }
    func animateImageToCenter() {
      
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            imageVerticalContstraint.constant = 290
           
        }else{
            imageVerticalContstraint.constant = 165
        }
        
        imageHorizontalConstraint.constant = view.bounds.width / 2.5
            
            UIView.animate(withDuration: 3.0, animations: {
                self.view.layoutIfNeeded()
            }) { _ in
                UIView.animate(withDuration: 1) {
                    self.viewLabel.isHidden = false
                }
            }
    }
    
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        viewLabel.isHidden = true
        animatedImageView.isHidden = true
        showSelectionView(step: .shapeSelection)
    }
}
extension AnimatedViewController {
    func showSelectionView(step: SelectionStep) {
        if(stepHistory.last != step){
            stepHistory.append(step)
        }
        
        selectionContainerView.isHidden = false
        
        switch step {
        case .shapeSelection:
            loadShapeSelectionView()
        case .batterSelection:
            loadBatterSelectionView()
        case .fillingSelection:
             loadFillingSelectionView()
        case .creamSelection:
            loadCreamSelectionView()
        case .sprinkleSelection:
            loadSprinkleSelectionView()
        case .summary:
            loadSummaryView()
    
        }
    }
    
    func loadShapeSelectionView() {
        
        guard let shapeView = Bundle.main.loadNibNamed("ShapeView", owner: self, options: nil)?.first as? ShapeSelectionView else {
                 return
             }

      
             shapeView.onShapeSelected = { [weak self] selectedImage in
                 self?.selectedShapeImage = selectedImage
                 self?.showSelectionView(step: .batterSelection)
             }

         
             presentInContainer(shapeView)
    }
    
    func loadBatterSelectionView() {
        guard let shapeView = Bundle.main.loadNibNamed("BatterView", owner: self, options: nil)?.first as? BatterSelectionView else {
                 return
             }

         
             shapeView.onBatterSelected = { [weak self] selectedImage in
                 self?.selectedBatter = selectedImage
                 self?.showSelectionView(step: .fillingSelection)
             }

         
             presentInContainer(shapeView)
    }
    
    func loadFillingSelectionView() {
        guard let shapeView = Bundle.main.loadNibNamed("FillingView", owner: self, options: nil)?.first as? FillingSelectionView else {
                 return
             }

             
             shapeView.onFillingSelected = { [weak self] selectedImage in
                 self?.selectedFilling = selectedImage
                 self?.showSelectionView(step: .creamSelection)
             }

             
             presentInContainer(shapeView)
    }
    
    func loadCreamSelectionView() {
        guard let shapeView = Bundle.main.loadNibNamed("CreamView", owner: self, options: nil)?.first as? CreamSelectionView else {
                 return
             }

            
             shapeView.onCreamSelected = { [weak self] selectedImage in
                 self?.selectedCreamImage = selectedImage
                 self?.showSelectionView(step: .sprinkleSelection)
             }

           
             presentInContainer(shapeView)
    }
 
    func loadSprinkleSelectionView() {
        guard let shapeView = Bundle.main.loadNibNamed("SprinkleView", owner: self, options: nil)?.first as? SprinkleSelectionView else {
                print("sdfsdf")
                 return
             }

             shapeView.onSprinkleSelected = { [weak self] selectedImage in
                 self?.selectedSprinkleImage = selectedImage
                 self?.showSelectionView(step: .summary)
             }

             
             presentInContainer(shapeView)
    }
//    
  
    
 
//    
    func loadSummaryView() {
        guard let summaryView = Bundle.main.loadNibNamed("SummaryView", owner: self, options: nil)?.first as? SummaryView else {
                print("sdfsdf")
                 return
             }

    
        summaryView.configure(
            shape: selectedShapeImage!,
            cream: selectedCreamImage!,
            sprinkle: selectedSprinkleImage!,
            batter: selectedBatter!,
            filling: selectedFilling!
        )
        summaryView.onSave = { [weak self] in
                  self?.saveRecipe()
            if let navigationController = self?.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
              }
              
              summaryView.onTryAgain = { [weak self] in
                  self?.showSelectionView(step: .shapeSelection)
              }
        presentInContainer(summaryView)
    }
}
extension AnimatedViewController {
    func presentInContainer(_ view: UIView) {
       
        selectionContainerView.subviews.forEach { $0.removeFromSuperview() }
        
        
        view.frame = selectionContainerView.bounds
        selectionContainerView.addSubview(view)
        
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: selectionContainerView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: selectionContainerView.trailingAnchor),
            view.topAnchor.constraint(equalTo: selectionContainerView.topAnchor),
            view.bottomAnchor.constraint(equalTo: selectionContainerView.bottomAnchor)
        ])
    }
}
extension AnimatedViewController {
    func saveRecipe() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let recipe = Recipe(context: context)
        recipe.name = "Custom Recipe"
        
        
        var images: [UIImage] = []
        if let shapeImage = selectedShapeImage { images.append(shapeImage) }
        if let creamImage = selectedCreamImage { images.append(creamImage) }
        if let sprinkleImage = selectedSprinkleImage { images.append(sprinkleImage) }
        
     
        let imageDataArray = images.compactMap { $0.pngData() }
        
  
        do {
            let serializedImagesData = try NSKeyedArchiver.archivedData(withRootObject: imageDataArray, requiringSecureCoding: false)
            recipe.imagesData = serializedImagesData
        } catch {
            print("Failed to serialize image data: \(error)")
            return
        }

        recipe.instructions = generateInstructions()
        
        
        do {
            try context.save()
            print("Recipe saved successfully!")
        } catch {
            print("Failed to save recipe: \(error)")
        }
    }

    func generateInstructions() -> String {
        var instructions = "Brownie batter: \(selectedBatter ?? "No batter selected")\n"
        instructions += "Brownie filling: \(selectedFilling ?? "No filling selected")\n\n"
        instructions += "The shape of the cake is shown in the first image.\n"
        instructions += "The cream is displayed in the second image.\n"
        instructions += "The sprinkle is in the third image."
        
        return instructions
    }

}

enum SelectionStep {
    case shapeSelection
    case creamSelection
    case sprinkleSelection
    case batterSelection
    case fillingSelection
    case summary
}
