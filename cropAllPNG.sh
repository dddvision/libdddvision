#!/bin/bash
for a in *.png; do convert -trim "$a" "$a"; done

