@echo off 
set TimeDelay=50
set BlinkCount=50


for /l %%x in (1, 1, %BlinkCount%) do (
    blink1-tool -m %TimeDelay% --rgb 255,0,255 >  NUL
    sleep -m %TimeDelay%
    blink1-tool -m %TimeDelay% --rgb 0,0,255 >  NUL
    sleep -m %TimeDelay%
)





blink1-tool -m %TimeDelay% --rgb 0,0,0 > NUL