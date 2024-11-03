import UIKit
//import FSCalendar
import CoreData

class OrderPlaceController: UIViewController,  UITableViewDelegate, UITableViewDataSource,  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var orders: [Order] = []
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mainView: UIView!
    var coordinator: AppCoordinator?
    var selectedCakes: [Cake] = []
        
    var selectedDate: Date? // для выбранной даты
    var selectedTime: String?
    
    @IBOutlet weak var stackEnterName: UIStackView!
    @IBOutlet weak var constraintStackEnterName: NSLayoutConstraint!
    @IBOutlet weak var viewTextFieldEnterName: UIView!
    @IBOutlet weak var textFieldEnterName: UITextField!
    
    
    
    @IBOutlet weak var constraintStackSelectDate: NSLayoutConstraint!
    @IBOutlet weak var stackSelectDate: UIStackView!
    @IBOutlet weak var stackClock: UIStackView!
    @IBOutlet weak var dateButton: UIButton!
    // Переменные для хранения выбранной страны и адреса
    @IBOutlet weak var clock1: UIButton!
    @IBOutlet weak var clock2: UIButton!
    @IBOutlet weak var clock3: UIButton!
    
    
    
    @IBOutlet weak var constraintGreatBritaintStack: NSLayoutConstraint!
    @IBOutlet weak var constraintGermanyStack: NSLayoutConstraint!
    @IBOutlet weak var constraintCanadaStack: NSLayoutConstraint!
    @IBOutlet weak var canadaStack: UIStackView!
    @IBOutlet weak var germanyStack: UIStackView!
    @IBOutlet weak var greatBritainStack: UIStackView!
    
    var selectedCountry: String?
    var selectedAddress: String?
    
    @IBOutlet weak var canadaButton: UIButton!
    @IBOutlet weak var germanyButton: UIButton!
    @IBOutlet weak var greatBritainButton: UIButton!
    
  
    @IBOutlet weak var canadaTableView: UITableView!
    @IBOutlet weak var germanyTableView: UITableView!
    @IBOutlet weak var greatBritainTableView: UITableView!
    
    
    @IBOutlet weak var cakesViewStack: UIStackView!
    @IBOutlet weak var constraintCakesViewStack: NSLayoutConstraint!
    
    @IBOutlet weak var constraintViewCollection: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
  
    @IBOutlet weak var constraintWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintButton: NSLayoutConstraint!
    let addressesByCountry: [String: [String]] = [
        "Canada": ["1600 Amphitheatre Parkway, Toronto, ON M5H 1P9", "555 Seymour Street, Vancouver, BC V6B 3H6", "150 King St W, Toronto, ON M5H 1J9"],
        "Germany": ["Friedrichstraße 123, 10117 Berlin", "Marienplatz 15, 80331 München", "Kaiserstraße 3, 60311 Frankfurt am Main"],
        "Great Britain": ["Friedrichstraße 123, 10117 Berlin", "Marienplatz 15, 80331 München", "Kaiserstraße 3, 60311 Frankfurt am Main"]
    ]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "CakeCell", bundle: nil)
          collectionView.register(nib, forCellWithReuseIdentifier: "CakeCell")
        
        
        stackClock.isHidden = true
        clock1.isEnabled = false
        clock3.isEnabled = false
        
        canadaTableView.delegate = self
        canadaTableView.dataSource = self
        germanyTableView.delegate = self
        germanyTableView.dataSource = self
        greatBritainTableView.delegate = self
        greatBritainTableView.dataSource = self
        
      
        canadaTableView.isHidden = true
        germanyTableView.isHidden = true
        greatBritainTableView.isHidden = true
        
        
     
        updateCollectionViewHeight()
        textFieldEnterName.delegate = self
            
           
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            constraintStackEnterName.constant = 600
            constraintStackSelectDate.constant = 600
            constraintGreatBritaintStack.constant = 600
            constraintGermanyStack.constant = 600
            constraintCanadaStack.constant = 600
            constraintCakesViewStack.constant = 600
     
            constraintWidth.constant = 600
           
        }else{
            constraintStackEnterName.constant = 342
            constraintStackSelectDate.constant = 342
            constraintGreatBritaintStack.constant = 342
            constraintGermanyStack.constant = 342
            constraintCanadaStack.constant = 342
            constraintCakesViewStack.constant = 342
            constraintButton.constant =  279
            constraintWidth.constant = 342
        }
        
   

       setupTableViews()
        
       
        fetchAllOrdersWithCakes()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
 
        scrollView.layoutIfNeeded()
        
  
        if let contentView = scrollView.subviews.first {
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentView.frame.height)
        }
    }
  
    
    @IBAction func buttonGoBack(_ sender: UIButton) {
        coordinator?.goBack()
    }
    func clearTables() {
 
        let entities = ["Order", "CakeOrder"]
        
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
                print("\(entity) table cleared successfully.")
            } catch let error as NSError {
                print("Failed to clear \(entity) table: \(error), \(error.userInfo)")
            }
        }
    }
    func fetchAllOrdersWithCakes() {
            let request: NSFetchRequest<Order> = Order.fetchRequest()
            
            do {
                orders = try context.fetch(request)
                
                for order in orders {
                    print("Order name: \(order.name ?? "No name")")
                    print("Order name: \(order.address ?? "No address")")
                    print("Order name: \(order.country ?? "No country")")
                    print("Order name: \(order.time ?? "No time")")
                    print("Order name: \(order.address ?? "No address")")
                    
                    if let cakesSet = order.cakesSelected as? Set<CakeOrder> {
                        for cake in cakesSet {
                            print("Cake: \(cake.name ?? "No name"), Quantity: \(cake.quantity)")
                        }
                    }
                }
            } catch {
                print("Failed to fetch orders: \(error)")
            }
        }
    private func updateCollectionViewHeight() {
          if selectedCakes.count >= 2 {
              constraintViewCollection.constant = 340
          } else {
              constraintViewCollection.constant = 170
          }
          
          
          view.layoutIfNeeded()
      }
    deinit {
       
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func keyboardWillHide() {
        view.gestureRecognizers?.forEach { recognizer in
            if recognizer is UITapGestureRecognizer {
                view.removeGestureRecognizer(recognizer)
            }
        }
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    

        @IBAction func dateButtonTapped(_ sender: UIButton) {
            guard selectedAddress != nil else {
                showAlertWithMessage("Please select an address before selecting a date.")
                return
            }

            showCalendarModal()
        }

      
        func showCalendarModal() {
            let calendarVC = CalendarModalViewController()
            calendarVC.delegate = self
            calendarVC.modalPresentationStyle = .overFullScreen
            present(calendarVC, animated: true, completion: nil)
        }



    @IBAction func timeButtonTapped(_ sender: UIButton) {
        selectedTime = sender.title(for: .normal)
        updateSelectedTimeButton(sender)
    }

    private func updateSelectedTimeButton(_ selectedButton: UIButton) {
        // Сбрасываем состояние всех кнопок времени
        [clock1, clock2, clock3].forEach { button in
            button?.isSelected = (button == selectedButton)
        }
    }
   
    func setupTableViews() {
       
        let tableViews = [canadaTableView, germanyTableView, greatBritainTableView]
        
        tableViews.forEach { tableView in
            tableView?.dataSource = self
            tableView?.delegate = self
            tableView?.isHidden = true
            tableView?.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
            
           
            tableView?.separatorStyle = .none
            tableView?.backgroundColor = .clear
        }
    }
    

    func updateCountryButtonAppearance(_ button: UIButton, isExpanded: Bool) {
           let imageName = isExpanded ? "buttonMultiselectEnable" : "buttonMultiselect"
           button.setBackgroundImage(UIImage(named: imageName), for: .normal)
       }
    
    // MARK: - Действия для кнопок стран
    
    @IBAction func canadaButtonTapped(_ sender: UIButton) {
        toggleTableView(for: "Canada", sender: sender)
    }
    
    @IBAction func germanyButtonTapped(_ sender: UIButton) {
        toggleTableView(for: "Germany", sender: sender)
    }
    
    @IBAction func greatBritainButtonTapped(_ sender: UIButton) {
        toggleTableView(for: "Great Britain", sender: sender)
    }
    
    func toggleTableView(for country: String, sender: UIButton) {
  
        let buttonsAndTables: [(UIButton, UITableView)] = [
            (canadaButton, canadaTableView),
            (germanyButton, germanyTableView),
            (greatBritainButton, greatBritainTableView)
        ]

        for (button, tableView) in buttonsAndTables {
            tableView.isHidden = true
            updateCountryButtonAppearance(button, isExpanded: false)
        }
        
     
        selectedCountry = country
        selectedAddress = nil
        

        var isExpanded = false
        switch country {
        case "Canada":
            canadaTableView.isHidden.toggle()
            isExpanded = !canadaTableView.isHidden
            canadaTableView.reloadData()
        case "Germany":
            germanyTableView.isHidden.toggle()
            isExpanded = !germanyTableView.isHidden
            germanyTableView.reloadData()
        case "Great Britain":
            greatBritainTableView.isHidden.toggle()
            isExpanded = !greatBritainTableView.isHidden
            greatBritainTableView.reloadData()
        default:
            break
        }
        
  
        updateCountryButtonAppearance(sender, isExpanded: isExpanded)
    }

    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let country = selectedCountry else { return 0 }
        return addressesByCountry[country]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = selectedCountry ?? ""
        let addresses = addressesByCountry[country] ?? []
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        let address = addresses[indexPath.row]
        
     
        cell.configure(with: address, isSelected: address == selectedAddress)
        
        return cell
    }
    
//    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Выбрана строка: \(indexPath.row) в таблице: \(tableView)")

        let country = selectedCountry ?? ""
        let addresses = addressesByCountry[country] ?? []

        selectedAddress = addresses[indexPath.row]


        tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return selectedCakes.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CakeCell", for: indexPath) as! CakeCell
            let cake = selectedCakes[indexPath.item]
            cell.configure(with: cake)
            return cell
        }
        
        // Настройка размеров ячейки (по аналогии с OrderCakesController)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let padding: CGFloat = 10
           let totalPadding = padding * 2
        var cellWidth = collectionView.frame.width - totalPadding
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            cellWidth = 580
        }
        
           let cellHeight: CGFloat
           if selectedCakes.count >= 2 {
               cellHeight = (collectionView.frame.height - totalPadding) / 2
           } else {
               cellHeight = collectionView.frame.height - totalPadding
           }
           
           return CGSize(width: cellWidth, height: cellHeight)
       }
 
    // Вспомогательная функция для получения кнопки по названию страны
    func getButton(for country: String) -> UIButton? {
        switch country {
        case "Canada":
            return canadaButton
        case "Germany":
            return germanyButton
        case "Great Britain":
            return greatBritainButton
        default:
            return nil
        }
    }
    @IBAction func placeOrderButtonTapped(_ sender: UIButton) {
        guard let name = textFieldEnterName.text, !name.isEmpty,
                    let date = selectedDate,
                    let time = selectedTime else {
                  showAlertWithMessage("Please enter your name, select a date, and choose a time.")
                  return
              }
              
              saveOrder(name: name, date: date, time: time)
    }
    private func showAlertWithMessage(_ message: String) {
         let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default))
         present(alert, animated: true)
     }
    private func saveOrder(name: String, date: Date, time: String) {
            let order = Order(context: context)
            order.name = name
            order.date = date
            order.time = time
            order.country = selectedCountry ?? ""
            order.address = selectedAddress ?? ""
            
            for cake in selectedCakes {
                let cakeOrder = CakeOrder(context: context)
                cakeOrder.name = cake.name
                cakeOrder.quantity = Int32(cake.quantity)
                order.addToCakesSelected(cakeOrder)
            }
            
            do {
                try context.save()
                print("Order saved successfully!")
                navigationController?.popToRootViewController(animated: true)
            } catch {
                print("Failed to save order: \(error)")
            }
        }

    
    
}
extension OrderPlaceController: CalendarModalDelegate {

    func didSelectDate(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: date)
        dateButton.setTitle(dateString, for: .normal)
        selectedDate = date
        
        stackClock.isHidden = false

        // Проверяем наличие заказов по выбранной дате и адресу
        checkExistingOrders(for: date, at: selectedAddress)
    }

    private func checkExistingOrders(for date: Date, at address: String?) {
        guard let address = address else {
            // Если адрес не выбран, включаем все кнопки времени
            enableAllTimeButtons()
            return
        }
        
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        
        // Устанавливаем диапазон для поиска записей на выбранную дату (начало и конец дня)
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let endOfDay = calendar.date(byAdding: components, to: startOfDay)

        // Фильтр по дате и адресу
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date <= %@ AND address == %@", startOfDay as NSDate, endOfDay! as NSDate, address)

        do {
            let existingOrders = try context.fetch(fetchRequest)
            if !existingOrders.isEmpty {
                // Если есть заказы на выбранную дату и адрес, отключаем время
                disableTimeButtons(for: existingOrders)
            } else {
                enableAllTimeButtons()
            }
        } catch {
            print("Failed to fetch orders for selected date and address: \(error)")
        }
    }

    private func disableTimeButtons(for orders: [Order]) {
        let takenTimes = orders.compactMap { $0.time }
        
        clock1.isEnabled = !takenTimes.contains(clock1.title(for: .normal) ?? "")
        clock2.isEnabled = !takenTimes.contains(clock2.title(for: .normal) ?? "")
        clock3.isEnabled = !takenTimes.contains(clock3.title(for: .normal) ?? "")
    }

    private func enableAllTimeButtons() {
        clock1.isEnabled = true
        clock2.isEnabled = true
        clock3.isEnabled = true
    }
}
