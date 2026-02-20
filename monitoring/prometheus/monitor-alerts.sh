echo "=== Checking Which Alerts Actually Fired ==="
echo ""

# Get all firing alerts
ALERTS=$(curl -s "http://localhost:9090/api/v1/alerts" 2>/dev/null)

echo "🔴 FIRING ALERTS:"
echo "----------------"
if [ -n "$ALERTS" ]; then
    echo "$ALERTS" | jq -r '.data.alerts[] | select(.state=="firing") | "• \(.labels.alertname) [\(.labels.severity)]\n  Summary: \(.annotations.summary // "no summary")\n  Since: \(.startsAt)\n"' 2>/dev/null || echo "  Could not parse alerts"
else
    echo "  No alerts firing or cannot connect to Prometheus"
fi

echo ""
echo "📊 ALERT SUMMARY:"
echo "----------------"

# Check each alert type
check_alert() {
    local alert_name=$1
    local count=$(echo "$ALERTS" | jq "[.data.alerts[] | select(.state==\"firing\" and .labels.alertname==\"$alert_name\")] | length" 2>/dev/null || echo "0")
    
    if [ "$count" -gt 0 ]; then
        echo "✅ $alert_name: FIRING ($count instances)"
    else
        echo "❌ $alert_name: NOT firing"
    fi
}

echo "Testing each alert type:"
check_alert "SREAppDown"
check_alert "SREAppPartialOutage"
check_alert "SREAppCompleteOutage"
check_alert "SREAppHighCPU"
check_alert "SREAppHighMemory"
check_alert "SREAppCrashLoop"
check_alert "SREAppPodNotReady"
check_alert "SREAppEventLoopLag"
check_alert "SREAppPodRestarting"
check_alert "SREAppHighContainerCPU"

echo ""
echo "📈 ADDITIONAL CHECKS:"
echo "--------------------"
echo "1. Checking current pod status:"
kubectl get pods -n monitoring -l app=sre-app

echo ""
echo "2. Checking if Prometheus is scraping:"
curl -s "http://localhost:9090/api/v1/query?query=up{job='sre-app'}" | jq '.data.result[] | "\(.metric.instance): \(.value[1])"' 2>/dev/null || echo "No results"

echo ""
echo "3. Checking memory metric specifically:"
curl -s "http://localhost:9090/api/v1/query?query=process_heap_bytes{job='sre-app'}/1024/1024" | jq '.data.result[] | "\(.metric.instance): \(.value[1])MB"' 2>/dev/null || echo "No memory metrics"