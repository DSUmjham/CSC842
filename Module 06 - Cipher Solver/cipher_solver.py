#!/usr/bin/python

import sys, getopt
import base64

def atbash(s):
   alphabet = "abcdefghijklmnopqrstuvwxyz" # normal alphabet
   key = "zyxwvutsrqponmlkjihgfedcba" # atbash uses backwards alphabet, so a<=>z, b<=>y, etc.
   result = ''

   for l in s.lower():
      i = key.index(l)
      result += alphabet[i]

   print "AtBash:\t\t", result

def caesar(s):
   # simple rotation of letters, fun fact, it contains the ROT13 cipher!
   alphabet = "abcdefghijklmnopqrstuvwxyz"
   result = ''

   for count in range(0,25):
      result = ''
      for l in s.lower():
         try:
            i = (alphabet.index(l) + count) % 26
            result += alphabet[i]
         except ValueError:
            result += l
      print "Caesar[%d]\t" % count, result


def decoder(s):
   from codecs import decode # used for ROT13

   atbash(s) 
   print "Base64:\t\t", base64.standard_b64encode(s)
   caesar(s)
   print "ROT13:\t\t", decode(s, 'rot13')
   print "URL Safe:\t", base64.urlsafe_b64decode(s)


def main(argv):
   # Check to make sure that the right number of arguments were passed
   try:
      opts, args = getopt.getopt(argv,"hs:",["string="])
   except getopt.GetoptError:
      print 'cipher_solver.py -s <string>'
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print 'cipher_solver.py -s <string>'
         sys.exit()
      elif opt in ("-s", "--string"):
         inputString = arg
   decoder(inputString)

if __name__ == "__main__":
   main(sys.argv[1:])


