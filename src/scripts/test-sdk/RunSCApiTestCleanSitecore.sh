#!/bin/bash
#
#
#####################



IOS_VERSION=$1
CONFIGURATION=$2

APP_NAME=SCApiTestCleanSitecore
LAUNCH_DIR=$PWD

echo arg1        - $1
echo IOS_VERSION - $IOS_VERSION

cd ../
  SCRIPTS_ROOT_DIR=$PWD
cd "$LAUNCH_DIR"

cd ../../
    PROJECT_ROOT=$PWD
cd "$LAUNCH_DIR"

cd "$PROJECT_ROOT/test/FunctionalTests/$APP_NAME"
pwd

xcodebuild -project $APP_NAME.xcodeproj -target SCApiTestLibs -configuration $CONFIGURATION -sdk iphonesimulator$IOS_VERSION clean build
if [ "$?" -ne "0" ]; then
   echo "[!!! ERROR !!!] : Build failed"
   echo xcodebuild -project $APP_NAME.xcodeproj -target SCApiTestLibs -configuration $CONFIGURATION -sdk iphonesimulator$IOS_VERSION clean build
   exit 1
fi


BUILT_PRODUCTS_DIR=$( cat /tmp/SCApiTestLibsBuild/PRODUCT_DIR.txt )
cd "$BUILT_PRODUCTS_DIR/$CONFIGURATION-iphonesimulator"
/bin/bash "$SCRIPTS_ROOT_DIR/simulator/KillSimulator.sh"
    iphonesim launch "$PWD/SCApiTestLibs.app" $IOS_VERSION 
/bin/bash "$SCRIPTS_ROOT_DIR/simulator/KillSimulator.sh"

cd "$LAUNCH_DIR"
