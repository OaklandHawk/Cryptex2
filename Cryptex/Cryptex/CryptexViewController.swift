//
//  CryptexViewController.swift
//  Cryptex
//
//  Created by Taylor Lyles on 5/1/19.
//  Copyright © 2019 Taylor Lyles. All rights reserved.
//

import UIKit


class CryptexViewController: UIViewController {
	
	var letters = ["A", "B", "C", "D",
				   "E", "F", "G", "H",
				   "I", "J", "K", "L",
				   "M", "N", "O", "P",
				   "Q", "R", "S", "T",
				   "U", "V", "W", "X",
				   "Y", "Z"]
	
	var countdownTimer: Timer?
	let cryptexController = CryptexController()
	
	
	@IBOutlet weak var label: UILabel!
	@IBOutlet weak var picker: UIPickerView!
	@IBOutlet weak var button: UIButton!
	
	@IBAction func unlockButton(_ sender: Any) {
		if hasMatchingPassword() {
			print("success")
			presentCorrrectPasswordAlert()
		} else {
			print("you are a failure.")
			presentIncorrectPassword()
		}
	}
	
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
        
        updatedViews()
    }
    
    var cryptexs: [[String]] = [[String]]()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	
    
    func updatedViews() {
         label.text = cryptexController.currentCryptex?.hint
         picker.reloadAllComponents()
    }
	

    func hasMatchingPassword() -> Bool {
		guard let currentPassword = cryptexController.currentCryptex else { print("PROBLEM") ; return false }
		
		var letterInPickerView = [String]()
		
		for num in 0..<currentPassword.password.count {
			
			let rowIndex = picker.selectedRow(inComponent: num)
			
			guard let title = pickerView(picker, titleForRow: rowIndex, forComponent: num) else { continue }
			letterInPickerView.append(title)
			
			let combinedArray = letterInPickerView.joined().lowercased()
			
		}
		
		let combinedArray = letterInPickerView.joined().lowercased()
		return combinedArray == currentPassword.password.lowercased()
    }

	func reset(){
		countdownTimer?.invalidate()
		
		let newTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: false) { (_) in
			self.presentNoTimeRemainingAlert()
		}
		countdownTimer = newTimer
	}
	
	func newCryptextAndReset(){
		cryptexController.randomCryptex()
		updatedViews()
		reset()
	}
	
	func presentCorrrectPasswordAlert(){
		let alert = UIAlertController(title: "Awesome, you got it!", message: "Correct! :-)", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Attempt another Cryptex", style: .default, handler: { (_) in
			self.newCryptextAndReset()
		}))
		present(alert, animated: true, completion: nil)
	}
	
	func presentIncorrectPassword(){
		let alert = UIAlertController(title: "Incorrect", message: "Try Again", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
		
		present(alert, animated: true, completion: nil)
	}
	
	
	func presentNoTimeRemainingAlert(){
		let alert = UIAlertController(title: "Times Up", message: "No Time Left", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Try Again?", style: .default, handler: { (_) in
			self.reset()
		}))
		
		present(alert, animated: true, completion: nil)
	}
}
	
	


extension CryptexViewController: UIPickerViewDelegate, UIPickerViewDataSource {

func numberOfComponents(in pickerView: UIPickerView) -> Int {
	// For the number of components, think about how you can figure out how many characters are in the `currentCryptex`'s password.
	return cryptexController.currentCryptex?.password.count ?? 0
}

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
	// For the number of rows, we want to show as many rows as there are letters.
	return letters.count
	
}

func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
	// For the title of each row, we want to show the letter that corresponds to the row. i.e. row 0 should show "A", row 1 should show "B", etc.
	return letters[row]
}

}
