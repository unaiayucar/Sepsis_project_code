clc;
clear all;

%% IMPORT ALL THE 6 DIFFERENT VALUES
loading = tic; % Begining PAIR 1 for whole measure time
% FOR TEMPERATURE
tic 
disp('IMPORTING temperature...');
temperature_table = readtable('data\temperature.csv');
toc

tic
disp('IMPORTING heart_rate...');
heart_rate_table = readtable('data\heart_rate.csv');
toc

tic
disp('IMPORTING respiratory_rate...');
respiratory_rate_table = readtable('data\respiratory_rate.csv');
pco2_table = readtable('data\pco2.csv');
toc

tic
disp('IMPORTING wbc...');
wbc_table = readtable('data\wbc.csv');
toc



% PATIENTS WEIGHT
weight_table = readtable('data\weights.csv');

%% IMPORT ADULT TABLE AND SEPSIS TABLE FOR BERIFICATION
tic % Measures Sepsis measure time
disp('IMPORTING Patients With SEPSIS...');
sepsis_table = readtable('data\sepsis.csv');
toc % closes Sepsis measure time
tic % Measures Adults measure time
disp('IMPROTING List Of Adults...');
adults_table = readtable('data\adults.csv');
toc % closes Adults measure time
tic % Measusres admission information
disp('IMPORTING List Of Admissions...');
admission_table = readtable('data\admissions.csv');
toc % End admission analysis
toc(loading); % meassures all the import time



