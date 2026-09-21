@echo off
REM ============================================================================
REM start-local-server.bat
REM
REM Spotify's login flow will not work if you open index.html by just
REM double-clicking it (a "file://" address) — Spotify requires the app to
REM be served over "http://" or "https://". This script starts a tiny local
REM web server using Python, which Windows 11 can install automatically from
REM the Microsoft Store the first time you run "python" if it isn't already
REM present, and opens the app in your default browser.
REM
REM The server only serves files from this folder, only to this PC
REM (127.0.0.1 = "this computer, not the network"), and stops as soon as you
REM close this window.
REM ============================================================================

cd /d "%~dp0"

echo Starting local server at http://127.0.0.1:5500 ...
echo Press Ctrl+C in this window to stop the server when you're done.
echo.

start "" http://127.0.0.1:5500/index.html

python -m http.server 5500
