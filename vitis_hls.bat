@echo off
setlocal enabledelayedexpansion
rem #
rem # COPYRIGHT NOTICE
rem # Copyright 1986-2022 Xilinx, Inc. All Rights Reserved. 
rem # Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved. 
rem # 
set MY_ROOT_DIR=%~dp0

set PATH=%MY_ROOT_DIR%;%MY_ROOT_DIR%..\tps\win64\msys64\usr\bin;%PATH%
set PATH=%MY_ROOT_DIR%;%MY_ROOT_DIR%..\tps\win64\msys64\mingw64\bin;%PATH%

rem # Setup default environmental variables
call "%MY_ROOT_DIR%setupEnv.bat"

rem # Use vbs launcher for GUI to avoid command shell
set RDI_VBSLAUNCH=
if [%1] == [] (
 set RDI_VBSLAUNCH=%~dp0vitis_hls_gui.vbs
)

set RDI_USE_JDK11=True
set RDI_PROG=%~n0
set HLS_ORIG_ARGS=%*
rem # Setup HLS variables
call "%~dp0hlsArgs.bat " %*

rem # Launch the loader
set HLS_TMP_CMD=call "%RDI_BINROOT%/loader.bat" -exec %RDI_PROG% %ALL_HLS_ARGS%
if [%HLS_TERSE_OUTPUT%]==[1] (
   if [%HLS_LOG_FILTERS%]==[] set HLS_LOG_FILTERS=INFO: [HLS 200-1510];INFO: [HLS 200-111];INFO: [Common 17-206];Sourcing Tcl script;ERROR:
   if [%HLS_START_FILTERS%]==[] set HLS_START_FILTERS=** Copyright
   if [%HLS_NEEDLOG%]==[1] (
      %HLS_INTERPRETER% /c %HLS_TMP_CMD% 2>&1 | "%RDI_BINROOT%/loader.bat" -exec hls_tee -start ";!HLS_START_FILTERS!;" -filter ";!HLS_LOG_FILTERS!;" -log !HLS_LOG! 
   ) else (
      %HLS_INTERPRETER% /c %HLS_TMP_CMD% 2>&1 | "%RDI_BINROOT%/loader.bat" -exec hls_tee -start ";!HLS_START_FILTERS!;" -filter ";!HLS_LOG_FILTERS!;"
   )
) else if [%HLS_NEEDLOG%]==[1] (
   %HLS_INTERPRETER% /c %HLS_TMP_CMD% 2>&1 | tee.exe %HLS_LOG%
) else (
   %HLS_INTERPRETER% /c %HLS_TMP_CMD%
)

endlocal

rem exit /b %errorlevel%

