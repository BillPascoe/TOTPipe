@echo off
setlocal

if "%~1"=="" (
  echo Usage: %~nx0 input.pdf
  exit /b 1
)

set "INPUT=%~1"
set "OUTTXT=%~dp0OCR_%~n1.txt"

echo Started: %DATE% %TIME:~0,8%
echo This may take a few minutes.
echo Most warnings may safely ignored if it keeps running. Check the output is as expected.

pushd "%~dp0"
del /q /f page-*.jpg 2>nul
popd

del /q "%OUTTXT%" 2>nul

echo Exporting pdf pages to jpg images, 1 per page ...

pdftoppm -jpeg "%INPUT%" "%~dp0page"
if errorlevel 1 exit /b 1

echo Cleaning up jpgs ...

pushd "%~dp0"
magick mogrify -colorspace Gray -auto-level -blur 1x1 -deskew 40%% page-*.jpg
popd

echo Converting jpgs to plain text ...

echo.> "%OUTTXT%"
for %%f in ("%~dp0page-*.jpg") do (
  <nul set /p=.
  echo ===== %%~nxf =====>> "%OUTTXT%"
  tesseract "%%f" stdout -l eng >> "%OUTTXT%"
)

echo.
echo Done. Written to:
echo %OUTTXT%
echo You might want to delete all the jpgs created (page-001.jpg etc), or keep them.
echo Finished: %DATE% %TIME:~0,8%

endlocal