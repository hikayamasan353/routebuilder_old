unit UWave;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MMSystem,StdCtrls, Buttons, ExtCtrls;

type

  TWaveData = Class(TPersistent)
              private
                FData     : pointer;
                FSize     : Longint;
                function    DoWrite:Boolean;
                procedure   Fill(ASize:Longint;AData:Pointer);
              protected
                procedure   DefineProperties(Filer: TFiler); override;
                procedure   ReadData(Stream: TStream); virtual;
                procedure   WriteData(Stream: TStream); virtual;
              public
                procedure   Clear;
                procedure   LoadFromFile(Value:String);virtual;
                procedure   Assign(Source:TPersistent);override;
                procedure   Play;virtual;
                function    Empty:Boolean;
                destructor  Destroy;override;
              end;

  TWave = class(TComponent)
  protected
    FWaveData : TWaveData;
    FOnPlay   : TNotifyEvent;
    procedure   SetWaveData(Value:TWaveData);
  public
    procedure   play;
    constructor Create(AOwner: TComponent);override;
    destructor  Destroy;override;
  published
    property    WaveData:TWaveData Read FWaveData write SetWaveData;
    property    OnPlay  :TNotifyEvent read FOnPlay write FOnPlay;
  end;
{================================================================================}




procedure Register;

implementation

{$R *.DFM}
{==================================================================================}
procedure TWaveData.Clear;
begin
If Not Empty then
   begin
   FreeMem(FData,FSize);
   FSize:=0;
   end;
end;

procedure TWaveData.Fill(ASize:Longint;AData:Pointer);
begin
Clear;
If ASize>0 then
   begin
   FSize:=ASize;
   GetMem(FData,FSize);
   Move(AData^,FData^,FSize);
   end;
end;

procedure TWaveData.Assign(Source:TPersistent);
begin
If Source=Nil then
   Clear
  else
   If Source is TWaveData then
      Fill(TWaveData(Source).FSize,TWaveData(Source).FData)
     else
      inherited Assign(Source);
end;

procedure TWaveData.LoadFromFile(Value:String);
var F  :File;
    Aux:Longint;
begin
Clear;
Aux:=FileMode;
FileMode:=0;
If FileExists(Value) then
   begin
   Assignfile(f,Value);
   Reset(f,1);
   If FileSize(f)>0 then
      begin
      FSize:=FileSize(f);
      GetMem(FData,FSize);
      BlockRead(f,FData^,FSize);
      end;
   CloseFile(f);
   end;
FileMode:=Aux;
end;

function TWaveData.Empty:Boolean;
begin
Result:=(FSize=0);
end;

procedure TWaveData.Play;
begin
If Not Empty then
   PlaySound(FData,Application.Handle,SND_ASYNC + SND_MEMORY + SND_NODEFAULT);
end;

function TWaveData.DoWrite:Boolean;
begin
Result:=Not Empty;
end;

procedure TWaveData.WriteData(Stream: TStream);
begin
Stream.Write(FSize,SizeOf(FSize));
Stream.Write(FData^,FSize);
end;

procedure TWaveData.ReadData(Stream: TStream);
begin
Clear;
Stream.Read(FSize,SizeOf(FSize));
If FSize>0 then
   begin
   GetMem(FData,FSize);
   Stream.Read(FData^,FSize);
   end;
end;

procedure TWaveData.DefineProperties(Filer: TFiler);
begin
inherited DefineProperties(Filer);
Filer.DefineBinaryProperty('Data', ReadData, WriteData, DoWrite);
end;

destructor TWaveData.destroy;
begin
Clear;
inherited destroy;
end;
{==================================================================================}
procedure TWave.Play;
begin
If Assigned(FOnPlay) then FOnPlay(Self);
FWaveData.Play;
end;

procedure TWave.SetWaveData(Value:TWaveData);
begin
FWaveData.Assign(Value);
end;

constructor TWave.Create(AOwner:TComponent);
begin
inherited Create(AOwner);
FWaveData:=TWaveData.Create;
end;

destructor TWave.Destroy;
begin
FWaveData.Free;
inherited Destroy;
end;
{==============================================================================}
{==================================================================}
procedure Register;
begin
  RegisterComponents('Justus', [TWave]);
end;
{==============================================================================}


end.
