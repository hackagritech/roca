program ServerAuth;

{$APPTYPE CONSOLE}

uses
  Horse,
  Horse.Jhonson,
  JOSE.Core.JWT,
  JOSE.Core.Builder,
  System.SysUtils,
  Horse.CORS,
  System.JSON;

{$R *.res}

var
  App: THorse;

begin
  App := THorse.Create(9000);

  App.Use(Jhonson);
  App.Use(CORS);

  App.Post('/auth',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      LToken: TJWT;
    begin
      if (TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('USERNAME').Value = '') then
        begin
          Res.Send('Username or Password not specified.');
        end
      else
        begin
          LToken := TJWT.Create;

          try

            LToken.Claims.Issuer := 'Auth.JWT';                             //“iss” (Issuer) Origem do token
            LToken.Claims.Subject := TJSONObject(TJSONObject.ParseJSONValue(Req.Body)).GetValue('USERNAME').Value;               //“sub” (Subject) Entidade a quem o token pertence, normalmente o ID do usuário
            LToken.Claims.Expiration := Now + 1;                            //“exp” (Expiration) Timestamp de quando o token expira

            {
              "iss": "127.0.0.13",
              "exp": 1300819380,
              "user": "programadriano"
            }

            Res.Send(TJSONObject.Create(TJSONPair.Create('token', TJOSE.SHA256CompactToken('Roca.WeAre', LToken))));
          finally
            LToken.Free;
          end;
        end;
    end);

  App.Start;
end.
