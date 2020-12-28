//  I, Prerak Patel, student number 000825410, certify that this material is my original work. No other person's work has been used without due acknowledgement and I have not made my work available to anyone else.

//  GamesViewController.swift
//  Hockey Tracker
//
//  Created by Prerak Patel on 2020-11-09.
//  Copyright © 2020 Mohawk College. All rights reserved.
//

import UIKit

class GamesViewController: UITableViewController {
    
    // Reciving the gameStore from the SceneDelegate
    var gameStore: GameStore!{
        didSet {
            updateTitle()
        }
    }
    
    // Formatting the data to Nov 10, 2020 with medium date style
    // and no time style
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // Overriding viewDidLoad function
    override func viewDidLoad() {
        super.viewDidLoad()
        // .automaticDimension will auto adjust its height to suit the content
        tableView.rowHeight = UITableView.automaticDimension
        // this line helps makes the calculation for the above line little bit faster
        tableView.estimatedRowHeight = 65
        // Setting the Edit Navigation Bar button on left side
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // Function to return the length of the array so that it can call the tableView cellForRowAt
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameStore.games.count
    }
    
    // Function for loading tableViewCell with the appropriate data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        // Reusing the same tableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        // Getting the reference for the current game from the GameStore
        let game = gameStore.games[indexPath.row]
            
        // If the oppnent is empty then populate the tableViewCell with Detail Required
        // Else populate the tableViewCell with the actual data
        if game.opponent == "" {
            cell.textLabel?.text = "New game, detail required"
            cell.imageView?.image = UIImage.init(named: "blank")
        } else {
            var imageName = "blank"
            if game.plusMinus < 0 {
                imageName = "red"
            } else if game.plusMinus == 0 {
                imageName = "yellow"
            } else if game.plusMinus > 0 {
                imageName = "green"
            }
            // Inflating the imageView with the appropriate Image
            // calculated based on the plusminus
            cell.imageView?.image = UIImage.init(named: imageName)
            // Inflating the Opponent name - Data - Points for each game
            cell.textLabel?.text = game.opponent + " - \(dateFormatter.string(from: game.gameDate)) - \(game.points) " + String.localizedStringWithFormat(NSLocalizedString("points",
            comment: ""), game.points)
            
        }
            return cell
    }
    
    // Function triggered when user tries to Delete when the Editing Mode is turned on
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // IF the table view is asking to commit a delete command
        if editingStyle == .delete {
            let game = gameStore.games[indexPath.row]
            
            gameStore.delete(game)
            
            // Also remove that row from the table view wih an animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateTitle()
        }
    }
    
    // Function triggers when the user clicks on "+" Navigation Bar Button
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        let newGame = gameStore.create()
            
        // Figure out where that item is in the array
        if let index = gameStore.games.firstIndex(of: newGame) {
            let indexPath = IndexPath(row: index, section: 0)
            
            // Insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
            updateTitle()
        }
    }
    
    // Function is triggered when the user tries to move the order of tableViewCells
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        gameStore.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }

    // Function to send the data to DetailViewController by overriding the "prepare" method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        // If there is just one segue you don't need switch case
        if let row = tableView.indexPathForSelectedRow?.row {
            // Get the item associated with this row and pass it along
            let item = gameStore.games[row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.game = item
        }
    }
    
    // Function to update the Navigation title with Total Games - Total Points
    func updateTitle(){
        var totalPoints = 0
        // Looping through the games array to get the total game points
        // in all the games
        for game in gameStore.games {
            totalPoints = totalPoints + game.points
        }
        // Creating the title using NSLocalizedString to get return "0 Games, 1 Games, 2 Games and same with points"
        navigationItem.title = "\(gameStore.games.count) " + String.localizedStringWithFormat(NSLocalizedString("games",
        comment: ""), gameStore.games.count) + " - \(totalPoints) " + String.localizedStringWithFormat(NSLocalizedString("points",
        comment: ""), totalPoints)
    }
    
    // Overriding the function to update the Navigation title and the update tableViewData
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTitle()
        tableView.reloadData()
    }
        
}
