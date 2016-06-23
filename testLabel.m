%pre-process labels
clear all;close all;clc

label_filename = 'test2.txt';
tic;
[allimgIndex,allimgNames,allallLabels] = readLabelFromFile(label_filename);        %read training labels
toc;

LTM = buildingLTM();
allVertexpos = caculateAllVertexes(allimgIndex,allallLabels,allimgNames,LTM);



