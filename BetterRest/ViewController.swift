//
//  ViewController.swift
//  BetterRest
//
//  Created by MindMansion on 2019-03-30.
//  Copyright © 2019 MindMansion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var wakeUpTime: UIDatePicker!
    
    var sleepAmountTime: UIStepper!
    var sleepAmounLabel: UILabel!
    
    var coffeeAmountStepper: UIStepper!
    var coffeeAmountLabel: UILabel!
    
    
    // create a custom view
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        
        // set the view margins
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        
            ])
        
        // create a label and add to view
        let wakeUpTitle = UILabel()
        wakeUpTitle.font = UIFont.preferredFont(forTextStyle: .headline)
        wakeUpTitle.numberOfLines = 0
        wakeUpTitle.text = "When do you want to wake up?"
        mainStackView.addArrangedSubview(wakeUpTitle)
        
        
        // intantiate  and set a wakeup time
        wakeUpTime = UIDatePicker()
        wakeUpTime.datePickerMode = .time
        wakeUpTime.minuteInterval = 15
        mainStackView.addArrangedSubview(wakeUpTime)
        
        // create a standard default wakeup time
        var components = Calendar.current.dateComponents([.hour, .minute], from: Date())
        components.hour = 8
        components.minute = 0
        wakeUpTime.date = Calendar.current.date(from: components) ?? Date()
        
        //TODO: please chage this to function later
        // Create sleepTitle and add to view
        let sleepTitle = UILabel()
        sleepTitle.font = UIFont.preferredFont(forTextStyle: .headline)
        sleepTitle.numberOfLines = 0
        sleepTitle.text = "what's the minimum amount of sleep you need?"
        mainStackView.addArrangedSubview(sleepTitle)
        
        
        // Instantiate stepper for sleepTime
        // TODO: please change the steppers to a function later
        sleepAmountTime = UIStepper()
        sleepAmountTime.addTarget(self, action: #selector(sleepAmountChanged), for: .valueChanged) // call sleep amount changed function and update tha stepper value
        sleepAmountTime.stepValue = 0.25
        sleepAmountTime.value = 8
        sleepAmountTime.minimumValue = 4
        sleepAmountTime.maximumValue = 12
        
        sleepAmounLabel = UILabel()
        sleepAmounLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
        let sleepStackView = UIStackView()
        sleepStackView.spacing = 20
        sleepStackView.addArrangedSubview(sleepAmountTime)
        sleepStackView.addArrangedSubview(sleepAmounLabel)
        mainStackView.addArrangedSubview(sleepStackView)
        
    
        // coffee title and stapper
        let coffeeTitle = UILabel()
        coffeeTitle.font = UIFont.preferredFont(forTextStyle: .headline)
        coffeeTitle.numberOfLines = 0
        coffeeTitle.text = "How much coffee do you drink each day?"
        mainStackView.addArrangedSubview(coffeeTitle)
        
        coffeeAmountStepper = UIStepper()
        coffeeAmountStepper.addTarget(self, action: #selector(coffeeAmontChanged), for: .valueChanged) // TODO: change to a function, used more than once
        coffeeAmountStepper.minimumValue = 1
        coffeeAmountStepper.maximumValue = 20
        
        coffeeAmountLabel = UILabel()
        coffeeAmountLabel.font = UIFont.preferredFont(forTextStyle: .body)
        
    
        let coffeeStackview = UIStackView()
        coffeeStackview.spacing = 20
        coffeeStackview.addArrangedSubview(coffeeAmountStepper)
        coffeeStackview.addArrangedSubview(coffeeAmountLabel)
        mainStackView.addArrangedSubview(coffeeStackview)
        
        //Apply custom spacing
        mainStackView.setCustomSpacing(10, after: sleepTitle)
        mainStackView.setCustomSpacing(20, after: sleepStackView)
        mainStackView.setCustomSpacing(10, after: coffeeTitle)
        
        
        //Call the helper fuctions
        sleepAmountChanged()
        coffeeAmontChanged()
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        title = "Better Rest"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Calculate", style: .plain, target: self, action: #selector(calculateBedTime))
    }
    
    
    // update sleepTime change label
    @objc func sleepAmountChanged(){
        
        sleepAmounLabel.text = String(format: "%g hour", sleepAmountTime.value)
        
    }
    
    // update coffee amount changed label
    @objc func coffeeAmontChanged() {
        if coffeeAmountStepper.value == 1 {
            coffeeAmountLabel.text = "1 cup"
        }else {
            
            coffeeAmountLabel.text = "\(Int(coffeeAmountStepper.value)) cups"
        }
    }
    
    @objc func calculateBedTime(){
        let model = SleepCalculator()
        
        let title: String
        let message: String
        
        do {
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime.date) // get the date components from our component
            
            let hour = (components.hour ?? 0) * 60 * 60 // wakeUp hour in seconds
            let minute = (components.minute ?? 0) * 60
            
            let predication = try model.prediction(coffee: coffeeAmountStepper.value, estimatedSleep: sleepAmountTime.value, wake: Double(hour + minute))
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            let wakeDate = wakeUpTime.date - predication.actualSleep
            message = formatter.string(from: wakeDate)
            
            title = "Your ideal bedtime is..."
            
        
            
        } catch  {
            
            title = "Error"
            message = "Sorry there was a proble calculating your bedTime."
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
        
        
    }

}

