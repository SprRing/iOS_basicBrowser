# iOS_basicBrowser

0. You may need having ‘cocoapods’ and ‘RealmSwift’ on your local. We use ‘gem’ to install ‘cocoapods’. For me, I also updated ruby to the newest version (3.0.0)

https://stackoverflow.com/questions/14202255/pod-install-bash-pod-command-not-found
ios - pod install -bash: pod: command not found - Stack Overflow

1. Click the main “iOS_Browser”, you can see many files and folders inside. Click “iOS_Browser.xcworkspace” to open Xcode. After that, you can either test or run the program.

2. For additional feature, I choose to implement the bookmark function

3. I choose to use navigation controller to implement the whole browser, that can make the tab and bookmark work like a real browser. And I chose to use a “canvas” then add a “webview” as a subview, but not only put a “webview” onto our controller. These two ways are alike, but they act differently when we need to store “webviews” when using tabs. Other functions, like tabs and bookmarks, would act like a normal and common browser. I also want to provide some basic TODOs for my project.
TODO:
(a) need a basic homepage to show when we open a new tab or even when we open the browser. For now, it use the cache to read the last website we went.
(b) We cannot remove the only tab right now. This is also why we need a basic homepage.
