unit GameServerClient;

interface

type

  // TGameServerClient is a class that represent player data on the server
  TGameServerClient = class
    public
      constructor Create;
      destructor Destroy; override;
      // For our test, counter will be the player data stored on the server.
      // It can be anything related to the player like life, items...
      var counter: UInt32;
  end;

implementation

constructor TGameServerClient.Create;
begin
  inherited;
  counter := 0;
end;

destructor TGameServerClient.Destroy;
begin
  inherited;
end;

end.
