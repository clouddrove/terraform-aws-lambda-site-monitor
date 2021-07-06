
import socket
import requests
import json
import ssl, boto3
import re,sys,os,datetime


# Slack details
SLACK_CHANNEL = os.environ["SLACK_CHANNEL"]
SLACK_WEBHOOK = os.environ["SLACK_WEBHOOK"]
ICON_EMOJI = ':hubot:'
USERNAME   = 'CloudDrove Bot'

green = "#27AE60"
red = "#E74C3C"
yellow = "#FFFF00"
domains = json.loads(os.environ['domains'])


def get_ssl_issuer_name(domainname):
    print("inside Issuer")
    ssl_date_fmt = r'%b %d %H:%M:%S %Y %Z'
    context = ssl.create_default_context()
    conn = context.wrap_socket(
        socket.socket(socket.AF_INET),
        server_hostname=domainname,
    )
    # 30 second timeout because Lambda has runtime limitations
    conn.settimeout(30.0)
    conn.connect((domainname, 443))
    ssl_info = conn.getpeercert()
    # print(ssl_info)

    issuer = dict(x[0] for x in ssl_info['issuer'])
    issued_by = issuer['commonName']

    return issued_by




def get_ssl_expiry_date(domainname):
    print("inside expiry")
    ssl_date_fmt = r'%b %d %H:%M:%S %Y %Z'
    context = ssl.create_default_context()
    conn = context.wrap_socket(
        socket.socket(socket.AF_INET),
        server_hostname=domainname,
    )
    # 30 second timeout because Lambda has runtime limitations
    conn.settimeout(30.0)
    conn.connect((domainname, 443))
    ssl_info = conn.getpeercert()
    # print(ssl_info)
    return datetime.datetime.strptime(ssl_info['notAfter'], ssl_date_fmt).date()

def get_ssl_issue_date(domainname):
    print("inside issue")
    ssl_date_fmt = r'%b %d %H:%M:%S %Y %Z'
    context = ssl.create_default_context()
    conn = context.wrap_socket(
        socket.socket(socket.AF_INET),
        server_hostname=domainname,
    )
    # 30 second timeout because Lambda has runtime limitations
    conn.settimeout(3.0)
    conn.connect((domainname, 443))
    ssl_info = conn.getpeercert()
    # print(ssl_info)
    return datetime.datetime.strptime(ssl_info['notBefore'], ssl_date_fmt).date()




def ssl_expiry_date(domainname):
    ssl_date_fmt = r'%b %d %H:%M:%S %Y %Z'
    context = ssl.create_default_context()
    conn = context.wrap_socket(
        socket.socket(socket.AF_INET),
        server_hostname=domainname,
    )
    # 30 second timeout because Lambda has runtime limitations
    conn.settimeout(3.0)
    conn.connect((domainname, 443))
    ssl_info = conn.getpeercert()
    # print(ssl_info)
    return datetime.datetime.strptime(ssl_info['notAfter'], ssl_date_fmt).date()

def ssl_valid_time_remaining(domainname):
    """Number of days left."""
    expires = ssl_expiry_date(domainname)
    print(expires)
    return expires - datetime.datetime.utcnow().date()




def create_slack_payload(json_dict, type='success', reason="SSL-Expiry-Checkup"):
    if(type == "success" and json_dict['Alert'] == "Critical"):
        print("Critical")
        payload ={
            "attachments": [
               {
                    "fallback": reason,
                    "color": red,
                    "title": reason,
                    "fields": [
                        {
                            "title": "Domain Name",
                            "value": json_dict['domainNmae'],
                            "short": True
                        },
                        {
                            "title": "Issuer Name",
                            "value": json_dict['Issuer_Name'],
                            "short": True
                        },
                        {
                            "title": "Issue Date",
                            "value": json_dict['Issue'],
                            "short": True
                        },
                        {
                            "title": "Expiry Date",
                            "value": json_dict['Expires'],
                            "short": True
                        },
                        {
                            "title": "Remaining Days",
                            "value": json_dict['days'],
                            "short": True
                        },
                        {
                            "title": "Message",
                            "value": json_dict['Message'],
                            "short": True
                        }
                    ],
                    "footer": "CloudDrove",
                    "footer_icon": "https://clouddrove.com/media/images/favicon.ico",
                }
            ],
            'channel': SLACK_CHANNEL,
            'username': USERNAME,
            'icon_emoji': ICON_EMOJI
        }
        return payload
    elif(type == "success" and json_dict['Alert'] == "Warning"):
        print("Warning")
        payload ={
            "attachments": [
               {
                    "fallback": reason,
                    "color": yellow,
                    "title": reason,
                    "fields": [
                        {
                            "title": "Domain Name",
                            "value": json_dict['domainNmae'],
                            "short": True
                        },
                        {
                            "title": "Issuer Name",
                            "value": json_dict['Issuer_Name'],
                            "short": True
                        },
                        {
                            "title": "Issue Date",
                            "value": json_dict['Issue'],
                            "short": True
                        },
                        {
                            "title": "Expiry Date",
                            "value": json_dict['Expires'],
                            "short": True
                        },
                        {
                            "title": "Remaining Days",
                            "value": json_dict['days'],
                            "short": True
                        },
                        {
                            "title": "Message",
                            "value": json_dict['Message'],
                            "short": True
                        }
                    ],
                    "footer": "CloudDrove",
                    "footer_icon": "https://clouddrove.com/media/images/favicon.ico",
                }
            ],
            'channel': SLACK_CHANNEL,
            'username': USERNAME,
            'icon_emoji': ICON_EMOJI
        }
        return payload
    else:
        print("All Well")
        print(datetime.datetime.utcnow().date())
        payload ={
            "attachments": [
               {
                    "fallback": reason,
                    "color": green,
                    "title": reason,
                    "fields": [
                        {
                            "title": "Domain Name",
                            "value": json_dict['domainNmae'],
                            "short": True
                        },
                        {
                            "title": "Issuer Name",
                            "value": json_dict['Issuer_Name'],
                            "short": True
                        },
                        {
                            "title": "Issue Date",
                            "value": json_dict['Issue'],
                            "short": True
                        },
                        {
                            "title": "Expiry Date",
                            "value": json_dict['Expires'],
                            "short": True
                        },
                        {
                            "title": "Remaining Days",
                            "value": json_dict['days'],
                            "short": True
                        },
                        {
                            "title": "Message",
                            "value": json_dict['Message'],
                            "short": True
                        }
                    ],
                    "footer": "CloudDrove",
                    "footer_icon": "https://clouddrove.com/media/images/favicon.ico",
                }
            ],
            'channel': SLACK_CHANNEL,
            'username': USERNAME,
            'icon_emoji': ICON_EMOJI
        }
        return payload





def fatal(message, code=1):
    sys.exit(code)


def post_to_slack(payload):
    print("Check Slack")
    try:
        req = requests.post(SLACK_WEBHOOK, data=str(payload), timeout=3)
    except requests.exceptions.Timeout as e:
        fatal("Server connection failed: {}".format(e))
    except requests.exceptions.RequestException as e:
        fatal("Request failed: {}".format(e))

    if req.status_code != 200:
        print("error")
        fatal(
            "Non 200 status code: {}\nResponse Headers: {}\nResponse Text: {}".format(
                req.status_code,
                req.headers,
                json.dumps(req.text, indent=4)
            ),
            code=255
        )





#####Main Section
def handler(event, context):

    for dName in domains:
        print(dName)
        issued_On=get_ssl_issue_date(dName.strip())
        expires_On=get_ssl_expiry_date(dName.strip())
        issuer_name=get_ssl_issuer_name(dName.strip())
        expDate = ssl_valid_time_remaining(dName.strip())
        print(expDate)
        print(issued_On)
        print(expires_On)
        (a, b) = str(expDate).split(',')
        (c, d) = a.split(' ')
    # Critical alerts
        if int(c) < 15:
            payload = create_slack_payload({"domainNmae":dName, "days": str(c), "Alert": "Critical" ,"Issuer_Name":str(issuer_name) ,"Issue":str(issued_On) , "Expires":str(expires_On), "Message": dName+" SSL certificate will be expired in "+str(c)+" days"},"success","SSL-Expiry-Checkup")
            post_to_slack(payload)
      # Frist critical alert on 20 th day
        elif int(c) == 20:
            # sns_Alert(dName, str(c), 'Critical')
            payload = create_slack_payload({"domainNmae":dName, "days": str(c), "Alert": "Critical" ,"Issuer_Name":str(issuer_name) ,"Issue":str(issued_On) , "Expires":str(expires_On), "Message": dName+" SSL certificate will be expired in "+str(c)+" days"},"success","SSL-Expiry-Checkup")
            post_to_slack(payload)

    #third warning alert on 30th day
        elif int(c) == 31:
            payload = create_slack_payload({"domainNmae":dName, "days": str(c), "Alert": "Critical","Issuer_Name":str(issuer_name) ,"Issue":str(issued_On) , "Expires":str(expires_On) , "Message": dName+" SSL certificate will be expired in "+str(c)+" days"},"success","SSL-Expiry-Checkup")
            post_to_slack(payload)

    #second warning alert on 40th day
        elif int(c) == 40:
            payload = create_slack_payload({"domainNmae":dName, "days": str(c), "Alert": "Warning" ,"Issuer_Name":str(issuer_name) ,"Issue":str(issued_On) , "Expires":str(expires_On), "Message": dName+" SSL certificate will be expired in "+str(c)+" days"},"success","SSL-Expiry-Checkup")
            post_to_slack(payload)
    #First warning alert on 50th day
        elif int(c) == 68:
            payload = create_slack_payload({"domainNmae":dName, "days": str(c), "Alert": "Warning" , "Issuer_Name":str(issuer_name) ,"Issue":str(issued_On) , "Expires":str(expires_On),"Message": dName+" SSL certificate will be expired in "+str(c)+" days"},"success","SSL-Expiry-Checkup")
            post_to_slack(payload)
        else:
            print('Everything Fine..')
            payload = create_slack_payload({"domainNmae":dName, "days": str(c), "Alert": "None" , "Issuer_Name":str(issuer_name) ,"Issue":str(issued_On) , "Expires":str(expires_On) , "Message": dName+" SSL certificate will be expired in "+str(c)+" days"},"success","SSL-Expiry-Checkup")
            post_to_slack(payload)
