#!/bin/bash

home=`pwd`
path=$home/GooglePhotosBackground

fromDir=$path/en.lproj
toDir=$path/Base.lproj

cp "$fromDir"/*.strings "$toDir/"
