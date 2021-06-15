unit HttpRest;

interface

uses
  System.JSON, IdHTTP, System.Classes, System.SysUtils;

const
  apiUrl: string = 'http://localhost:8080/Backend-BankSystem/public/api/v1';

type
  THttpResponse = class
    public
      Status: string;
      Data: TJSONValue;
      Message: string;
      Reason: string;
      constructor Create(response: TJSONObject);
      function Success(): boolean;
  end;

  THttpRest = class abstract
    public
      class var Token: string;
      class function SendGet(const resource: string): THttpResponse;
      class function SendPost(const resource: string; const jsonData: TJSONObject): THttpResponse;
  end;

implementation

class function THttpRest.SendGet(const resource: string): THttpResponse;
var
  http: TIdHTTP;
  response: string;
begin
  http := TIdHttp.Create;
  http.Request.Accept := 'application/json';
  http.Request.CustomHeaders.AddValue('Authorization', Token);
  try
    response := http.Get(apiUrl + resource);
    Result := THttpResponse.Create(
      TJSONObject.ParseJSONValue(response) as TJSONObject
    );
  except
    on ex: EIdHTTPProtocolException do begin
      if ex.ErrorCode <> 200 then
        raise Exception.Create(
          TJSONObject.ParseJSONValue(ex.ErrorMessage).FindValue('reason').Value
        );
    end;
  end;
end;

class function THttpRest.SendPost(const resource: string; const jsonData: TJSONObject): THttpResponse;
var
  http: TIdHTTP;
  response: string;
  jsonStream: TStringStream;
begin
  http := TIdHttp.Create;
  http.Request.Accept := 'application/json';
  http.Request.ContentType := 'application/json';
  http.Request.CustomHeaders.AddValue('Authorization', Token);
  try
    jsonStream := TStringStream.Create(jsonData.ToString, TEncoding.UTF8);
    response := http.Post(apiUrl + resource, jsonStream);
    Result := THttpResponse.Create(
      TJSONObject.ParseJSONValue(response) as TJSONObject
    );
  except
    on ex: EIdHTTPProtocolException do begin
      if (ex.ErrorCode <> 200) and (TJSONObject.ParseJSONValue(ex.ErrorMessage).FindValue('reason') <> nil) then
        raise Exception.Create(
          TJSONObject.ParseJSONValue(ex.ErrorMessage).FindValue('reason').Value
        )
      else
        raise Exception.Create(
          TJSONObject.ParseJSONValue(ex.ErrorMessage).FindValue('message').Value
        );
    end
  end;
end;

constructor THttpResponse.Create(response: TJSONObject);
begin
  Status := response.GetValue('status').Value;
  response.TryGetValue('data', Data);
  response.TryGetValue('message', Message);
  response.TryGetValue('reason', Reason);
end;

function THttpResponse.Success;
begin
  Result := Status = 'success';
end;
end.
