//
//  DataBaseManager.swift
//  grinta
//
//  Created by Linda adel on 26/08/2023.
//

import Foundation
import UIKit
import CoreData

struct DatabaseManager {
    static let shared = DatabaseManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "grinta")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading persistent stores: \(error)")
            }
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func addFavoriteMatch(with matchData: MatchesDataModel) {
        let context = persistentContainer.viewContext
        
        let favouratiedMatch = MatcheDataEntity(context: context)
        favouratiedMatch.homeTeam = matchData.homeTeam?.name
        favouratiedMatch.awayTeam = matchData.awayTeam?.name
        favouratiedMatch.score = matchData.score?.winner
        favouratiedMatch.id = matchData.id?.description
        favouratiedMatch.isFavourite = true

        saveContext()
    }
    
    func removeFavoriteItem(id: String) {
        let context = persistentContainer.viewContext
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MatcheDataEntity")
           fetchRequest.predicate = NSPredicate(format: "id == %@", id)
           
           let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
           
           do {
               try context.execute(batchDeleteRequest)
               saveContext()
           } catch {
               print("Error removing favorite item: \(error)")
           }
    }
    
    func isItemFavorite(id: String) -> Bool {
        let context = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<MatcheDataEntity> = MatcheDataEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking favorite status: \(error)")
             return false
      }
    }
}
