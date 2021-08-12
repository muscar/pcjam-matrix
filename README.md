# Matrix effect

This is a simple program for real mode DOS to simulate the Matrix effect. It
uses direct access to the text video memory ($B800:0000).

The program starts by pre-filling a screen worth of video memory with random
characters. The it randomly starts "trails" on each column. At each step a trail
move one position towards the bottom of the screen. Trails also grow up maximum
length.
