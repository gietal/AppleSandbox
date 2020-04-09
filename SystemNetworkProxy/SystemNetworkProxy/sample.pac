function FindProxyForURL(url, host) {
    // example bypass
    if (shExpMatch(host, "*.example.com"))
    {
        return "DIRECT";
    }

    // example failover: try proxy1, then proxy2, then direct
    return "PROXY proxy1.example.com:8080; PROXY proxy2.example.com:8080; DIRECT";
}
