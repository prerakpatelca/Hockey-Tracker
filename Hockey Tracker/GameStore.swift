//
//  GameStore.swift
//  Hockey Tracker
//
//  Created by Prerak Patel on 2020-11-09.
//  Copyright © 2020 Mohawk College. All rights reserved.
//

import UIKit

class GameStore {
    
    // Creating Game Array to store all the objects of Game
    var games = [Game]()
    
    // Getting the file path to the iPhone Directory to persist the Games array data
    // Then creating file if it does not exist
    let itemArchiveURL: URL = {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent("games.plist")
    }()
    
    // Initializer to read the array data from the file saved in the directory
    init() {
        // Handling the functions with do catch as they throws error
        do{
            let data = try Data(contentsOf: itemArchiveURL)
            let unarchiver = PropertyListDecoder()
            let decodedGames = try unarchiver.decode([Game].self, from: data)
            games = decodedGames
        } catch {
            print("Error reading in saved games: \(error)")
        }
        
        // Saving the data on background when the application is destroyed
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    // Creating the Game and making it discardableResult so that we can just call the method without storing the return value
    @discardableResult func create() -> Game {
        let newGame = Game()
        // Appending the newly created Game to the games array
        games.append(newGame)
        return newGame
    }
    
    // Deleting the Game from the games array
    func delete(_ game: Game) {
        // finding the first occurence of the game passed to delete
        if let index = games.firstIndex(of: game) {
            games.remove(at: index)
        }
    }
    
    // Moving the Game in the games array
    func move(from fromIndex: Int, to toIndex: Int){
        // if the trying move to the same position
        if fromIndex == toIndex {
            return
        }
        
        // Referencing the object trying to move so that we can reinsert it after
        let movedGame = games[fromIndex]
        
        // Removing game from array
        games.remove(at: fromIndex)
        
        // Inserting the referenced game in array at new location
        games.insert(movedGame,at: toIndex)
    }
    
    // Saving all the games to the file
    @objc func saveChanges() -> Bool {
        print("Saving games to: \(itemArchiveURL)")
        // Handling the functions with do catch as they throws error
        do{
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(games)
            try data.write(to: itemArchiveURL, options: [.atomic])
            print("Saved all the games")
            return true
        } catch let encodingError {
            print("Error encoding all games: \(encodingError)")
        }
        return false
    }
}
