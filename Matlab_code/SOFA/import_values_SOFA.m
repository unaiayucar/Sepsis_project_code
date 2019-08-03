clc;
clear all;

%% IMPORT ALL THE 6 DIFFERENT VALUES
loading = tic; % Begining PAIR 1 for whole measure time
% FOR RESPIRATION
tic % Measures PaO2/FiO2 measure time
disp('IMPORTING PaO2/FiO2 non ventilation...');
disp('IMPORTING PaO2/FiO2 ventilation...');
toc % closes PaO2/FiO2 measure time
% FOR NEUROLOGICAL
tic % Measures Glasgow Coma measure time
disp('IMPORTING Glasgow Coma Score Motor...');
gcs_motor_table = readtable('data\gcs_motor_sofa.csv');
disp('IMPORTING Glasgow Coma Score Verbal...');
gcs_verbal_table = readtable('data\gcs_verbal_sofa.csv');
disp('IMPORTING Glasgow Coma Score Eye...');
gcs_eye_table = readtable('data\gcs_eye_sofa.csv');
toc % closes Glasgow Coma measure time
% FOR CARDIOVASCULAR
tic % Measures MAP measure time
disp('IMPORTING Mean Arterial Blood Preassure...');
disp('IMPORTING Dopamine...');
disp('IMPORTING Epinephrine...');
disp('IMPORTING Norepinephrine...');
disp('IMPORTING Dobutamine...');
toc % closes MAP measure time
% tic % Measures Vassopresor measure time
% disp('IMPORTING Vassopresor Information...');
% toc % closes Vassopresor measure time
% FOR LIVER
tic % Measures Bilirubin measure time
disp('IMPORTING Bilirubin Level...');
bilirubin_table = readtable('data\bilirubin_sofa.csv');
toc % closes Bilirubin measure time
% FOR COAGULATION
tic % Measures Platalet measure time
disp('IMPORTING Platelet Count...');
platelet_table = readtable('data\platelet_sofa.csv');
toc % closes Platalet measure time
% FOR RENAL
tic % Measures Creatinine measure time
disp('IMPORTING Creatinine Level...');
creatinine_table = readtable('data\creatinine_sofa.csv');
disp('IMPORTING Urine Output...');
toc % closes Cratinine measure time

%% IMPORT ADULT TABLE AND SEPSIS TABLE FOR BERIFICATION
tic % Measures Sepsis measure time
disp('IMPORTING Patients With SEPSIS...');
sepsis_table = readtable('data\sepsis_sofa.csv');
toc % closes Sepsis measure time
tic % Measures Adults measure time
disp('IMPROTING List Of Adults...');
adults_table = readtable('data\adult_definitive.csv');
toc % closes Adults measure time
tic % Measusres admission information
disp('IMPORTING List Of Admissions...');
admission_table = readtable('data\admissions.csv');
toc % End admission analysis
toc(loading); % meassures all the import time



