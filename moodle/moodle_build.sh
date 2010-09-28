#!/bin/bash

#This is the official script used for importing of TinyMCE snapshot with customisations into Moodle
#maintained by Petr Skoda

#edit following to match your git checkouts
SOURCEDIR=/Users/skodak/server/workspace/tinymce
TARGETDIR=/Users/skodak/server/workspace/moodle20/lib/editor/tinymce/tiny_mce/3.3.9.1
SPELLDIR=/Users/skodak/server/workspace/tinymce_spellchecker_php


#first build the tinymce project
cd $SOURCEDIR
ant



#now copy to our new moodle subdirectory for this tinymce version
mkdir $TARGETDIR
cp $SOURCEDIR/jscripts/tiny_mce/*.* $TARGETDIR/
cp -R $SOURCEDIR/jscripts/tiny_mce/langs $TARGETDIR/
cp -R $SOURCEDIR/jscripts/tiny_mce/plugins $TARGETDIR/
cp -R $SOURCEDIR/jscripts/tiny_mce/themes $TARGETDIR/
cp -R $SOURCEDIR/jscripts/tiny_mce/utils $TARGETDIR/
cp -R $SOURCEDIR/jscripts/tiny_mce/classes/Popup.js $TARGETDIR/tiny_mce_popup_src.js



#build and add our custom plugins
cd $SOURCEDIR/moodle/plugins/dragmath
java -jar $SOURCEDIR/tools/ant/yuicompressor.jar --line-break 1000 editor_plugin_src.js -o editor_plugin.js
cp -R $SOURCEDIR/moodle/plugins/dragmath $TARGETDIR/plugins

cd $SOURCEDIR/moodle/plugins/moodlemedia
java -jar $SOURCEDIR/tools/ant/yuicompressor.jar --line-break 1000 editor_plugin_src.js -o editor_plugin.js
cp -R $SOURCEDIR/moodle/plugins/moodlemedia $TARGETDIR/plugins

cd $SOURCEDIR/moodle/plugins/moodlenolink
java -jar $SOURCEDIR/tools/ant/yuicompressor.jar --line-break 1000 editor_plugin_src.js -o editor_plugin.js
cp -R $SOURCEDIR/moodle/plugins/moodlenolink $TARGETDIR/plugins



#replace spell plugin with our modified version from different repo
rm -R $TARGETDIR/plugins/spellchecker
mkdir $TARGETDIR/plugins/spellchecker
cd $SPELLDIR
ant
cd $SOURCEDIR/moodle
cp -R $SPELLDIR/* $TARGETDIR/plugins/spellchecker
rm -R $TARGETDIR/plugins/spellchecker/tools
rm $TARGETDIR/plugins/spellchecker/build.*
rm $TARGETDIR/plugins/spellchecker/readme.md



# undo git changes - it would be great if upstream use the same process for tiny_mce_popup.js
cd $SOURCEDIR/jscripts/tiny_mce
git checkout tiny_mce_popup.js



#NOTE: fix all line endings to match Moodle coding style rules!!!!!
