# Cryptex

## Introduction

Please look at the screen recording below to know what the finished project should look like:

![CryptexScreenRecording](https://user-images.githubusercontent.com/16965587/57031568-3fa62480-6c05-11e9-81c3-1137e5d3660c.gif)

## Instructions

Please fork and clone this repository. This repository does not have a starter project, so create one inside of the cloned repository folder.

You will be making a cryptex app where you guess the "password" of the cryptex based on a hint given. This will make use of a `UIPickerView` to do so. There is also a timer running that will show a `UIAlertController` if the user doesn't guess the password in time. 

When tapping the unlock button, a different `UIAlertController` will appear indicating whether or not the user guessed the password correctly or not, and will give them options to keep guessing or try a new cryptex.

### Part 1 - Storyboard Setup

1. Delete the view controller scene on the storyboard and add a new `UIViewController` scene.

2. The layout of the view controller scene should have the following:

   - A label to show the hint.
   - A `UIPickerView` that acts as the cryptex.
   - A button for the user to try to "unlock" the cryptex when they think they have guessed the password correctly.
  
3. Create a Cocoa Touch subclass of `UIViewController` and call it `CryptexViewController`.

4. Set the view controller scene's subclass to `CryptexViewController`

5. Create outlets from all 3 views, and an action from the unlock button.

### Part 2 - Model Layer Setup

1. Create a new Swift file called "Cryptex.swift".

2. Create a struct called `Cryptex`. This model object should have:
   - A `password` that is the word to be guessed using the picker view
   - A `hint` that gives the user a hint as to what the password is. 
   
3. Create a new Swift file called "CryptexController.swift".

4. Create a class called `CryptexController`.

5. Create an array of `Cryptex` objects. This is going to simply have an array of hardcoded `Cryptex`es, unless you decide to add a way for the user to add more as a stretch goal. Go ahead and add two or three cryptexes to the array. Make this property private.

6. Create a property called `currentCryptex` that is of type `Cryptex?`. This is the property that the view controller will be able to see (as it is not private), and use for setting up the picker view, and running some game logic.

7. Create a function called `randomCryptex()`. This method should grab a random `Cryptex` from the `cryptexes` array and set the value of `currentCryptex` to it. As of Swift 4.2, there is a very easy way to do this. If you're unsure of what it is, refer to `Array` in the documentation.

8. We need to start the app off with a new cryptex for the user to solve. Since the `currentCryptex` is optional, it won't have a value to start with. We can call the `randomCryptex()` method in a few places to give it a value. Perhaps the cleanest way is to use the `CryptexController`'s initializer. As soon as we create an instance of `CryptexController` the initializer gets called and we can run the `randomCryptex()` method inside it. The initializer doesn't need any arguments. It should look like this:

``` Swift
init() {
    // Do whatever you need to here
}
```

### Part 3 - Wiring up the application

The rest of the work will be in the `CryptexViewController`. There is a fair amount of logic to be added in this view controller, perhaps more than you have ever done before in a single view controller. Something important to keep in mind when your code files become increasingly long and complex is to organize and keep your code clean. That means grouping similar code together; properties, outlets, methods of a protocol, etc. A few marks (// MARK: - Some group of code) can go a long way. Alternatively, you can make extensions of the view controller and separate your code that way. Do whatever makes sense for you, but please try to keep your code as clean and organized as possible.

#### Show a cryptex

1. Create a variable called `cryptexController` that is a new instance of `CryptexController`.

2. Let's get the picker view ready. We need to use the `currentCryptex` of the model controller to get the information needed to set up the picker view. Adopt the `UIPickerViewDataSource` and `UIPickerViewDelegate` protocols in the view controller's class declaration.

3. Copy and paste this array of letters into your view controller subclass. This will be used to set up the picker view's rows.

``` Swift
var letters = ["A", "B", "C", "D",
                   "E", "F", "G", "H",
                   "I", "J", "K", "L",
                   "M", "N", "O", "P",
                   "Q", "R", "S", "T",
                   "U", "V", "W", "X",
                   "Y", "Z"]
```

4. Copy and paste the following data source and delegate methods. Add the implementation for each of these using the hints provided in each comment: 

``` Swift
func numberOfComponents(in pickerView: UIPickerView) -> Int {
    // For the number of components, think about how you can figure out how many characters are in the `currentCryptex`'s password.
}

func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    // For the number of rows, we want to show as many rows as there are letters.
}

func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    // For the title of each row, we want to show the letter that corresponds to the row. i.e. row 0 should show "A", row 1 should show "B", etc.
}
```

5. Create an `updateViews()` method that takes the `currentCryptex`'s `hint` and sets the hint label's text to it. It also should reload the components of the picker view. If we don't do this, when a new random cryptex is started, the picker view won't update to show the (potentially) new number of components (e.g. "Foo" has 3 components, but "Cryptex" has 7).

6. In the `viewDidLoad()`, add the following:

    - Set the view controller as the delegate and data source of the picker view.
    - Call `updateViews()`.

At this point, you should be able to run the app and have the label show the current cryptex's hint, and picker view have the same amount of components as there are characters in the current cryptex's password.s

#### Game Logic

Now we need to add a few functions to make the game work. Namely, we need to be able to check if the password the user entered in the picker view matches the `currentCryptex`'s `password`, and (re)set the timer to let them try again.

1. Create a function called `hasMatchingPassword() -> Bool`. This method should:

    - Get the title of each row (which should be a single letter) in the picker view (try using a for-in loop) and store each one in an array.
  
    - Take the array of letters and combine them into a single string.
  
    - Check if the string matches the model controller's `currentCryptex`'s `password`, and return a Bool based on their equality. 
  
    - **NOTE:** When comparing strings, the letter "A" and "a" do not equal each other. To accurately check equality between the two strings, either make them both uppercased or lowercased, then check.
  
2. Create a `countdownTimer` property on the view controller class that is a `Timer?`.

3. Create a `reset()` method. This method should:

    - Invalidate the old timer if there is one to ensure you don't present an alert saying the user ran out of time when they actually haven't. (This will make more sense later on)
  
    - Create a new timer and set the value of `countdownTimer` to it. Use the `Timer.scheduledTimer(withTimeInterval:` convenience method to do this. Make the time interval 60 seconds. For now, add a print statement in the handler of the timer that says the timer is finished. We'll come back and add some real code to it later on.
  
    - Optionally, you can also reset the picker view's components back to "A" using the `pickerView.selectRow` method. You will have to loop through each character in the password to reset each component. This is not required, but it's a nice feature to add.

4. The `reset()` method you just made is great, but it only resets the timer for the same cryptex. Sometimes we will want to reset the timer, but also start a new cryptex as well. To do this, make a `newCryptexAndReset()` method. This method should:

    - Call the `cryptexController`'s `randomCryptex()` method.
    - Call `updateViews()` to make sure the picker view has the right number of components for the new password, and the new hint shows in the label.
    - Call `reset()` to reset the timer.

#### Alert Controllers

In the action of the unlock button, we're going to present an alert controller depending if they guessed the password or not. We need to create the methods that present those alert controllers first.

1. Create a method called `presentCorrectPasswordAlert`. This method should:

   - Set up an alert controller with a message telling the user that they have correctly guessed the password
   - Add an action to the alert controller that lets them attempt a new cryptex.
     - You've already done the work of resetting everything with a new cryptex. All you need to do is call `newCryptexAndReset()` in the handler of the action.
   - Present the alert controller.
  
2. Create another method called `presentIncorrectPasswordAlert`. This method should:
   - Set up an alert controller with a message telling the user that they have incorrectly guessed the password

   - Add an action to the alert controller that lets them continue guessing the password. This doesn't need a handler, as all we need to do is dismiss the alert controller.
  
   - Add an action to the alert controller that lets them attempt a new cryptex.
  
     - Like the previous alert method, call `newCryptexAndReset()` in the handler of this action.

   - Present the alert controller.
  
3. In the action of the unlock button, use the `hasMatchingPassword()` method to ascertain whether the user has guessed the password correctly or not, and present an alert controller using one of the two methods above depending on the boolean value returned from `hasMatchingPassword()`.

Finally, we need to add an alert controller that is presented when the timer runs out.

4. Create a method called `presentNoTimeRemainingAlert()`. This method should: 

   - Set up an alert controller telling the user that they have ran out of time to guess the password, and ask them whether they would like to reset the timer and keep guessing or try a new cryptex.
  
   - Add an action that lets them reset the timer. What method have you already made that would accomplish this without changing the cryptex?
  
   - Add an action that lets them try a new cryptex. What method have you already made that would reset the timer and change to a new cryptex?
  
   - Present the alert controller.
  
5. This `presentNoTimeRemainingAlert()` should be called in the handler of the `Timer.scheduledTimer` method call in the `reset()` method. You can get rid of the print statement if you wish.

At this point, the app should be completely functional!

## Go Further

If you have time, try to implement these extra features:

- Add a button that lets the user add more cryptexes. You could do this using a new view controller, or even a `UIAlertController` with two text fields in it.
- Persist the user-created cryptexes using `FileManager` and `PropertyListEncoder`/`Decoder`.
- Let the user choose how long the timer is.
