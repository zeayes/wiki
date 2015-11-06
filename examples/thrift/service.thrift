namespace go rpc

service Service {
    list<string> funcCall(1:i64 callTime, 2:string funcCode, 3:map<string, string> paramMap),
}
