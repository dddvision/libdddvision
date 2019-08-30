#!/bin/bash
for a in *.png; do convert "$a" -bordercolor Black -border 7x7 "$a"; done

