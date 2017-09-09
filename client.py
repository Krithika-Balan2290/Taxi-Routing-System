import random
import MySQLdb
import datetime
import time

reqId = 1
list_requests = []
conn = MySQLdb.connect("localhost","root","password","project")
cursor = conn.cursor()
while reqId < 20:
    request = dict()
    cities = ['EC', 'UMC', 'Hill', 'Pearl Street', 'Glenwood', 'Canyon', 'Arapahoe', 'Marine Court', 'C4C', '29th Street']
    hours = ['00','01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23']
    minutes = ['00', '05', '10', '15', '20', '25', '30', '35', '40', '45', '50', '55']
    source = random.choice(cities)
    nDestinations = random.choice(range(1,3))
    destinations = random.sample(cities, nDestinations)
    nPassengers = random.choice(range(1,5))
    hours = random.choice(hours)
    minutes = random.choice(minutes)
    seconds = datetime.datetime.now().second
    if nPassengers >= len(destinations):
        request['reqId'] = reqId
        request["nPassengers"] = nPassengers
        request["source"] = source
        request["destinations"] = ','.join(destinations)
        tme = str(hours)+':'+str(minutes)+':'+str(seconds)
        request["time"] = tme
        cursor.execute('''INSERT into requests(req_ID,time,pickup,destination,passenger_count) values (%s,%s,%s,%s,%s)''',(request['reqId'], request["time"],request["source"],request["destinations"],request["nPassengers"]))
        reqId += 1
        time.sleep(5)
        print request
conn.autocommit(True)
print 'Done...'
cursor.close()
conn.close()
