import http.client, urllib.request, urllib.parse, urllib.error, base64
import json
import requests
import sys
import uuid



#Authanticate User
def authenticate_user(content_type, x_reference_id, ocp_Apim_subscription_Key):
    headers = {
    # Request headers
    'X-Reference-Id':x_reference_id,
    'Content-Type':content_type,
    'Ocp-Apim-Subscription-Key':ocp_Apim_subscription_Key
    }

    body = {"providerCallbackHost": "google.com"}
    

    try:
        response = requests.post("https://sandbox.momodeveloper.mtn.com/v1_0/apiuser?",headers = headers, data=json.dumps(body))
        print("stape1")
        print(str(response.status_code) + str(body))
    except Exception as e:
        print('Error')



#generate Api Key
def generate_api_key(x_reference_id, ocp_Apim_subscription_Key):
    headers = {
    # Request headers
    'Ocp-Apim-Subscription-Key': ocp_Apim_subscription_Key,
    }
    params = urllib.parse.urlencode({
    })
    try:
        conn = http.client.HTTPSConnection('sandbox.momodeveloper.mtn.com')
        conn.request("POST", "/v1_0/apiuser/{}/apikey?%s".format(x_reference_id) % params, "{body}", headers)
        response = conn.getresponse()
        key = response.read()
        key = key.decode("utf-8")
        key = json.loads(key)
        key = key['apiKey']
        key = base64.b64encode('{}:{}'.format(x_reference_id,key).encode('utf-8'))
        key = 'Basic {}'.format(key.decode("utf-8"))
        print("stape2")
        print(str(response.status_code) + key)
        conn.close()
    except Exception as e:
        print('Error')
        #print("[Errno {0}] {1}".format(e.errno, e.strerror))
    return key


#get Tokent
def get_token(ocp_Apim_subscription_Key, key):
    access_tok=""
    headers = {
    # Request headers
    'Authorization': key,
    'Ocp-Apim-Subscription-Key': ocp_Apim_subscription_Key,
}

    params = urllib.parse.urlencode({
})
    try:
        conn = http.client.HTTPSConnection('sandbox.momodeveloper.mtn.com')
        conn.request("POST", "/collection/token/?%s" % params, "", headers)
        response = conn.getresponse()
        resp_dict = response.read()
        resp_dict = resp_dict.decode("utf-8")
        resp_dict = json.loads(resp_dict)
        access_tok = resp_dict['access_token']
        print("stape3")
        print(str(response.status_code) + access_tok)
        conn.close()
    except Exception as e:
        #print("[Errno {0}] {1}".format(e.errno, e.strerror))
        print('Error')
    return access_tok



#Start transaction
def requesttopay(
                  x_reference_id="03fddfc0-b324-4fa0-9a83-302db2e2de26",
                  content_type="application/json",
                  ocp_Apim_subscription_Key="4dd1f48a808e4da7b97ca5ef5cd2f827",
                  x_target_environment='sandbox',
                  amount='1000',
                  phone_number='677111143',
                  currency='EUR',
                  externalId='1234',
                  country_code='237',
                  partyIdType = 'MSISDN',
                  payerMessage = 'string',
                  payeeNote ='string' ,
                ):
    authenticate_user(content_type, x_reference_id, ocp_Apim_subscription_Key)
    key = generate_api_key(x_reference_id, ocp_Apim_subscription_Key)
    access_token = get_token(ocp_Apim_subscription_Key, key)
    access_token = 'Bearer {}'.format(access_token)
    headers = {
    # Request headers
    'Authorization': access_token,
    'X-Reference-Id': x_reference_id,
    'X-Target-Environment':x_target_environment,
    'Content-Type': content_type,
    'Ocp-Apim-Subscription-Key': ocp_Apim_subscription_Key,
}

    body = {
  "amount": amount,
  "currency": currency,
  "externalId": externalId,
  "payer": {
    "partyIdType": partyIdType,
    "partyId": country_code+phone_number
  },
  "payerMessage": payerMessage,
  "payeeNote": payeeNote,
}

    try:
        response = requests.post("https://sandbox.momodeveloper.mtn.com/collection/v1_0/requesttopay?",headers = headers, data=json.dumps(body))
        print("final")

        return str(body)
    except Exception as e:
        #print("[Errno {0}] {1}".format(e.errno, e.strerror))
        print('Error')
#print(uuid.uuid4())
#print(requesttopay(content_type="application/json", x_reference_id="03fddfc0-b324-4fa0-9a83-302db2e2de26", ocp_Apim_subscription_Key="4dd1f48a808e4da7b97ca5ef5cd2f827", x_target_environment="sandbox",amount="1100",phone_number="665326045"))
