//
//  LoginViewController.swift
//  smarthome
//
//  Created by lo r t on 2018/11/7.
//  Copyright © 2018年 jifan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func BtnLoginClick(_ sender: Any, forEvent event: UIEvent) {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "MainStoryboard") as! UITabBarController;
        self.present(viewController, animated: true, completion: nil);
    }
    @IBAction func BtnRegisterClick(_ sender: Any) {
        
    }
    @IBOutlet weak var BtnLogin: UIButton!
    @IBOutlet weak var BtnRegister: UIButton!
}
