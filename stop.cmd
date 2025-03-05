@echo off
setlocal

echo Stopping all containers...
docker-compose down

echo.
echo Services stopped.

endlocal
