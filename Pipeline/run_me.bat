"C:\Program Files\MATLAB\R2018a\bin\matlab.exe" -wait -nosplash -r "run('First_Round.m');"
"C:\Program Files\MATLAB\R2018a\bin\matlab.exe" -wait -nosplash -r "run('Local_Patch.m');"
python.exe Fitting.py
"C:\Program Files\MATLAB\R2018a\bin\matlab.exe" -wait -nosplash -r "run('ARAP_HRA.m');"
"C:\Program Files\MATLAB\R2018a\bin\matlab.exe" -wait -nosplash -r "run('Local_HRA.m');"