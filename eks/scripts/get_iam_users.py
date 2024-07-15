import boto3
import sys
import json

group_name = sys.argv[1]
profile_name = sys.argv[2]

session = boto3.Session(profile_name=profile_name)
client = session.client('iam')

# Get list of users in the group
response = client.get_group(GroupName=group_name)
users = response['Users']

# Extract ARNs
user_arns = [user['Arn'] for user in users]

# Prepare the result as a JSON encoded map of string keys and string values
result = {"user_arns": json.dumps(user_arns)}

# Print the result
print(json.dumps(result))