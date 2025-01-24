#!/bin/bash
cp $PWD/Lib/libQxt* /usr/lib/
ln -s /usr/lib/libQxtGui.so.0.6.2 /usr/lib/libQxtGui.so.0
ln -s /usr/lib/libQxtCore.so.0.6.2 /usr/lib/libQxtCore.so.0
