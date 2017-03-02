//
//  ViewController.swift
//  URLImageExample
//
//  Created by Wayne Yeh on 2017/2/22.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let imageView = cell.viewWithTag(10) as? UIImageView
        imageView?.urlImage
            .local(image: "user")
            .remote(url: "https://upload.wikimedia.org/wikipedia/commons/d/d6/Gemeente_Nieuwer-Amstel,_foto_1_Jacob_Olie_(max_res).jpg")
            .show()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height
    }
}

