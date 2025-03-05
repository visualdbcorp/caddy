@echo off
setlocal

echo Creating necessary directories...
if not exist logs\caddy mkdir logs\caddy

echo Checking for existing Visual DB container...
docker ps -q -f name=visualdb > nul
if %ERRORLEVEL% == 0 (
    echo Stopping existing Visual DB container...
    docker stop visualdb
    docker rm visualdb
)

echo Starting Visual DB with Caddy SSL termination...
docker-compose up -d

echo.
echo Services started. Status:
docker-compose ps

echo.
echo Access your Visual DB instance at: https://visualdb.local
echo NOTE: You may need to add 'visualdb.local' to your hosts file pointing to 127.0.0.1
echo e.g., Add this line to C:\Windows\System32\drivers\etc\hosts:
echo 127.0.0.1 visualdb.local
echo.
echo To edit your hosts file:
echo 1. Run Notepad as Administrator
echo 2. Open the file C:\Windows\System32\drivers\etc\hosts
echo 3. Add the line: 127.0.0.1 visualdb.local
echo 4. Save the file

endlocal
