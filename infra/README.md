# Infrastructure

## ACM

+ Create our aws managed ssl certificates

```bash
aws cloudformation create-stack --stack-name mdt-acm --template-body file://infra/acm.yaml
aws cloudformation wait stack-create-complete --stack-name mdt-acm
```

Then visit https://console.aws.amazon.com/acm and click 'Create record in Route 53' and 'Create'.
(You may have to wait one minute for this to show).
(This takes up to 30 minutes to deploy).

## Cloudfront

+ Create our cloudfront distribution
+ Attach our certificate
+ Point it at our `gh-pages` url

```bash
aws cloudformation create-stack --stack-name mdt-cloudfront --template-body file://infra/cloudfront.yaml
aws cloudformation wait stack-create-complete --stack-name mdt-cloudfront
```

(This takes around 30 minutes to deploy).

## S3

+ Create our S3 www redirect bucket

```bash
aws cloudformation create-stack --stack-name mdt-s3 --template-body file://infra/s3.yaml
aws cloudformation wait stack-create-complete --stack-name mdt-s3
```

## Route53

+ Point our domain at our cloudfront distribution
+ Point our www domain at our S3 redirect bucket

```bash
aws cloudformation create-stack --stack-name mdt-route53 --template-body file://infra/route53.yaml
```
