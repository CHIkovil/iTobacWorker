//
//  ProgressModels.swift
//  iTobacWorker
//
//  Created by Nikolas on 07.12.2021.
//

import Foundation

enum ProgressModels
{
    struct UserData {
        let image: NSData?
        let moneyProgress: NSProgressData
        let cigaretteProgress: NSProgressData
        let dates: [String]
    }
    
    struct GraphData {
        var setup: GraphSetup
        let progress: ProgressType
    }
    
    enum ProgressType {
        case money
        case cigarette
    }
}

class NSProgressData: NSObject, NSCoding {
    let bank: Int
    let count: [Int]
    let norm: [Int]
    
    init(bank: Int, count: [Int], norm: [Int]) {
        self.bank = bank
        self.count = count
        self.norm = norm
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(bank, forKey: "bank")
        coder.encode(count, forKey: "count")
        coder.encode(norm, forKey: "norm")
    }
    
    required init?(coder: NSCoder) {
        self.bank = coder.decodeObject(forKey: "bank") as! Int
        self.count = coder.decodeObject(forKey: "count") as! [Int]
        self.norm = coder.decodeObject(forKey: "norm") as! [Int]
    }
}

typealias UserData = ProgressModels.UserData
typealias ProgressType = ProgressModels.ProgressType
typealias GraphData = ProgressModels.GraphData
