unit GameServer;

interface

uses
  SysUtils, MMO.Server, MMO.ServerClient, MMO.PacketReader, MMO.PacketWriter,
  MMO.ServerCreateOptions, GameServerClient;

type
  TGameServer = class(TServer<TGameServerClient>)
    private
      procedure OnReceiveClientPacket(const client: TServerClient<TGameServerClient>;
        const packetReader: TPacketReader); override;
      procedure OnClientCreate(const client: TServerClient<TGameServerClient>); override;
      procedure OnClientDestroy(const client: TServerClient<TGameServerClient>); override;
      var m_running: Boolean;
    public
      constructor Create;
      destructor Destroy; override;
      procedure HandleCommand(const command: string);
      property IsRunning: Boolean read m_running;
  end;

implementation

procedure TGameServer.HandleCommand(const command: string);
begin
  if command = 'exit' then
  begin
    m_running := false;
  end;
end;

constructor TGameServer.Create;
var
  serverCreateOptions: TServerCreateOptions;
begin

  serverCreateOptions.Port := 12237;
  // With the thread safe option, the server will handle thread synchronization
  // Otherwise, you'll must handle thread synchronization by yourself.
  // Don't forget to synchronise with the UI if you use one
  serverCreateOptions.ThreadSafe := true;
  serverCreateOptions.MaxPlayers := 30;

  inherited Create(serverCreateOptions);
  m_running := true;
  self.Start;
end;

destructor TGameServer.Destroy;
begin
  inherited;
end;

procedure TGameServer.OnClientCreate(const client: TServerClient<TGameServerClient>);
var
  firstPacket: TPacketWriter;
  gameServerClient: TGameServerClient;
begin
  // Initialize the game server client.
  // The client represent player custom data on server side
  gameServerClient := TGameServerClient.Create;
  client.Data := gameServerClient;

  // Put a random value in the player younter
  gameServerClient.counter := Random(1000);

  // Send Initial counter to the client
  firstPacket := TPacketWriter.Create;
  firstPacket.WriteUInt32(gameServerClient.counter);
  client.Send(firstPacket);
  firstPacket.Free;
end;

procedure TGameServer.OnClientDestroy(const client: TServerClient<TGameServerClient>);
begin
  // When the server client is destroyed, you must destroy the player data
  client.Data.Free;
end;

procedure TGameServer.OnReceiveClientPacket(const client: TServerClient<TGameServerClient>;
  const packetReader: TPacketReader);
var
  gameServerClient: TGameServerClient;
  reply: TPacketWriter;
  counter: UInt32;
begin

  if not packetReader.ReadUInt32(counter) then
  begin
    WriteLn('Failed to read client counter');
    Exit;
  end;

  gameServerClient := client.Data;

  // Check if the client did receive and send back the right counter value
  if not (counter = gameServerClient.counter) then
  begin
    WriteLn('something went wrong. The client don''t know what about the current counter value?');
  end;

  // Increment the player counter then send it back to the player
  Inc(gameServerClient.counter);

  // Send Initial counter to the client
  reply := TPacketWriter.Create;
  reply.WriteUInt32(gameServerClient.counter);
  client.Send(reply);
  reply.Free;
end;

end.
