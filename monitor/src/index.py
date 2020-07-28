#!/usr/bin/env python

import boto3
# import urllib.request as urllib2
import os
import json
import threading
import requests
from requests.exceptions import HTTPError

website_url           = json.loads(os.environ['Website_URL'])
metricname            = os.environ['metricname']
timeout               = int(os.environ['timeout'])

def write_metric(value, metric, site):
	print(value)
	d = boto3.client('cloudwatch')
	d.put_metric_data(Namespace='Website Status',
					  MetricData=[
						  {
					  'MetricName':metric,
					  'Dimensions':[
						  {
					  'Name': 'Status',
					  'Value': 'WebsiteStatusCode',
						  },
						  {
					  'Name': 'Website',
					  'Value': site,
						  },
						  ],
					  'Value': value,
	},
	]
					  )

def check_site(url, metric):

	STAT = 1
	print("Checking %s " % url)
	# request = urllib2.Request(url)
	try:
		response = requests.get(url,timeout=timeout)
		# response.raise_for_status()
	except HTTPError as http_err:
		print(http_err)
		STAT = 501
	except Exception as err:
		print(err)
		STAT = 501

	if STAT != 501 and STAT ==1:
		print('Success!')
		print(response.elapsed.total_seconds())
		STAT = response.status_code

	return STAT

def run_thread(site):
	r = check_site(site,metricname)
	if r == 501:
		r = check_site(site,metricname)
	if r == 200 or r == 304 or r == 400:
		print("Site %s is up" %site)
		write_metric(200, metricname, site)
	else:
		print("[Error:] Site %s down" %site)
		write_metric(int(r), metricname, site)

def handler():

	# Change these to your actual websites.  Remember, the more websites you list
		# the longer the lambda function will run
	websiteurls = website_url
	t = [0]*len(website_url)
	for i in range(len(websiteurls)):
		t[i] = threading.Thread(target=run_thread, args=(website_url[i],))
		t[i].start()

	for i in range(len(t)):
		t[i].join()
	print("Done!")

handler()