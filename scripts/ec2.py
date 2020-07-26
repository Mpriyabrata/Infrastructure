import boto3

ec2  =  boto3.client( 'ec2' )
res = ec2.describe_instances()
ins = boto3.resource( 'ec2' )
img = ins.Image( 'id' )

for reservation  in res["Reservations"]:
    for instance in reservation["Instances"]:
        # print(instance)
        print(instance["InstanceId"])
        print(img)
