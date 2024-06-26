import time
import multiprocessing
import os
data_list=[1,2,3]

def write_data():
    global data_list
    for i in range(3):
        data_list.append(i)
    print("写入数据完毕",data_list)
    print(os.getpid())
def read_data():
    print("写入数据完毕",data_list)
    print(os.getpid())

if __name__=="__main__":
    write_sub=multiprocessing.Process(target=write_data)
    read_sub = multiprocessing.Process(target=read_data)
    write_sub.start()
    read_sub.start()
    print(os.getpid())
    print("写入数据完毕2",data_list)
    print(os.getpid())