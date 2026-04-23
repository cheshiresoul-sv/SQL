@echo off
setlocal enabledelayedexpansion

REM Recorre todos los archivos en el directorio actual
for %%F in (*.*) do (
    set "NAME=%%~nF"
    set "EXT=%%~xF"

    REM Quitar corchetes del nombre
    set "NEWNAME=!NAME:[=!"
    set "NEWNAME=!NEWNAME:]=!"

    REM Si el nombre cambia, renombrar
    if not "!NAME!!EXT!"=="!NEWNAME!!EXT!" (
        echo Renombrando "%%F" a "!NEWNAME!!EXT!"
        ren "%%F" "!NEWNAME!!EXT!"
    )
)

endlocal
echo Listo.
pause
