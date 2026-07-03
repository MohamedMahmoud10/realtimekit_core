#!/bin/bash

sh "./clean.sh"

flutter pub run build_runner build --delete-conflicting-outputs