# Box-Designer
This is a box designer that is designed to be used with a Glowforge laser-cutter (model: Basic).

### Versions

* v0.2.0 : ??
* v0.1.0 : 6/22/2020

### Usage

The designer has 3 key tool sections: Dimensions, Joining, and Miscellaneous. The dimensions has four inputs and two option. You can change the length, width, height, and material thickness. Additionally, there is the option to change if these dimensions refer to the outside or inside of the box. The sides of the boxes can be joined differently, either through tabs or simple overlapping. The number of tabs can also be adjusted. In the Miscellaneous section, there are options to take the lid on and off as well as add or remove internal dividers.

### Copyright
Copyright © 2020 Hildreth Research Group. All rights reserved.

### Settings
Units can be changed though Format > Units or in the GUI "Dimensions" section.
Color blind color options are also available under Format > Color Change.
Low Vision windows with larger text to adjust the settings are available under View > Low Vision.
Additionally, CTRL + D will open the dimensions window, CTRL + J will open the Joining window, and CTRL + M will open the Miscellaneous window.

### Box-Designer Minimum System Requirements

* OS: macOS Catalina 10.15.6
* Processor: Intel Core i3 560 @ 3.3 GHz or AMD Phenom II X4 945 @ 3.0 GHz
* Memory: 50 MB of RAM
* Graphics: Intel HD Graphics 5300 1536 MB
* Network: None
* Storage: 1 MB Available Space
* Sound Card: None

### Box-Designer Recommended System Requirements

* OS: macOS Catalina 10.15.6
* Processor: Intel Core i3 560 @ 3.3 GHz or AMD Phenom II X4 945 @ 3.0 GHz
* Memory: 100 MB of RAM
* Graphics: Intel HD Graphics 5300 1536 MB
* Network: None
* Storage: 2 MB Available Space
* Sound Card: None

### Notes

* The Apple Markdown syntax is used to document this project. The HTML rendering of the documentation is created using jazzy. To get jazzy on macOS:
* [sudo] gem install jazzy
* If you run "jazzy --min-acl private" in your root project folder from the command line and you have issues with xcodebuild, try:
* jazzy --build-tool-arguments CODE_SIGN_IDENTITY=,CODE_SIGNING_REQUIRED=NO,CODE_SIGNING_ALLOWED=NO --min-acl private
* The jazzy-generated documentation is published at https://hildrethresearchgroup.github.io/Box-Designer/ (HildrethResearchGroup's GitHub Pages URL)
