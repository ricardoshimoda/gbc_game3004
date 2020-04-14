import json
import boto3

dynamodb = boto3.resource('dynamodb')

def lambda_handler(event, context):
    table = dynamodb.Table('Players')
    
    if event['httpMethod'] == 'PUT':
        if 'body' in event:
            body_text = event['body']
            body = json.loads(body_text)
            if 'Username' in body and 'Password' in body and body['Username'] and body['Password']:
                username = body['Username']
                anotherUser = table.get_item(Key={'user_id':username})
                if 'Item' in anotherUser and anotherUser['Item']:
                    return {
                        'statusCode': 200,
                        'body': json.dumps('Username already exists.')
                    }
                newUser = {'username' : body['Username'], 'password': body['Password'],}
                table.put_item(Item = new_entry)
                return {
                    'statusCode': 200,
                    'body': json.dumps('Registration Successful')
                }
            else:
                return {
                    'statusCode': 200,
                    'body': json.dumps('Username or Password cannot be empty.')
                }
        else :
            return {
                'statusCode': 200,
                'body': json.dumps('Body not found.')
            }   
    else :
       return {
            'statusCode': 200,
            'body': json.dumps('Invalid Request')
        }