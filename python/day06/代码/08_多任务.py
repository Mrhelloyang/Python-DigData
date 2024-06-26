import time
import multiprocessing
import os
def sing(num):
    for i in range(num):
        print("sing进程", os.getpid())
        print("sing父进程", os.getppid())
        print("唱歌")
        time.sleep(1)
def run(num):
    for i in range(num):
        print("run进程", os.getpid())
        print("run父进程", os.getppid())
        print("跑步")
        time.sleep(1)

if __name__== '__main__':
    print("父进程",os.getpid())
    run_sub = multiprocessing.Process(target=run,args=(3,))
    sing_sub=multiprocessing.Process(target=sing,kwargs={"num":3})
    sing_sub.start()
    run_sub.start()
