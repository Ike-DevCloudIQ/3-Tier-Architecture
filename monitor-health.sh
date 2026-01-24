#!/bin/bash

ALB_URL="http://external-alb-726938100.eu-west-1.elb.amazonaws.com"

echo "=== Monitoring 3-Tier Architecture Health ==="
echo "Testing: $ALB_URL"
echo "Press Ctrl+C to stop"
echo ""

while true; do
    echo -n "$(date '+%H:%M:%S'): "
    
    # Test the ALB
    response=$(curl -s --connect-timeout 5 --max-time 10 "$ALB_URL" 2>&1)
    
    if echo "$response" | grep -q "502 Bad Gateway"; then
        echo "❌ 502 Bad Gateway - Instances still unhealthy"
    elif echo "$response" | grep -q "3-Tier Architecture"; then
        echo "✅ SUCCESS! Web servers are responding"
        echo "   Response preview: $(echo "$response" | grep -o '<h1>[^<]*</h1>' | head -1)"
        break
    elif echo "$response" | grep -q "timeout\|Connection"; then
        echo "⏳ Connection timeout - ALB might be starting"
    else
        echo "🔄 Unexpected response - checking..."
    fi
    
    sleep 30
done

echo ""
echo "🎉 Your 3-tier architecture is now working!"
echo "🌐 Access it at: $ALB_URL"