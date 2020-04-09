
function FindProxyForURL(url, host) {
    // example of pac file that doesn't compile
    if (shExpMatch(host, "*.example.com") // missing ')'
    {
        return "DIRECT" // missing ';'
    }
    return "PROXY proxy.example.com:8080; DIRECT";
}
