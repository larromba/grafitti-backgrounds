#!/bin/bash

home=`pwd`
path=$home/GrafittiBackgrounds

fromDir=$path/en.lproj
toDir=$path/Base.lproj

cp "$fromDir"/*.strings "$toDir/"

swiftgen