//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Ma Xueyuan on 2020/01/09.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var scoreLabel: UILabel!
    
    var countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    var score = 0
    var correctAnswer = 0
    var round = 1
    
    let totalQuestion = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 2
        button3.layer.borderWidth = 3
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        round = 1
        score = 0
        askQuestion()
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer].uppercased()
        scoreLabel.text = "Score: \(score)"
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if correctAnswer == sender.tag {
            title = "Correct"
            score += 1
            round += 1
        } else {
            title = "Wrong, that's the flag of \(countries[sender.tag].uppercased())"
            score -= 1
            round += 1
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        let continueAction = UIAlertAction(title: "Continue", style: .default) { (_) in
            if self.round <= self.totalQuestion {
                self.askQuestion()
            } else {
                self.performSegue(withIdentifier: "showFinalScore", sender: nil)
            }
        }
        ac.addAction(continueAction)
        present(ac, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFinalScore" {
            let destination = segue.destination as! FinalScoreViewController
            destination.finalScore = score
        }
    }
}

