#!/usr/bin/env python
#Example usage $ cat tou_translations_7-11.csv | python convert.py > tou_translations_cleansed_a_tags_7-11.csv

import sys
import re

regex = r"<a[^>]*>(.*?)<\/a>"
data = sys.stdin.read()

subst = "\\1"

# You can manually specify the number of replacements by changing the 4th argument
result = re.sub(regex, subst, data, 0)

print(result)
