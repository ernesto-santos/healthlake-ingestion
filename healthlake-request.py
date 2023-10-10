import requests, json, sys, time
from requests_auth_aws_sigv4 import AWSSigV4

healthlake_endpoint = "https://healthlake.us-east-1.amazonaws.com/datastore/01a01...hash...1a010/r4/"
splitted_json = json.loads('{"resourceType": "Bundle", "type": "batch", "entry": []}')

counter = 0

with open(sys.argv[1]) as f:
    datadict = json.loads(f.read())

total_size = len(datadict["entry"])
print(total_size)

for index,item in enumerate(datadict["entry"]):

    del item["fullUrl"]
    item["request"]["method"] = "PUT"
    item["request"]["url"] = item["resource"]["resourceType"] + "/" + item["resource"]["id"]

    splitted_json["entry"].append(item)
    imported = False

    counter += 1

    if len(splitted_json["entry"]) > 159:
        while(not imported):
            print("Realizando request: " + str(counter) + " / " + str(total_size))
            r = requests.request('POST', healthlake_endpoint,
                data=json.dumps(splitted_json),
                auth=AWSSigV4('healthlake'))

            if(r.status_code != 200):
                time.sleep(1)
                print(str(r.status_code) + " - Dormindo 1sec")
            else:
                print(r.status_code)
                imported = True

        splitted_json["entry"].clear()

if len(splitted_json["entry"]) > 0:
    while(not imported):
        print("Realizando request: " + str(counter) + " / " + str(total_size))
        r = requests.request('POST', healthlake_endpoint,
                data=json.dumps(splitted_json),
                auth=AWSSigV4('healthlake'))

        if(r.status_code != 200):
            time.sleep(1)
            print(str(r.status_code) + " - Dormindo 1sec")
        else:
            print(r.status_code)
            imported = True

    splitted_json["entry"].clear()
