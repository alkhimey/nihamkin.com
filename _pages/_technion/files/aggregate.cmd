:: Will aggregate all files starting with "q" that has the "sml" 
:: extension into a single file. If the file already exist,
:: It will be backed up, and replaced by the newer version.

SET aggFile=Examples_333333333_313333333.sml

IF EXIST %aggFile% (
   copy %aggFile% %aggFile%.old 
   del %aggFile% 
)

for %%F IN (q*.sml) DO @type %%F >> %aggFile%
