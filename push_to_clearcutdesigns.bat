@echo off
REM Simple wrapper to run the PowerShell deploy script.
REM Place this .bat file in the same folder as push_to_clearcutdesigns.ps1, labels.html, library.html, etc.

powershell -ExecutionPolicy Bypass -File "%~dp0push_to_clearcutdesigns.ps1"
