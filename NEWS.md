# LandscaperGolem 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.

This isn't what news should really be used for, but important to put my learnings here I think.

Initalise modules with golem::add_module("name_of_mod"), we then receive a new .R file named mod_name_of_mod.R. Inside this .R file there are two new functions, mod_name_of_mod_ui(), mod_name_of_mod_server()

When working on the modules, work on them in a separate .R file and then add the `mod_*_ui and` `mod_*_server` functions respectively to app_ui.R when ready. 

How to work with modules inside modules, or is this a bad idea?

#ADD NS TO STUFF
Need to remember to add all inputs and outputs to module's namespace with the ns() function. (This is the key)


When calling modules with modules, e.g.

mod_conversation_landscape has mod_data_table_ui in it.

 mod_data_table_ui(ns("dataTable")) - Good
  mod_data_table_ui("dataTable") - Bad (when calling modules as have to send the ns into the other ns.)

