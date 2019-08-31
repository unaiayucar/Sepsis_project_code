clc;
clear all;

%% IMPORT ALL THE 6 DIFFERENT VALUES
loading = tic; % Begining PAIR 1 for whole measure time
% FOR RESPIRATION
tic % Measures PaO2/FiO2 measure time
disp('IMPORTING PaO2/FiO2 non ventilation...');
FIO2_table = readtable('data\fio_lab.csv');
FIO2_chart_table = readtable('data\fio2_chart.csv');
PO2_table = readtable('data\po2.csv');
disp('IMPORTING PaO2/FiO2 ventilation...');
ventilation_table = readtable('data\ventilation_asistance.csv');
toc % closes PaO2/FiO2 measure time
% FOR NEUROLOGICAL
tic % Measures Glasgow Coma measure time
disp('IMPORTING Glasgow Coma Score Motor...');
gcs_motor_table = readtable('data\gcs_motor.csv');
disp('IMPORTING Glasgow Coma Score Verbal...');
gcs_verbal_table = readtable('data\gcs_verbal.csv');
disp('IMPORTING Glasgow Coma Score Eye...');
gcs_eye_table = readtable('data\gcs_eye.csv');
toc % closes Glasgow Coma measure time
% FOR CARDIOVASCULAR
tic % Measures MAP measure time
disp('IMPORTING Mean Arterial Blood Preassure...');
mbp_table = readtable('data\meanBP.csv');
disp('IMPORTING Dopamine...');
dopamine_table = readtable('data\dopamine.csv');
disp('IMPORTING Epinephrine...');
dobutamine_table = readtable('data\dobutamine.csv');
disp('IMPORTING Norepinephrine...');
norepinephrine_table = readtable('data\norepinephrine.csv');
disp('IMPORTING Dobutamine...');
epinephrine_table = readtable('data\epinephrine.csv');
toc % closes MAP measure time
% tic % Measures Vassopresor measure time
% disp('IMPORTING Vassopresor Information...');
% toc % closes Vassopresor measure time
% FOR LIVER
tic % Measures Bilirubin measure time
disp('IMPORTING Bilirubin Level...');
bilirubin_table = readtable('data\bilirubin.csv');
toc % closes Bilirubin measure time
% FOR COAGULATION
tic % Measures Platalet measure time
disp('IMPORTING Platelet Count...');
platelet_table = readtable('data\platelet.csv');
toc % closes Platalet measure time
% FOR RENAL
tic % Measures Creatinine measure time
disp('IMPORTING Creatinine Level...');
creatinine_table = readtable('data\creatinine.csv');
disp('IMPORTING Urine Output...');
toc % closes Cratinine measure time

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



