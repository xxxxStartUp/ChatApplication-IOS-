//
//  Git.swift
//  ChatApp
//
//  Created by Ebuka Egbunam on 6/17/20.
//  Copyright © 2020 Daramfon Akpan. All rights reserved.
//

//Steps to starting a new feature
//Eg = example
//
//1. Clone the repository (if you advent already) - git clone <link>
//2. Pull the current updates from online -> git pull origin master
//3. Change branch to development (this branch will never have the .xcworkspace or pods folder and will also never run because of this) -> git checkout development
//4. Pull current changes -> git pull origin development
//5. Create new branch git branch <branch name>
//6. Check to make sure you are still in development , it should highlight development with an astherics on it -> git branch
//7. Create a new branch for your new feature -> eg git branch ebuka-FireUserClass
//8. Make sure you have changed anything in development by doing a -> git status . (If you have message ebuka or Dara)
//9. Checkout in your new branch ->eg  git checkout ebuka-FireUserClass
//10. Because you created the branch in development it will be the same as development. So now your new branch is the current with development and you can code



//Steps to pushing a new feature
//
//1. Follow steps to start new feature
//2. Run pod install or pod updates to get the .xcworspace and your pods because they will not be in development for consistency issues -> Pod install or Pod update
//3. Go into the .xcworkspace and make changes to the files you want to make changes too (make sure you are making changes to the right file, if you are not sure message Dara or ebuka)
//4. When you are done with your changes run git  add it to add it to  git (LOOK FOR STEPS ON HOW TO ADD FILES OR ASK EBUKA OR DARA NO MORE GIT ADD -A or GIT ADD -U)
//5. Git commit -m “your message of what you did”
//6. Git push origin <your branch name>
//7. Ebuka or Dara  will merge your commits



//: MARK Adding a File to Git
//
//1. Once you are ready to add a File
//2. Look at all the files you have modified (the once you changed or made) you will only be adding those files(if you modified the Podfile add it , I will fix the merge conflicts myself)
//3. DO NOT ADD THE FOLLOWING FILES - .xcodeproj , .xcworkspace , .DS_Store and every other files you did not make changes too(if you do there will be merge conflicts that are very difficult to fix)
//4. Run git add <filename> eg:  git add ChatApp/Model/FireService.swift(run git status to show the name of files and you can copy and paste)
//5. Commit and push


