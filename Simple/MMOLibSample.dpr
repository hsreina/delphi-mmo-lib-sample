program MMOLibSample;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  GameClient in 'GameClient.pas',
  GameServer in 'GameServer.pas',
  GameServerClient in 'GameServerClient.pas',
  MMO.Client in '..\Shared\Libs\delphi-mmo-lib\MMO.Client.pas',
  MMO.ClientList in '..\Shared\Libs\delphi-mmo-lib\MMO.ClientList.pas',
  MMO.ClientReadThread in '..\Shared\Libs\delphi-mmo-lib\MMO.ClientReadThread.pas',
  MMO.Lock in '..\Shared\Libs\delphi-mmo-lib\MMO.Lock.pas',
  MMO.OptionalCriticalSection in '..\Shared\Libs\delphi-mmo-lib\MMO.OptionalCriticalSection.pas',
  MMO.Packet in '..\Shared\Libs\delphi-mmo-lib\MMO.Packet.pas',
  MMO.PacketReader in '..\Shared\Libs\delphi-mmo-lib\MMO.PacketReader.pas',
  MMO.PacketWriter in '..\Shared\Libs\delphi-mmo-lib\MMO.PacketWriter.pas',
  MMO.PrivateServerClient in '..\Shared\Libs\delphi-mmo-lib\MMO.PrivateServerClient.pas',
  MMO.Server in '..\Shared\Libs\delphi-mmo-lib\MMO.Server.pas',
  MMO.ServerClient in '..\Shared\Libs\delphi-mmo-lib\MMO.ServerClient.pas',
  MMO.ServerCreateOptions in '..\Shared\Libs\delphi-mmo-lib\MMO.ServerCreateOptions.pas',
  MMO.Types in '..\Shared\Libs\delphi-mmo-lib\MMO.Types.pas';

var
  server: TGameServer;
  client1: TGameClient;
  client2: TGameClient;
  serverCommand: string;

begin
  try

    server := TGameServer.Create;
    client1 := TGameClient.Create('client 1');
    client2 := TGameClient.Create('client 2');

    while server.IsRunning do
    begin
      ReadLn(serverCommand);
      server.HandleCommand(serverCommand);
    end;

    client2.Free;
    client1.Free;
    server.Free;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
