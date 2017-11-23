//
//  ViewController.swift
//  Demineur
//
//  Created by Jeremie Elbaz on 23/11/2017.
//  Copyright © 2017 Jeremie Elbaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var squares:[[SquareButton]] = []
    var boardView:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.boardView = UIView(frame: CGRect(x: 0, y: 20, width: 300, height: 300))
        self.view = boardView
        for i in 0..<10 {
            var lines:[SquareButton] = []
            for j in 0..<10 {
                let button = SquareButton(frame: CGRect(x: (i == 0) ? i : i*30 , y: (j == 0) ? j+20 : (j*30)+20, width: 30, height: 30))
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
                button.setRow(row: i)
                button.setCol(col: j)
                button.addTarget(self, action: #selector(buttonWasPressed), for: .touchUpInside)
                button.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(drawFlag)))
                self.boardView.addSubview(button)
                lines.append(button)
            }
            squares.append(lines)
        }
        self.resetBoard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func buttonWasPressed (sender: SquareButton) {
        reveal(row: sender.getRow(), col: sender.getCol())
        let nb = gameResult()
        if( nb == 1) {
            let alert = UIAlertController(title: "GAGNE !", message: "You are the boss", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Rejouer", style: UIAlertActionStyle.default, handler: replay))
            self.present(alert, animated: true, completion: nil)
        } else if(nb == 0) {
            let alert = UIAlertController(title: "Perdu !", message: "Bouuuuuh", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Rejouer", style: UIAlertActionStyle.default, handler: replay))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func replay(alertAction: UIAlertAction) {
        self.resetBoard()
    }
    
    func resetBoard () {
        for i in 0..<10 {
            for j in 0..<10 {
                self.squares[i][j].setButtonUnRevealed()
                self.squares[i][j].setHasBomb(hasBomb: false)
                if (arc4random_uniform(100) <= 10) {
                    self.squares[i][j].setHasBomb(hasBomb: true)
                }
            }
        }
        for i in 0..<10 {
            for j in 0..<10 {
                self.squares[i][j].setNearBombsCount(nearBombsCount: self.getNearBombsCount(ligne: i, colonne: j))
            }
        }
    }
    
    @objc func drawFlag (sender : UIGestureRecognizer) {
        if(sender.state == .ended) {
            let button = sender.view as! SquareButton
            button.drawFlag()
        }
    }
    
    func gameResult() -> Int {
        var nbBomb:Int = 0
        var nbReveal:Int = 0
        for i in 0..<10 {
            for j in 0..<10 {
                if (self.squares[i][j].getHasBomb() && self.squares[i][j].isRevealed) {
                    return 0
                } else {
                    if (self.squares[i][j].getHasBomb()) {
                        nbBomb = nbBomb + 1
                    }
                    if (self.squares[i][j].isRevealed) {
                        nbReveal = nbReveal + 1
                    }
                }
            }
        }
        if (nbBomb + nbReveal == 100) {
            return 1
        } else {
            return 2
        }
    }
    
    
    func reveal(row: Int, col: Int) {
        let button = self.squares[row][col]
        button.setButtonRevealed()
        if (button.getNearBombsCount() == 0) {
            for i in 0..<8 {
                switch i {
                case 0:
                    // En haut a gauche
                    if (row - 1 >= 0 && col - 1 >= 0) {
                        if (squares[row-1][col-1].getNearBombsCount() == 0 && !squares[row-1][col-1].isRevealed) {
                            reveal(row: row-1, col: col-1)
                        }
                    }
                case 1:
                    // En haut
                    if (row - 1 >= 0) {
                        if (squares[row-1][col].getNearBombsCount() == 0 && !squares[row-1][col].isRevealed) {
                            reveal(row: row-1, col: col)
                        }
                    }
                case 2:
                    // En haut a droite
                    if (row - 1 >= 0 && col + 1 < 10) {
                        if (squares[row-1][col+1].getNearBombsCount() == 0 && !squares[row-1][col+1].isRevealed) {
                            reveal(row: row-1, col: col+1)
                        }
                    }
                case 3:
                    // a droite
                    if (col + 1 < 10) {
                        if (squares[row][col+1].getNearBombsCount() == 0 && !squares[row][col+1].isRevealed) {
                            reveal(row: row, col: col+1)
                        }
                    }
                case 4:
                    // en Bas a droite
                    if (row + 1 < 10 && col + 1 < 10) {
                        if (squares[row+1][col+1].getNearBombsCount() == 0 && !squares[row+1][col+1].isRevealed) {
                            reveal(row: row+1, col: col+1)
                        }
                    }
                case 5:
                    // En bas
                    if (row + 1 < 10) {
                        if (squares[row+1][col].getNearBombsCount() == 0 && !squares[row+1][col].isRevealed) {
                        }
                    }
                // En bas a gauche
                case 6:
                    if (row + 1 < 10  && col - 1 >= 0) {
                        if (squares[row+1][col-1].getNearBombsCount() == 0 && !squares[row+1][col-1].isRevealed) {
                            reveal(row: row+1, col: col-1)
                        }
                    }
                case 7:
                    // A gauche
                    if (col - 1 >= 0) {
                        if (squares[row][col-1].getNearBombsCount() == 0 && !squares[row][col-1].isRevealed) {
                            reveal(row: row, col: col-1)
                        }
                    }
                default:
                    break
                }
            }
        }
    }
    
    func getNearBombsCount(ligne: Int, colonne: Int) -> Int {
        var count:Int = 0
        for i in 0..<8 {
            switch i {
            case 0:
                // En haut a gauche
                if (ligne - 1 >= 0 && colonne - 1 >= 0) {
                    if (squares[ligne-1][colonne-1].getHasBomb()) {
                        count = count+1
                    }
                }
            case 1:
                // En haut
                if (ligne - 1 >= 0) {
                    if (squares[ligne-1][colonne].getHasBomb()) {
                        count = count+1
                    }
                }
            case 2:
                // En haut a droite
                if (ligne - 1 >= 0 && colonne + 1 < 10) {
                    if (squares[ligne-1][colonne+1].getHasBomb()) {
                        count = count+1
                    }
                }
            case 3:
                // a droite
                if (colonne + 1 < 10) {
                    if (squares[ligne][colonne+1].getHasBomb()) {
                        count = count+1
                    }
                }
            case 4:
                // en Bas a droite
                if (ligne + 1 < 10 && colonne + 1 < 10) {
                    if (squares[ligne+1][colonne+1].getHasBomb()) {
                        count = count+1
                    }
                }
            case 5:
                // En bas
                if (ligne + 1 < 10) {
                    if (squares[ligne+1][colonne].getHasBomb()) {
                        count = count+1
                    }
                }
                // En bas a gauche
            case 6:
                if (ligne + 1 < 10  && colonne - 1 >= 0) {
                    if (squares[ligne+1][colonne-1].getHasBomb()) {
                        count = count+1
                    }
                }
            case 7:
                // A gauche
                if (colonne - 1 >= 0) {
                    if (squares[ligne][colonne-1].getHasBomb()) {
                        count = count+1

                    }
                }
            default:
                break
            }
        }
        return count
    }


}

