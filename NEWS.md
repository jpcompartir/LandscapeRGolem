# LandscaperGolem 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.

This isn't what news should really be used for, but important to put my learnings here I think.

Initalise modules with golem::add_module("name_of_mod"), we then receive a new .R file named mod_name_of_mod.R. Inside this .R file there are two new functions, mod_name_of_mod_ui(), mod_name_of_mod_server()

When working on the modules, work on them in a separate .R file and then add the `mod_*_ui and` `mod_*_server` functions respectively to app_ui.R when ready. 
