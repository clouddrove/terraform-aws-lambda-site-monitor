#!/usr/bin/env python

import boto3
import urllib.request as urllib2
import os
import json

website_url           = json.loads(os.environ['Website_URL'])
metricname            = os.environ['metricname']

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
	request = urllib2.Request(url)

	try:
		response = urllib2.urlopen(request)
		response.close()
	except urllib2.URLError as e:
		if hasattr(e, 'code'):
			print("1st if")
			print ("[Error:] Connection to %s failed with code: " %url +str(e.code))
			STAT = int(e.code)
			# write_metric(STAT, metric, url)
		if hasattr(e, 'reason'):
			print("2nd if")
			print ("[Error:] Connection to %s failed with code: " % url +str(e.reason))
			STAT = 501
			# write_metric(STAT, metric, url)
	except urllib2.HTTPError as e:
		if hasattr(e, 'code'):
			print("3rd if")
			print ("[Error:] Connection to %s failed with code: " % url + str(e.code))
			STAT = int(e.code)
			# write_metric(STAT, metric, url)
		if hasattr(e, 'reason'):
			print("4th if")
			print ("[Error:] Connection to %s failed with code: " % url + str(e.reason))
			STAT = 501
			# write_metric(STAT, metric, url)
	if STAT != 501:
		STAT = response.getcode()

	return STAT

def handler(event, context):

	# Change these to your actual websites.  Remember, the more websites you list
        # the longer the lambda function will run
	websiteurls = website_url

	for site in websiteurls:
		r = check_site(site,metricname)
		if r == 200 or r == 304 or r == 304:
			print("Site %s is up" %site)
			write_metric(200, metricname, site)
		else:
			print("[Error:] Site %s down" %site)
			write_metric(int(r), metricname, site)