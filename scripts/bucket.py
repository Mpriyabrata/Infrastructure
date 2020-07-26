import boto3

s3 = boto3.resource('s3')
buckets = list(s3.buckets.all())

for bucket in s3.buckets.all():
    print (bucket.name)
    print (buckets)

