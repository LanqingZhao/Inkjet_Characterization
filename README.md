# Inkjet_Characterization

## Generals
Author: Lanqing Zhao\
Programming Language:Matlab\
Time created: Aug 2019-Dec 2019\
Mentor:Yafei Mao and Prof.Jan Allebach\
Special mention: My teammate Shikai Zhou contributes to the idea of sub_pixel interpolation, and my code is based on his idea. Yafei Mao provided the idea of test page design.

## Introduction
This project is to characterize statistically the behavior of a HP inkjet printer. The project includes computation of dot profiles of intensity including mean and standard deviation, and based on intensity it also calculates the centroid of intensity of each dots( i.e the weighted center of mass). After that, the data fitting algorithms are used to estimate the ideal alignment, and based ideal alignment the displacements are computed. Finally, we estimate the statistcal models for both dot intensity profile and displacement to build a simulated printer that resembles the printing patterns of HP inkjet printer.
## Data set
Data set is not included.\
Data set includes testing dots of all 4824 nozzles of the HP inkjet printer. We designed 24 blocks of testing samples; each block contains 402 cells of dots. Totally, for each of 4824 nozzles we studied, we have 168 samples for it.\
The data set contains 9648 images of cells , which produced about 24 GB image data (That is one reason why data set is not included).
We also perpared a replacement page for data cleaning.

## The structure of Code
The files are divided into several parts according to their functions.
### Prelimary 
This part simply transformed raw images, which is in the format of 7663.4 dpi, to standard 7200 dpi. This part applied sub-pixel interpolation algorithm to compute the sub-pixel weighted average intensity in a 7200 dpi unit pixel. We also applied Otsu Algorithm, which separates dots and test paper based on the minimization of intra-variance(i.e Fisher Discriminant Analysis). 
### Data Processing
This part is the main part of the project. The data processing program is to transform the raw data set of images to a database. \
The program will use connected-component algorithm to further separate each dot from the background. Then, the dot profile and centroid(aka. weighted center of intensity) are computed. The code also performs data cleaning to find the faint part of each dot which are missed from the connected-component search. The alogirthm of data cleaning includes checking the number of dots, the replacement of data, and dilation that enlarges the targeted areas of a dot. The fitting uses Linear Regression(1D) and the method of Othrogonal Procrustes Problem(2D,grid fit). Then we perform Histogram Estimation, Kernel Estimation, and both 1-D and 2-D Gaussian Mixture Model(GMM). The delivery of this part is a database that stores all of relevant data.This part additionally has a main processing function that displays each part of data processing progress. 
### Main
Main function of the data processing part.
### Interface
This part is not an original objective of this project. Rather, it is optional and developed by me to better access the database. It contains codes to plot the centroid and fitting lines for each scanned raw image data. Additionally, users can easily search and find the relvant data of this inkjet printer. 
### Simulator
This part simulates the printed image of the HP inkjet printer in a A4 paper. 
### Miscellaneous
In final delivery, I used built-in connected-component function to find the individual dot in order to save running time. However, I did write my own connected component using dictionary(map) data structure. I attach this file too.

## Disclaim
After code is submitted for grading, the author stopped maintaining the code. Anyone who wants to use the code must give the due credit the author deserves .




