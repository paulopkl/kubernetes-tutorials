#!/bin/bash

for i in `seq 50`; do
    aws sqs send-message --queue-url "<Queue URL>" \
        --message-body "XXXX" \
        --region us-east-1 \
        --output text \
        --no-cli-pager
done
