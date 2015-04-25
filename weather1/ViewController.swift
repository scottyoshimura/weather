//
//  ViewController.swift
//  weather1
//
//  Created by Scott Yoshimura on 4/5/15.
//  Copyright (c) 2015 west coast dev. All rights reserved.
////
// a simple weather app. still need to create error messages for when the user enters a city that is not available.

import UIKit

class ViewController: UIViewController {

    

    //let's setup a method that will close the keyboard when a user selects return.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //let's send a message that says the First Responder is the keyboard when it is used.
        textField.resignFirstResponder()
        return true
        //this function will close any text field when return is selected
        
    }
    
    //let's setup a method that will close the keyboard anytime a user touches out of the text box.
    //we do this by using self (referring to the view controller), the view to refer to the view within the view controller,
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        //this closes the keyboard
    }
    

    //this is the function to show that there is an error in the text input
    func showError () {
        lblResult.text = "was not able to find weather for " + userCity.text + "please try again"
    }
    
    //outlet for the Text Field
    @IBOutlet weak var userCity: UITextField!

    
    //outlet for the button
    @IBAction func btnGetWeather(sender: AnyObject) {
        //lets start with downloading the weather and extracting information.
        //we create the url with NSURL from a string.
        var url = NSURL(string: "http://www.weather-forecast.com/locations/" + userCity.text.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        //becuase we are forcing url in the lower code with an exclamation, we want to check to make sure it is there. why would it be nil? if the user leaves the city text box or some strange code, it will crash. whenever you use an ! to force unrwap, check to make sure it exists. whenever you have user input, they can always enter something that can make it crash.
        if url != nil{
            //let's create a taslk. it is a NSURL shared session. we want to force url! to exist. *anytime we use a !, we want to check that it actually exists.  // the three variables we want are data, response, error.
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                // we want to set up a flag to note that there is an error.
                var urlError = false
                var weather = ""
                //let's start by checking if there is an error. if there is not an error, continue. if error is nil, that means that we got something inside of the data variable.
                if error == nil{
                    //we first need to convert hte url to a string so that we can work with it. we create an NSString from some data, from the data variable, encoded in NSUTF8
                    var urlContent = NSString(data: data, encoding: NSUTF8StringEncoding) as NSString!
                    //let's start by focusing on the bit of text that is before the content that I want. it appears many times, but  the first time is what we want. we can use this as a bit of a key to find what we want.  //let's create a urlContentArray from url content by seperating by the key string. don't forget to escape the characters.
                    var urlContentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                    //let's check to make sure urlContentArray works. it should be greater than count of 0
                    if urlContentArray.count > 0 {
                        //let's go deeper and create a weatherArray, starts from urlContentArray[1], and then seperate by the span closure.
                        var weatherArray = urlContentArray[1].componentsSeparatedByString("</span>")
                        //we now have an array with 0 being what we want.
                        //let's set weather as that 0 array value, and specify it that we want it to be a string.
                        weather = weatherArray[0] as! String
                        //let's replace some of the html code with human readable strings.
                        weather = weather.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                    //if urlContentArray has no count, we set the error
                    } else {urlError = true}
                }
                else{
                    urlError = true
                }
                
        //we want to use dispatch asynch is that we want to show the weather or error
                dispatch_async(dispatch_get_main_queue()){
                    println(weather)
                    
        //check to see if there is an error, and if not, show me the weather. this will kick off when the information is available, and not wait for the cue to complete
        if urlError == true {
            self.showError()}
            else {self.lblResult.text = weather}
                }
                }
            )
            task.resume()
        }
        else {println("tesst")}
    }
    
    //outlet for the label result
    @IBOutlet weak var lblResult: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

