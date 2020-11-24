# Box Designer User Guide

This document explains the camera and panel controls for the Box Designer macOS application.



# Camera Controls



### Mouse Camera Controls

* Zooming: The scroll bar zooms in and out.

* Translation: Right-clck-and-drag moves the box around the view.

* Rotation: The page-back or page-forward buttons on the (typically) left side of the mouse rotate the box.

* Selection: A single left-click on a wall highlights that wall.

* Focus: A double left-click on a wall focuses the camera only on that wall (for drawing cutouts).

* Abort Focus: The escape key gets the user out of “focus mode” and enables the user to highlight walls again.

* Abort Selection: The escape key will also abort selection mode — if a wall is highlighted, the escape key will return the box to an un-highlighted state.



### Touchpad Camera Controls

* Zooming: Similar to iPhones, use two fingers and pinch inward to zoom out, or pinch inward to zoom in.

* Translation: Using two fingers, drag the box around the view (no pinching).

* Rotation: Similar to iPhones, using two fingers, move in circular motion to rotate the box.

* Selection: One-finger single click selects a wall to highlight it.

* Focus: One-finger double click focuses the camera on the double-clicked wall (for drawing cutouts and adding text).

* Abort Focus: The escape key gets the user out of “focus mode” and enables the user to highlight walls again.

* Abort Selection: The escape key will also abort selection mode — if a wall is highlighted, the escape key will return the box to an un-highlighted state.


### Cutout Controls
* To cut out shapes, the wall must be in focus mode (double-clicking on the desired wall).
* After the wall is in focus mode, click once and move the mouse around to see the projected shape to cut out (this will be viewed as a pink overlayed shape on the wall). The '['' key filters through the allowed shapes (circle, rectangle, and rounded rectangle) backwards, while the ']' filters through the shapes forward. For rounded rectangles, the "rounded radius" can be changed by using the '+' and '-' keys. If the starting click was not where the user wanted the shape, press 'Esc' once to remove it from the view, and click in the new spot to start drawing again. If the pink shape looks like the desired cutout, click once more where the cursor currently is to cut out the shape on the wall. To be able to select walls again, press the 'Esc' key twice. The user will know they are in "Selection" mode again when the "Selected wall: " output reads "None" in the panel area. Final note: as of now, if the user wants to draw two shapes on the same wall, they must get out of Drawing and Focus mode (double-press 'Esc' key), and then re-focus on that wall. This is a bug that we have yet to find the issue for. Technically, the user can still cut-out a second shape in the same "Focus" session, but the second cut-out does not highlight where/what the shape looks like -- it just cuts it out after two clicks.

# Application Menu:



### File

* Open: This options allows users to load a previously-saved box template into the application. As of now, this is only allowed for JSON files.

* Save: This options allows users to save their current box template as a PDF or JSON file, at the path destination of their choosing. The user can also use the “Export” button in the GUI.

* Close: This option closes the Box Designer application.



### Format

* Units: This option allows users to change the displayed units from the menu; it is also an option in the GUI.

* Color Change: This option is not enabled right now. The current shading and colors comply with WCAG.



### View

* Enter Full Screen: This option allows user to expand the application to fit the whole screen. As of now, the panels at the bottom do not adjust. Press escape to exit full screen mode.

* Low Vision: This option is not enabled right now.



### Window:

* Minimize: This option allows users to minimize the application and store it on the Dock.

* Zoom: This option allows users to maximize the area of the application in the screen, without going to full screen.

* Tile Window to Left of Screen: This option allows users to split their screen into two sections, with the Box Designer application on the left section.

* Tile Window to Right of Screen: his option allows users to split their screen into two sections, with the Box Designer application on the right section.

* Bring All to Front: This option allows users to bring any open sessions to the front of the screen — in front of any other applications that are open.



### Help

* Hopefully, this taskbar item will hold the user guide and enable Spotlight Searching for specific topics in the user guide.



# Panel Menu



### Dimensions

* Length: This textfield takes input from the user, specifying their desired length of the box. The length is the dimension along the local coordinate system’s z-axis.

* Width: This textfield takes input from the user, specifying their desired width of the box. The width is the dimension along the local coordinate system’s x-axis.

* Height: This textfield takes input from the user, specifying their desired height of the box. The height is the dimension along the local coordinate system’s y-axis.

* Material Thickness: This textfield takes input from the user, specifying their desired material thickness of the box. It is important this variable matches the material thickness that will be cut, otherwise the box will not fit together correctly.

* Dimensions: This option allows user to choose whether the length, width, and height dimensions they input refer to the space between the inner sides of the walls, or the total dimensions of the box (including the walls). If the inner option is selected, the true dimensions of the box will be the dimensions that are in the text fields, along with 2*(Material Thickness).

* Units: This option allows the user to choose inches or millimeters as the displayed unit in the application. This can also be changed in Menu Taskbar -> Format -> Units.



### Joining

* Join Type: This option allows users to choose whether the walls are joined via overlap, tab, or slot style. Overlapping and tab joins require adhesive for the box to stay together, while the slot join has an interlocking nature that does not require adhesive.

* Number of Tabs: If the user selects the Tab join style, they can also choose the number of tabs for each wall. Due to how the tabs fit together, the “Number of Tabs” entry indicates the maximum number of tabs a wall can have, not the number of tabs every wall has.



### Add Components

* Wall Type: This option allows users to choose whether they want to add an internal separator or an external wall. If neither “External” nor “Internal” is selected, then the “Add Wall” button is disabled.

* Wall Plane: This option allows users to choose the orientation of the wall they want to add — the plane that the wall will be on. However, due to the lack of visual coordinate system, this field changes as users select on walls. It will reflect the plane that the currently-selected wall is on, so that users can understand the orientation better. If a user does not wish to try and select the correct plane, they can choose a wall that is on the plane they want to add on, and the software will automatically adjust to adding a wall on that plane.

* Wall Placement: 

	* Internal Wall Type Selected: This option allows users to choose where they add the wall in the box model. For internal walls, the user can input a decimal that is between 0 and 1; the decimal indicates where the internal wall should be placed between the two external walls on that plane, where the external walls are at exactly 0 and 1 placements. For instance, if a user wants an internal separator that’s halfway between two external walls, they would input 0.5. If they want an internal separator that is a quarter of the way between two walls, they would input 0.25. Any decimal between 0 and 1 will work, but if the material thickness is large, inputting decimals close to 0 and 1 (like 0.01 or .99) would cause the walls to be “too close for comfort.” 

	* External Wall Type Selected: The wall placement for external walls is constrained to either 0 or 1, as these indicate the edges of the boundaries of the box (normalized). The 0 selection indicates the wall at the origin, whilst the 1 selection indicates the wall that is not at the origin. Due to the slightly confusing nature of this, the selection for the missing external wall for the specified plane is automatically chosen by the software. If both external walls for that plane are missing, then the selection defaults to 0. This is for user-friendliness of adding external walls.

* Add Wall: This button adds the wall specified by the other options into the box model. This button is disabled if neither “External” nor “Internal” are selected in the Wall Type drop-down menu.



### Extraneous Buttons and Outputs

* Add Handle: This option allows a users to add a handle to any selected wall. As of now, it is a fixed-size, double-rectangle handle that is separated by a fixed distance. It will allow a wall to be grabbed in real life, after the box has been cut.

* Selected Wall Text Output: For user-friendliness, this text outputs 1) the plane of the selected wall and 2) the placement of the selected wall. If no wall is selected, it defaults to “None selected”

* Delete Selected Component: This button allows users to delete the wall that is currently selected. It does nothing if no wall is selected. Deleting the selected wall can also be accomplished by the "Back-space" key.

* Export: This button allows users to save their current box model as a PDF or JSON. The user can also save via the menu taskbar at File -> Save.

