//
//  ChildInterViewController.swift
//  BlueStackDemoDev
//
//  Created by MedSghaier on 6/9/2022.
//

import UIKit

class ChildInterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var fruit = Fruit(type: "Apple")
        fruit.convertToBanana()
        print(fruit.type)
        
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func turnTo(direction :Direction){
        if let color = UserDefaults.standard.string(forKey: "okok") {
            print(color)
        }
        
        guard let testColor = UserDefaults.standard.string(forKey: "okok") else {
            return
        }
        
        print(testColor)
        
        switch direction {
        case .North:
            print ("north")
            break
        case .East:
            print ("East")
            break
        case .South:
            print ("South")
            break
        case .West:
            print ("West")
            break
        }
        
        var a = 10
        var b = 20
        
        b = b + a  // 10 + 20 = 30
        a = b - a // 30 - 10  = 20
        b = b - a // 30  - 20  =10
        
    }

}


enum Direction {
    case North
    case East
    case South
    case West
}

typealias world = String



struct Fruit: Codable {
    
    var type : String
    
    init(type: String) {
        self.type = type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(String.self, forKey: .type)
    }
    
    enum CodingKeys: CodingKey {
        case type
    }
    
    
    
    mutating func convertToBanana (){
        self.type = "banana"
    }
}
