import json
import boto3
def lambda_handler(event, context):
    ses = boto3.client('ses')
    print(event['name'])
    body = 'Name : ' + event['name'] + '\n Email : ' + event['email'] + '\n Phone : '+ event['phone'] + '\n Query : ' +event['desc']
    ses.send_email(
        Source = 'franklinp@sph.com.sg',
        Destination = {'ToAddresses': ['franklinp@sph.com.sg']},
        Message = {'Subject':{
               'Data':'Testing SES form submission',
               'Charset':'UTF-8'
           },
           'Body':{
               'Text':{
                   'Data':body,
                   'Charset':'UTF-8'
               }
           }}
    )
    return{'statusCode': 200,'body': json.dumps('Email sent successfully ')}
