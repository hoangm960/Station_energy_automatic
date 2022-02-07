import mysql.connector
def getConnection():
    return mysql.connector.connect(
        host="khktdb.ddns.net",
        user="root",
        password="KhktNH123@@",
        database="khkt_sql",
    )
connection = getConnection()
sql = 'SELECT returned FROM station WHERE stationId = {}'.format(2)
cursor = connection.cursor()
cursor.execute(sql)
returned = [i for i in cursor][0][0] == 0
connection.commit()
cursor.close()
print(returned)
