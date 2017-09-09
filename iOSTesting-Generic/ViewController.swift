//
//  ViewController.swift
//  iOSTesting-Generic
//
//  Created by Olivier Butler on 07/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit

class ToeButton:UIButton{
    var pressedBy:Int
    
    func setCol(){
        let newColor: UIColor
        switch pressedBy{
        case 1:
            newColor = UIColor.orange
        case 2:
            newColor = UIColor.purple
        default:
            newColor = UIColor.black
        }
        self.backgroundColor = newColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.pressedBy = 0
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.width/6
        self.setTitleColor(UIColor.clear, for: .normal)
    }
}

class ViewController: UIViewController {
    var currentPlayer: Int = 0
    var gameOver: Bool = false
    var isDraw: Bool = false
    var countTurns:Int = 0
    @IBOutlet var buttonGroup: [ToeButton]!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var whoWonLabel: UILabel!
    
    func changePlayer(){
        let newPlayer: Int
        switch self.currentPlayer{
        case 1:
            newPlayer = 2
            titleLabel.textColor = UIColor.purple
            titleLabel.text = "Go Go Purple Ranger!"
        default:
            newPlayer = 1
            titleLabel.textColor = UIColor.orange
            titleLabel.text = "Go Go Orange Ranger!"
        }
        self.currentPlayer = newPlayer
    }
    
    func isItOver() -> Bool{
        for tag in 0..<buttonGroup.count{
            if buttonGroup[tag].pressedBy == currentPlayer{
                if tag == 0 || tag == 3 || tag == 6{
                    let test1 = buttonGroup[tag+1].pressedBy == currentPlayer
                    let test2 = buttonGroup[tag+2].pressedBy == currentPlayer
                    if test1 && test2 {
                        print ("Horizontal victory at \(tag)")
                        print (
                            buttonGroup[tag].pressedBy,
                            buttonGroup[tag+1].pressedBy,
                            buttonGroup[tag+2].pressedBy
                        )
                        return true
                    }
                }
                if tag == 0 || tag == 1 || tag == 2{
                    let test3 = buttonGroup[tag+3].pressedBy == currentPlayer
                    let test4 = buttonGroup[tag+6].pressedBy == currentPlayer
                    if test3 && test4 {
                        print ("Vertical victory at \(tag)")
                        return true
                    }
                }
                if tag == 0 || tag == 2{
                    let test5 = buttonGroup[4].pressedBy == currentPlayer
                    let test6 = buttonGroup[6+(2-tag)].pressedBy == currentPlayer
                    if test5 && test6 {
                        print ("Diagonal victory at \(tag)")
                        return true
                    }
                }
            }
        }
        if self.countTurns > 8 {
            self.isDraw = true
            return true
        }
        return false
    }
    
    func endGame(){
        titleLabel.textColor = UIColor.clear
        titleLabel.text = "Game Over"
        self.gameOver = true
        if self.isDraw {
           whoWonLabel.text = "You both suck..."
        } else {
            let victor = self.currentPlayer == 1 ? "Orange" : "Purple"
            whoWonLabel.text = "\(victor) Ranger's da Boss!"
        }
    }
    
    
    @IBAction func resetPressed(_ sender: UIButton) {
        for button in buttonGroup{
            button.pressedBy = 0
            button.setCol()
        }
        
        if gameOver {
            whoWonLabel.text = "Who da Boss?"
            titleLabel.textColor = UIColor.black
            self.gameOver = false
            self.isDraw = false
            self.countTurns = 0
        }
        
        changePlayer()
    }
    
    @IBAction func buttonPressed(_ sender: ToeButton) {
        if (sender.pressedBy == 0) && !self.gameOver {
            self.countTurns += 1
            sender.pressedBy = currentPlayer
            sender.setCol()
            if isItOver() {
                endGame()
            } else {
                changePlayer()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonGroup.sort{
            $0.tag < $1.tag
        }
        changePlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

