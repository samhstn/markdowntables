# Infrastructure

## ACM

Create our aws managed ssl certificate:

```bash
aws cloudformation create-stack --stack-name mdt-acm --template-body file://infra/acm.yaml
```

Then visit https://console.aws.amazon.com/acm and click 'Create record in Route 53' and 'Create'.
(You may have to wait one minute for this to show).

## Cloudfront

+ Create our cloudfront distribution
+ Attach our certificate
+ Point it at our `gh-pages` url

```bash
aws cloudformation create-stack --stack-name mdt-cloudfront --template-body file://infra/cloudfront.yaml
```

## Route53

Point our domain at our cloudfront distribution

```bash
aws cloudformation create-stack --stack-name mdt-route53 --template-body file://infra/route53.yaml
```
