import boto3
import json


session = boto3.Session(
    aws_access_key_id='AKIAXNGUU54VYUAYJDNQ',
    aws_secret_access_key='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',
    region_name='us-east-2'
)
bedrock_runtime = session.client('bedrock-runtime')

body = json.dumps({
    "anthropic_version": "bedrock-2023-05-31",
    "max_tokens": 1000,
    "messages": [
        {
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": "What is the meaning of life?"
                }
            ]
        }
    ]
})

response = bedrock_runtime.invoke_model(
    body=body,
    modelId='us.anthropic.claude-3-5-sonnet-20240620-v1:0',
    accept="application/json",
    contentType="application/json"
)

response_body = json.loads(response['body'].read())
answer = response_body['content'][0]['text']
print(answer)

# bedrock_runtime = session.client('bedrock-runtime')
# model_id = "us.anthropic.claude-3-haiku-20240307-v1:0"

# inference_profile_id = 'us.anthropic.claude-3-haiku-20240307-v1:0'

# response = bedrock_runtime.invoke_model(
#     body=json.dumps({
#         "prompt": "Human:What is the meaning of life? \nAssistant:",
#         "max_tokens_to_sample": 300,
#         "temperature": 0.5,
#         "top_p": 0.9,
#     }),
#     modelId=inference_profile_id,
#     contentType='application/json',
#     accept='application/json'
# )

# print(response)
