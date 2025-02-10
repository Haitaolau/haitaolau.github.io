#!/usr/bin/env python3
import sys
import re

if __name__ == "__main__":

   print(sys.argv)

   validate = re.compile(r"(^CONFIG_.*)(=)(.*)")

   recore_1 = []
   with open(sys.argv[1]) as f:
       for line in f:
           line = line.rstrip()
           a = validate.match(line)
           if a and a.group(1):
               recore_1.append(a.group(1))

   recore_1.sort()

           

   recore_2 = []
   with open(sys.argv[2]) as f:
       for line in f:
           line = line.rstrip()
           a = validate.match(line)
           if a and a.group(1):
               recore_2.append(a.group(1))

   recore_2.sort()


   # compare two files
   # first get the lenths of two list
   len_1  = len(recore_1)
   len_2 =  len(recore_2)
   print(len_1)
   print(len_2)

   if len_1 > len_2:
      print(f"The file name: {sys.argv[1]}")
      for item in recore_1:
         if item not in recore_2:
            print(item)

   if len_1 < len_2:
      for item in recore_2:
         if item not in recore_1:
            print(item)
