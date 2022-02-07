from multiprocessing import Process
import mysql.connector
import serial
from pynput.keyboard import Key, Listener
from time import sleep
import geocoder

count = 0
a = {
    "VoltageDC": 0,
    "CurrentDC": 0,
    "VoltageAC": 0,
    "CurrentAC": 0,
    "PowerAC": 0,
    "EnergyAC": 0,
    "FrequencyAC": 0,
    "PFAC": 0,
}
ID = 2

def getConnection():
    return mysql.connector.connect(
        host="khktdb.ddns.net",
        user="root",
        password="KhktNH123@@",
        database="khkt_sql",
    )

def show(key):
    if key == Key.esc:
        return False

def get_key():
    with Listener(on_press=show) as listener:
        listener.join()

def updateReturn(connection):
    sql = 'UPDATE station SET returned = 0 WHERE stationId = {}'.format(ID)
    cursor = connection.cursor()
    cursor.execute(sql)
    connection.commit()
    cursor.close()

def fingerSystem(ard, connection, cmd):
    ard.write(cmd.encode())
    if cmd == '2':
        fingerId = input()
        ard.write(fingerId.encode())
    data = ''
    while 'Found ID' not in data:
        data = ard.readline().decode("utf8").strip()
        if any(map(data.__contains__, ['DC', 'AC'])):
            continue
        print(data)
    updateReturn(connection);
    sleep(3)
    
def checkReturn(connection):
    sql = 'SELECT returned FROM station WHERE stationId = {}'.format(ID)
    cursor = connection.cursor()
    cursor.execute(sql)
    returned = [i for i in cursor][0][0] == 1
    connection.commit()
    cursor.close()
    return returned
        
def update_data():
    try:
        ard = serial.Serial("COM3", 9600, timeout=5)
    except serial.SerialException:
        print("Can't find COM3")
    
    while True:
        connection = getConnection()
        if checkReturn(connection):
            fingerSystem(ard, connection, '1')
        else:
            for _ in range(8):
                data = ard.readline().decode("utf8").strip().split(":")
                if data[0] != "Out AC":
                    a[data[0]] = data[1].strip().split()[0]
                else:
                    a["VoltageAC"] = 0
                    a["CurrentAC"] = 0
                    a["PowerAC"] = 0
                    a["EnergyAC"] = 0
                    a["FrequencyAC"] = 0
                    a["PFAC"] = 0
                    break

            sleep(0.1)
            print(' - '.join(f'{k}:{a[k]}' for k in a.keys()))
            cursor = connection.cursor()
            sql = "UPDATE station SET voltDC = {}, currentDC = {}, voltAC = {}, currentAC = {}, powerAC = {}, energyAC = {}, frequencyAC = {}, powerfactorAC = {} WHERE stationId = {}".format(
                *a.values(), ID
            )
            cursor.execute(sql)
            connection.commit()
            cursor.close()
        connection.close()
        

def updateLocation():
    while True:
        connection = getConnection()
        cursor = connection.cursor()
        g = geocoder.ip('me').latlng
        cmd = "UPDATE station SET location = Point({}, {}) WHERE stationId = {}".format(*g, ID)
        cursor.execute(cmd)
        connection.commit()
        cursor.close()
        connection.close()
        sleep(3600)

def updateUrl():
    connection = getConnection()
    cursor = connection.cursor()
    with open('D:\source_code\livestream.txt', 'r', encoding='utf8') as f:
        url = f.readline().strip()
    cmd = 'UPDATE camera SET url = "{}" WHERE stationId = {}'.format(url, ID)
    cursor.execute(cmd)
    connection.commit()
    cursor.close()
    connection.close()
     
if __name__ == "__main__":
    updateUrl()
    keyProcess = Process(target=get_key)
    updateDataProcess = Process(target=update_data)
    updateLocationProcess = Process(target=updateLocation)
    keyProcess.start()
    updateDataProcess.start()
    updateLocationProcess.start()
    while keyProcess.is_alive():
        pass
    updateDataProcess.kill()
    updateLocationProcess.kill()
    connection.close()
