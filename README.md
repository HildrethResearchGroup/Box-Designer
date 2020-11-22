# Box-Designer
This is a box designer that is designed to be used with a Glowforge laser-cutter (model: Basic).

### Versions

* v0.3.0 : ????
* v0.2.0 : 9/26/2020
* v0.1.0 : 6/22/2020

### Usage

The designer has three key tool sections: Dimensions, Joining, and Add Components. The Dimensions panel has four inputs and two options. You can change the length, width, height, and material thickness of the box. Additionally, there is the option to change if these dimensions refer to the outside or inside of the box, along with the option to change the displayed units between inches and millimeters. The sides of the boxes can be joined differently, either through tabs, simple overlapping, or slots. The number of tabs can also be adjusted, when the "Tab" segment is selected. In the Add Components section, there are options to choose whether the wall to be added is internal or external, the plane it should be oriented on, and where it should be placed.

### Copyright
Copyright © 2020 Hildreth Research Group. All rights reserved.

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

* Apple Markdown syntax is used to document this project. The HTML rendering of the documentation is created using jazzy. To get jazzy on macOS:
* [sudo] gem install jazzy
* If you run "jazzy --min-acl private" in your root project folder from the command line and you have issues with xcodebuild, try:
* jazzy --build-tool-arguments CODE_SIGN_IDENTITY=,CODE_SIGNING_REQUIRED=NO,CODE_SIGNING_ALLOWED=NO --min-acl private
* The jazzy-generated documentation is published at https://hildrethresearchgroup.github.io/Box-Designer/ (HildrethResearchGroup's GitHub Pages URL); there is a WorkFlow set up in GitHub so that our GitHubPages is updated any time someone pushes to the master branch.
