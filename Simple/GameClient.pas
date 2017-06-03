unit GameClient;

interface

uses SysUtils, MMO.Client, MMO.Packet, MMO.PacketReader, MMO.PacketWriter;

type
  TGameClient = class(TClient)
    private
      procedure OnConnected; override;
      procedure OnDisconnected; override;
      procedure OnReceivePacket(const packetReader: TPacketReader); override;
      var m_name: string;
    public
      constructor Create(name: string);
      destructor Destroy; override;
  end;

implementation

constructor TGameClient.Create;
begin
  inherited Create('127.0.0.1', 12237);
  m_name := name;
  self.Connect;
end;

destructor TGameClient.Destroy;
begin
  inherited;
end;

procedure TGameClient.OnConnected;
var
  packet: TPacketWriter;
begin

end;

procedure TGameClient.OnDisconnected;
begin

end;

procedure TGameClient.OnReceivePacket(const packetReader: TPacketReader);
var
  reply: TPacketWriter;
  counter: UInt32;
begin

  if not packetReader.ReadUInt32(counter) then
  begin
    WriteLn('Failed to read counter');
    Exit;
  end;

  WriteLn(String.Format('[%s] My counter on the server is : %d', [m_name, counter]));

  // Sleep for a time between 1 and 2 seconds
  self.Sleep(1000 + Random(1000));

  // Send back the value of the counter to the server
  reply := TPacketWriter.Create;
  reply.WriteUInt32(counter);
  self.Send(reply);
  reply.Free;

end;

end.
