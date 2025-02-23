#!/bin/env python3


import re
import sys
import os
import re

def read_input_file(filename):
    
    valida = re.compile(r"(^[0-9a-f]{12}) (\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2}) (.*00) (.*)")
    result = []

    with open(filename) as f:
        for line in f:
            line = line.rstrip()
            a =  valida.match(line)
            
            if a.group(1) and a.group(5):
                result.append({'commit':a.group(1), 'title':a.group(5)})

    return result


def search_in_list(item,result):

    for i in result:
        if i['title'] == item:
            return True

    return False


if __name__ == "__main__":

    result_1 =read_input_file(sys.argv[1])
    result_2 =read_input_file(sys.argv[2])

    index = 1
    
    for i in result_1:

        if not search_in_list(i['title'], result_2):
            print(f"{index} {i.get('commit')} {i.get('title')}")
            index = index +1
 
