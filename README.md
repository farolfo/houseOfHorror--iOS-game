![alt text](/Coco2DSimpleGame/houseOfHorror.png "House of Horror")
=======================

iOS game developed with `cocos2d` for the iOS development subject at ITBA

![alt text](/Coco2DSimpleGame/Resources/screenshots/screenshot1.png "screen1")

###Build me

Clone the project and open it in your `Xcode`.

We are using the 2.1 beta version of `cocos2d`, so download it [here](http://www.cocos2d-iphone.org/cocos2d-iphone-v2-1-beta-released/) and drag the `cocos2d-ios.xcodeproj` file to the root of the project in the `Xcode`.
Click play and ready to play !

###Rules

You have to go thorugh three levels, beating ghosts in a haunted house.

To be able to go to the other level, you have to reach an amount of 100 points in score. By beating a ghost you get as many points as the 'combo' says.
The combo starts at 1 and will increasse in each ghost you beat.

If any ghost makes it to the other side of the screen, you will lose one life and get the combo reseted to 1. Be aware ! If you throw a projectile that doesn't beat anything, you will get one life less and the combo in 1 too.

But we want to help you ! You will see hearts flying over there... beat them ! You wll get a new life more. Also you may see guns flying, this will make your projectiles bigger so you can beat ghosts easely.

Be aware ! If you lose a projectile or a ghost makes it to the other side of the screen, you will be reseted to regular projectiles again.

Once you get to the third level and get 100 points in score, you will see the boss ! Beat it with 5 projectiles to kill it and you'll win !

###Features

* Implementation of levels.
* Three types of ghosts.
* One boss.
* Usage of particles.
* Usage of animations using a spritesheet (in the boss and the regular ghost).
* Combo to increasse your scores.
* 2 types of guns.
* Cheat mode implemented.

TODO ->
* Particles
* que si ganas o perdes se te rediriga al home page

###Some screenshots

![alt text](/Coco2DSimpleGame/Resources/screenshots/screenshot2.png "screen2")
![alt text](/Coco2DSimpleGame/Resources/screenshots/screenshot3.png "screen3")
![alt text](/Coco2DSimpleGame/Resources/screenshots/screenshot4.png "screen4")
![alt text](/Coco2DSimpleGame/Resources/screenshots/screenshot5.png "screen5")
![alt text](/Coco2DSimpleGame/Resources/screenshots/screenshot6.png "screen6")
![alt text](/Coco2DSimpleGame/Resources/screenshots/screenshot7.png "screen7")
