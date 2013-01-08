import ctypes
from ctypes import byref
from ctypes import Structure, Union
from ctypes.wintypes import *
import threading
import subprocess
import msvcrt
import os
import sys
import time

# LightStyle = 0 is Black(off) to Red
# LightStyle = 1 is Green to Red
LightStyle = 1

                                                 

LONGLONG = ctypes.c_longlong
HQUERY = HCOUNTER = HANDLE
pdh = ctypes.windll.pdh
Error_Success = 0x00000000



class PDH_Counter_Union(Union):
    _fields_ = [('longValue', LONG),
                ('doubleValue', ctypes.c_double),
                ('largeValue', LONGLONG),
                ('AnsiStringValue', LPCSTR),
                ('WideStringValue', LPCWSTR)]

class PDH_FMT_COUNTERVALUE(Structure):
    _fields_ = [('CStatus', DWORD),
                ('union', PDH_Counter_Union),]


g_cpu_usage = 0
class QueryCPUUsageThread(threading.Thread):
    def __init__(self):
        super(QueryCPUUsageThread, self).__init__()
        self.hQuery = HQUERY()
        self.hCounter = HCOUNTER()
        if not pdh.PdhOpenQueryW(None, 
                                 0, 
                                 byref(self.hQuery)) == Error_Success:
            raise Exception
        if not pdh.PdhAddCounterW(self.hQuery,
                                 u'''\\Processor(_Total)\\% Processor Time''',
                                 0,
                                 byref(self.hCounter)) == Error_Success:
            raise Exception
        
    def run(self):
        chr = 0
        while chr != 'q':
            if msvcrt.kbhit():
                 chr = msvcrt.getch()
            global g_cpu_usage
            g_cpu_usage = self.getCPUUsage()
            os.system('cls')
            print "Blink(1) CPU Monitor"
            print ""
            print "Press Q to exit application"
            print
            if LightStyle == 1:
                 colorLevel = int(round(255 * (g_cpu_usage / 100.0)))
                 print 'cpu_usage: {0}   blink1-tool --rgb {1},0,0'.format(str(g_cpu_usage).zfill(2),colorLevel)
                 subprocess.call('blink1-tool -m 100 --rgb {0},0,0'.format(colorLevel), stdout=subprocess.PIPE) 
            else:
                 v_red = 0
                 v_green = 0
                 v_blue = 0
                 
                 if g_cpu_usage > 50:
                      v_green = 255.0*(1.0-2.0*(g_cpu_usage-50.0)/100.0)
                      v_red = 255.0*(1.0)
                 else:
                      v_green = 255.0*(1.0)
                      v_red = ((g_cpu_usage/100.0)*2.0)*255.0
                
                 print 'cpu_usage: {0}    rgb: {1} {2} {3}'.format(str(g_cpu_usage).zfill(2),str(int(v_red)).zfill(3),str(int(v_green)).zfill(3),v_blue)
                 subprocess.call('blink1-tool -m 100 --rgb {0},{1},{2}'.format(int(v_red),int(v_green),v_blue), stdout=subprocess.PIPE) 
        os.system('cls')
        print "Blink(1) CPU Monitor"
        print ""
        print "Press Q to exit application"
        print 
        print 'Exiting App       rgb: 0,0,0'
        subprocess.call('blink1-tool -m 2000 --rgb 0,0,255', stdout=subprocess.PIPE)
        time.sleep(2)
        subprocess.call('blink1-tool -m 2000 --rgb 0,0,0', stdout=subprocess.PIPE)
        sys.exit(0)
        
    def getCPUUsage(self):
        PDH_FMT_LONG = 0x00000100
        if not pdh.PdhCollectQueryData(self.hQuery) == Error_Success:
            raise Exception
        ctypes.windll.kernel32.Sleep(333)
        if not pdh.PdhCollectQueryData(self.hQuery) == Error_Success:
            raise Exception

        dwType = DWORD(0)
        value = PDH_FMT_COUNTERVALUE()
        if not pdh.PdhGetFormattedCounterValue(self.hCounter,
                                          PDH_FMT_LONG,
                                          byref(dwType),
                                          byref(value)) == Error_Success:
            raise Exception

        return value.union.longValue

if __name__=='__main__':
         thread = QueryCPUUsageThread()
         thread.start()
		 
		 
    

