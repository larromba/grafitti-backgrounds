#!/bin/bash

home=`pwd`
path=$home/GraffitiBackgrounds

fromDir=$path/en.lproj
toDir=$path/Base.lproj

cp "$fromDir"/*.strings "$toDir/"
