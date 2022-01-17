//
//  ProgressPresenter.swift
//  iTobacWorker
//
//  Created by Nikolas on 07.12.2021.
//

import CoreData
import UIKit

//MARK: DELEGATE

protocol ProgressStoreDelegate: Any {
    func saveUserData(_ data: UserData)
    func loadUserData()
}

//MARK: STRING

private enum ProgressPresenterString: String {
    case entityName = "UserData"
    case imageValueKey = "image"
    case cigaretteProgressValueKey = "cigaretteProgress"
    case moneyProgressValueKey = "moneyProgress"
}

class ProgressPresenter
{
    weak private var progressViewDelegate : ProgressViewDelegate?
    
    init(delegate:ProgressViewDelegate){
        self.progressViewDelegate = delegate
    }
}

extension ProgressPresenter: ProgressStoreDelegate{
    
    func loadUserData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ProgressPresenterString.entityName.rawValue)
        request.returnsObjectsAsFaults = false
        
        var data:UserData!
        
        switch (try? context.fetch(request) as? [NSManagedObject])?.first {
        case (let result?):
            if let image = result.value(forKey: ProgressPresenterString.imageValueKey.rawValue) as? NSData, let moneyProgress = result.value(forKey: ProgressPresenterString.moneyProgressValueKey.rawValue) as? NSProgressData, let cigaretteProgress = result.value(forKey: ProgressPresenterString.cigaretteProgressValueKey.rawValue) as? NSProgressData {
                data = UserData(image: image, moneyProgress: moneyProgress, cigaretteProgress: cigaretteProgress)
            }else{
                fallthrough
            }
        default:
            data = UserData(image: nil, moneyProgress: NSProgressData(bank: 0, count: [Int](repeating: 0, count: 7), norm: [Int](repeating: 0, count: 7)), cigaretteProgress: NSProgressData(bank: 0, count: [Int](repeating: 0, count: 7), norm: [Int](repeating: 0, count: 7)))
        }
        
        progressViewDelegate?.showUserData(data)
    }
    
    func saveUserData(_ data: UserData) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ProgressPresenterString.entityName.rawValue)
        request.returnsObjectsAsFaults = false
        
    
        switch (try? context.fetch(request) as? [NSManagedObject])?.first {
        case (let result?):
            result.setValue(data.image, forKey: ProgressPresenterString.imageValueKey.rawValue)
            result.setValue(data.moneyProgress, forKey: ProgressPresenterString.moneyProgressValueKey.rawValue)
            result.setValue(data.cigaretteProgress, forKey: ProgressPresenterString.cigaretteProgressValueKey.rawValue)
        default:
            let entity = NSEntityDescription.entity(forEntityName: ProgressPresenterString.entityName.rawValue, in: context)
            let userData = NSManagedObject(entity: entity!, insertInto: context)
            
            userData.setValue(data.image, forKey: ProgressPresenterString.imageValueKey.rawValue)
            userData.setValue(data.moneyProgress, forKey: ProgressPresenterString.moneyProgressValueKey.rawValue)
            userData.setValue(data.cigaretteProgress, forKey: ProgressPresenterString.cigaretteProgressValueKey.rawValue)
        }
   
      
        appDelegate.saveContext()
       
    }
}

