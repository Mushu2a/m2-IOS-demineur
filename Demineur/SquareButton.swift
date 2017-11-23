//
//  SquareButton.swift
//  Demineur
//
//  Created by Jeremie Elbaz on 23/11/2017.
//  Copyright © 2017 Jeremie Elbaz. All rights reserved.
//

import Foundation
import UIKit

class SquareButton : UIButton {
    
    //MARK: Variables
    var row:Int = 0
    var col:Int = 0
    var isRevealed:Bool = false
    var hasBomb:Bool = false
    var nearBombsCount:Int = 0
    var flag:Bool = false
    
    func setButtonRevealed () {
        self.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.isRevealed = true
        self.setImage(nil, for: .normal)
        if (self.hasBomb) {
            // Si c'est une bombe
            self.setImage(UIImage(named: "mine.jpeg"), for: .normal)
        } else {
            // Sinon
            if (self.nearBombsCount == 0) {
                self.setTitle("", for: .normal)

            } else {
                self.setTitle(String(self.nearBombsCount), for: .normal)

            }
            switch self.nearBombsCount {
            case 1 :
                self.setTitleColor(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), for: .normal)
            case 2 :
                self.setTitleColor(#colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), for: .normal)
            case 3 :
                self.setTitleColor(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), for: .normal)
            case 4..<9:
                self.setTitleColor(#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), for: .normal)
            default:
                break
            }
        }
    }
    
    func drawFlag() {
        self.flag = !self.flag
        if (self.flag) {
             self.setImage(UIImage(named: "flag.png"), for: .normal)
        } else {
            self.setImage(nil, for: .normal)
        }
    }
    
    func setButtonUnRevealed() {
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.isRevealed = false
        self.setImage(nil, for: .normal)
        self.setTitle("", for: .normal)
    }
    
    //MARK: Accessor
    func getRow() -> Int {
        return self.row
    }
    
    func setRow(row: Int) {
        self.row = row
    }
    
    func getCol() -> Int {
        return self.col
    }
    
    func setCol(col: Int) {
        self.col = col
    }
    
    func getHasBomb() -> Bool {
        return self.hasBomb
    }
    
    func setHasBomb(hasBomb: Bool)  {
        self.hasBomb = hasBomb
    }
    
    func getNearBombsCount() -> Int {
        return self.nearBombsCount
    }
    
    func setNearBombsCount(nearBombsCount: Int) {
        self.nearBombsCount = nearBombsCount
    }
}
