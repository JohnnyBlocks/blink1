@echo off 
set TimeDelay=100
set BlinkCount=15


for /l %%x in (1, 1, %BlinkCount%) do (
    blink1-tool -m %TimeDelay% --rgb 255,200,0 >  NUL
    sleep -m %TimeDelay%
    blink1-tool -m %TimeDelay% --rgb 255,0,0 >  NUL
    sleep -m %TimeDelay%
    
)
    blink1-tool -m %TimeDelay% --rgb 0,0,0 >  NUL
    sleep -m %TimeDelay%


