//
//  MainViewController.swift
//  We The Speakers
//
//  Created by Shreeniket Bendre on 10/17/20.
//  Copyright © 2020 Shreeniket Bendre. All rights reserved.
//

import UIKit
import SideMenu

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var expandedIndexSet : IndexSet = []
    
    var titleImage = ["Know your audience.","Rehearse, rehearse, rehearse.","Practice with distractions.", "Find a style that works for you.","Know the environment.","Test all equipment.","Practice in front of a mirror.","Take every opportunity to speak.","Practice body language and movement.","Slow down."]
    var avatars = ["1", "2", "3","4","5","6","7","8","9","10"]
    var messages = ["If you are speaking in front of an audience, there is usually a reason. Know who you are speaking to and what they want or need to take away. If it's friends and family, entertain them. If it's a corporate event, teach and inspire them. Knowing the demographic of the audience is imperative."
        ,"Nothing becomes muscle memory unless you practice relentlessly. If you have a big speech coming up, make time every day to practice. Prepare your goals and the content well ahead of time. This can be done while driving, exercising, in the car, on a plane...anywhere."
        ,"Once I know the content, I like to add a little bit of distraction to test how well prepared I really am. Turn on the TV or rehearse while pushing your child in the swing. Anything that adds a little more challenge."
        , "Different events will often require a different approach or style. Sometimes reading a prepared speech is fine. But know it backward are forward so you're not staring down at the pages the whole time. Some use notes. Others prefer to be 100 percent scripted and memorized. If that's your style, memorize the content so well that you can go off script if needed -- and so you don't sound like you're reciting a poem. Use the proper approach for the appropriate event."
        ,"Know the venue where you will be speaking. Get there well ahead of time. Walk the room. Walk the stage. Get a feel for the vibe of the environment so you are more comfortable when its go time."
        ,"Nothing sucks more that last-minute technical difficulties. Avoid adding even more stress by testing any and all equipment and audio visual functions ahead of time. And have backups."
        ,"Practicing in front of a mirror is a good way to learn the proper amount of body motion, hand usage and facial expressions."
        ,"The only way to get better at anything is to do it all the time. Rehearsing is good, but nothing compares to actually getting up in front of an audience and doing it for real."
        ,"Remember, communication is much more about tone and body language than the words we say. The words of course matter, but emphasis comes with movement and body language."
        ,"There are some great sayings in the SEAL teams: slow is smooth, and smooth is fast,  and don't run to your death. Nothing shows nerves more than racing through your presentation. If you want to impact the audience in a meaningful way, make sure they actually hear what you are saying. Slow it down."]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 280.0
    }
    
}

extension MainViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? VariableTableViewCell else {
            print("failed to get cell")
            return UITableViewCell()
        }
        
        cell.titleImage.text = titleImage[indexPath.row]
        cell.avatarImageView.image = UIImage(named: avatars[indexPath.row])
        cell.messageLabel.text = messages[indexPath.row]
        cell.selectionStyle = .none
        
        if expandedIndexSet.contains(indexPath.row) {
            cell.messageLabel.numberOfLines = 0
        } else {
            cell.messageLabel.numberOfLines = 3
        }
        
        return cell
    }
}

extension MainViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(expandedIndexSet.contains(indexPath.row)){
            expandedIndexSet.remove(indexPath.row)
        } else {
            expandedIndexSet.insert(indexPath.row)
        }

        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
