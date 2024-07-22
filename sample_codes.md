# Bottle API Server Client code
### Server code
"""
import bottle
from bottle import Bottle, get, post, run, request,route
import json

app= Bottle()

@app.route('/get_info',method="GET")
def index():
    postdata = request.json
    print(postdata)
    loc_info={"position": {
                        "y": 2.0,
                        "x": 2.0,
                        "z": 0
                    },
                    "heading": 2.5,}
    # js = json.dumps(loc_info)
    return { "status": "ok", 'prop': loc_info}

@app.route('/api', method="POST")
def api():
    postdata = request.json
    print(postdata) #this goes to log file only, not to client
    return { "status": "ok"}

run(app,host='localhost', port=8080)
"""
#### Client code
"""
#!/usr/bin/env python
import requests
import json

class SendDetail(object):
    def __init__(self):
        self.url = "http://localhost:8080/post_info"
        self.url_get = "http://localhost:8080/get_info"
        self.send_registration_details_to_telesight()

    """
    Provide AGV registration details to telesight
    """
    def send_registration_details_to_telesight(self):
        slot = "slot1"
        agv_name = "jackal01"
        agv_type= "jackal"
        try:
            agv_info = self.prolog_obj.get_agv_info(agv_name)
            print(agv_info)
            onboard_location = self.prolog_obj.get_onboard_location(slot)
            print(onboard_location)
        except Exception as e:
            rospy.logdebug('Exception raised: %s' %e)


        # data ={ "accountId": "636cf5c8f640e6ad458f9296",
        #     "warehouseId": "62d6e7d5a17cb98345fadf2a",
        #     "floorId": "62d6e7d5a17cb98345fadf2a",
        #     "agvId": agv_name,
        #     "robotType": agv_type,
        #     "telemetry": {
        #             "status":"IDLE",
        #             "linearVelocity": 0,
        #             "angularVelocity": 0,
        #             "timestamp": 1668691452,
        #             "position": {
        #                 "y": 2.035,
        #                 "x": 1.883,
        #                 "z": 0
        #             },
        #             "mapId": "b3_f1",
        #             "locationId": slot,
        #             "heading": -2.278829677494836,
        #     },
        #     "metadata": {
        #             "batteryLevel": "100",
        #             "bssid": "",
        #             "ipaddress": "172.17.0.3",
        #             "signalStrength": "good",
        #             "ssid": "",
        #     }
        # }

        data= {"warehouseId": "62d6e7d5a17cb98345fadf2a",
                "floorId": "62d6e7d5a17cb98345fadf2a",
                "mapId": "b3_f1",
                "locationId": 'slot1'
        }

        try:

            headers = {
            'content-type': "application/json",
            'cache-control': "no-cache"
            }

            payload = json.dumps(data)
            response = requests.request("GET", self.url_get, headers=headers, data=payload)
            t= json.loads(response.text)
            print(t['prop']['heading'])

        except Exception as e:
            rospy.logdebug('Exception raised: %s' %e)

        # print(resp.status_code)
        # return resp.status_code

if __name__ == "__main__":
    db= SendDetail()
"""