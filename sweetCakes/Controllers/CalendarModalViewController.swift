import UIKit
import FSCalendar

// Протокол для передачи выбранной даты обратно в основной контроллер
protocol CalendarModalDelegate: AnyObject {
    func didSelectDate(_ date: Date)
}

class CalendarModalViewController: UIViewController, FSCalendarDelegate {

    weak var delegate: CalendarModalDelegate?
    var calendar: FSCalendar!
    var calendarContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupCalendarContainer()
        setupCalendar()
    }

 
    private func setupBackgroundView() {
        let backgroundView = UIView(frame: self.view.bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissCalendar))
        backgroundView.addGestureRecognizer(tapGesture)
        self.view.addSubview(backgroundView)
    }

    
    private func setupCalendarContainer() {
        calendarContainer = UIView()
        calendarContainer.backgroundColor = .white
        calendarContainer.layer.cornerRadius = 15
        calendarContainer.layer.masksToBounds = true
        calendarContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(calendarContainer)

        
        NSLayoutConstraint.activate([
            calendarContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            calendarContainer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            calendarContainer.widthAnchor.constraint(equalToConstant: 320),
            calendarContainer.heightAnchor.constraint(equalToConstant: 320)
        ])
    }

    
    private func setupCalendar() {
        calendar = FSCalendar()
        calendar.delegate = self
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendarContainer.addSubview(calendar)

   
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: calendarContainer.topAnchor),
            calendar.bottomAnchor.constraint(equalTo: calendarContainer.bottomAnchor),
            calendar.leadingAnchor.constraint(equalTo: calendarContainer.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: calendarContainer.trailingAnchor)
        ])
    }


    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let today = Date()
        return date >= today || Calendar.current.isDateInToday(date)
    }


    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        delegate?.didSelectDate(date)
        dismiss(animated: true, completion: nil)
    }


    @objc private func dismissCalendar() {
        dismiss(animated: true, completion: nil)
    }
}
