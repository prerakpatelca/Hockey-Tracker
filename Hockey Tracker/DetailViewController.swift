//
//  DetailViewController.swift
//  Hockey Tracker
//
//  Created by Prerak Patel on 2020-11-10.
//  Copyright © 2020 Mohawk College. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var opponentTextField: UITextField!
    @IBOutlet var goalsTextField: UITextField!
    @IBOutlet var assistsTextField: UITextField!
    @IBOutlet var plsminusTextField: UITextField!
    @IBOutlet var gameDatePicker: UIDatePicker!
    
    // Receving the Game data from the GamesViewController
    // Updating the Navigation Controller accordinly if the game exists
    var game: Game! {
        didSet {
            if game.opponent != "" {
                navigationItem.title = game.opponent
            } else {
                navigationItem.title = "New Game"
            }
        }
    }
    
    // Formatting the number to with no decimal
    let numberFormatter: NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    // Overriding the viewWillAppear to inflate the data
    // into the TextField
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Inflating the data into TextField
        opponentTextField.text = game.opponent
        goalsTextField.text = "\(game.goals)"
        assistsTextField.text = "\(game.assists)"
        plsminusTextField.text = "\(game.plusMinus)"
        gameDatePicker.date = game.gameDate
    }
    
    // Overriding the viewWillDisappear to save the data
    // when the view disappers
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Keyboard didn't disapper when we pressed back button
        // Clear first responder
        view.endEditing(true)
        
        
        // "Save" changes to item
        // game.opponent is optional so we are using coalsce operator
        game.opponent = opponentTextField.text ?? ""
        
        // If the opponentTextField is empty do not store the value
        if opponentTextField.text != "" {
        // Storing the values from the TextField to update the game into the GameStore
            if let goalsText = goalsTextField.text, let value = numberFormatter.number(from: goalsText) {
                game.goals = value.intValue
            } else {
                game.goals = 0
            }
            
            if let assistsText = assistsTextField.text, let value = numberFormatter.number(from: assistsText) {
                game.assists = value.intValue
            } else {
                game.assists = 0
            }
            
            if let plsminusText = plsminusTextField.text, let value = numberFormatter.number(from: plsminusText) {
                game.plusMinus = value.intValue
            } else {
                game.plusMinus = 0
            }
            game.gameDate = gameDatePicker.date
        }
    }
    
    // UITextFieldDelegate library method to make
    // keyboard disappear when the return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Function triggers when the user wanted make the
    // keyboard goes away to tap away
    @IBAction func disappearKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
