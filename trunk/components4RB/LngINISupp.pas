unit LngINISupp;

interface

uses      
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, StdCtrls, menus, extctrls, comctrls, buttons;

type
  TLngINISupp = class(TComponent)
  private
    FFileName: TFileName;
    FMenu: TMainMenu;
    FPMenu: TPopupMenu;
    procedure SetFileName(const Value: TFileName);
    procedure CheckFile(FN: TFileName);
    procedure FindCaptions;
    procedure MenuOnClick(Sender: TObject);
    procedure PMenuOnClick(Sender: TObject);
    procedure ReadCaptions;
    procedure FindLngFilesM;
    procedure FindLngFilesP;
    procedure VerifyValue(FormName, CompName, CapLab: String);
    procedure SetMenu(const Value: TMainMenu);
    procedure SetPMenu(const Value: TPopupMenu);
  protected
  public
    procedure Open;
    procedure Close;
    procedure Read;
    procedure Save;
  published
    property FileName: TFileName read FFileName write SetFileName;
    property Menu: TMainMenu read FMenu write SetMenu;
    property PopupMenu: TPopupMenu read FPMenu write SetPMenu;
  end;

var
  AppIni: TIniFile;
  FNF: Bool = false;
  FNP: Bool = false;
  VV: Bool = false;
  MC: Bool = false;
  PC: Bool = false;
  LngFiles: TStrings;
  Lng, Child: TMenuItem;
  PLng, PChild: TMenuItem;
  Changed: Bool = false;

procedure Register;

implementation

uses MsgINISupp;

{$R LangINI.RES}

procedure Register;
begin
  RegisterComponents('LangINISupport', [TLngINISupp]);
end;

{ TLngINISupp }

procedure TLngINISupp.Open;
begin
  CheckFile(FFileName);
  if FNP = true then abort;
  VV := false;
  FindCaptions;
  ReadCaptions;
  if ((FMenu <> nil) and (MC = false)) then
    begin
      LngFiles := TStringList.Create;
      FindLngFilesM;
      LngFiles.Free;
    end;
  if ((FPMenu <> nil) and (PC = false)) then
    begin
      LngFiles := TStringList.Create;
      FindLngFilesP;
      LngFiles.Free;
    end;
end;

procedure TLngINISupp.Read;
begin
  CheckFile(FFileName);
  if FNP = true then abort;
  VV := false;
  FindCaptions;
  ReadCaptions;
end;

procedure TLngINISupp.Close;
begin
 FFileName := '';
end;

procedure TLngINISupp.SetFileName(const Value: TFileName);
begin
  FFileName := ExtractFileDir(ParamStr(0)) + '\' + ExtractFileName(Value);
end;

procedure TLngINISupp.SetPMenu(const Value: TPopupMenu);
begin
  FPMenu := Value;
end;

procedure TLngINISupp.VerifyValue(FormName, CompName, CapLab: String);
begin
  AppIni := TIniFile.Create(FFileName);
  if ((not AppIni.ValueExists(FormName, CompName)) or (VV = true)) then
     AppIni.WriteString(FormName, CompName, CapLab);
  AppIni.Free;
end;

procedure TLngINISupp.SetMenu(const Value: TMainMenu);
begin
  FMenu := Value;
end;

procedure TLngINISupp.MenuOnClick(Sender: TObject);
var
  MLFN: TFileName;
begin
  with Sender as TMenuItem do
    begin
      MLFN := Name + '.lng';
      SetFileName(ExtractFileDir(ParamStr(0)) + '\' + MLFN);
      Open;
    end;
end;

procedure TLngINISupp.PMenuOnClick(Sender: TObject);
var
  MLFN: String;
begin
  with Sender as TMenuItem do
    begin
      MLFN := Name + '.lng';
      System.Delete(MLFN, 1, 1);
      SetFileName(ExtractFileDir(ParamStr(0)) + '\' + MLFN);
      Open;
    end;
end;

procedure TLngINISupp.FindCaptions;
var
  i,j,k:Integer;
  Source: TComponent;
begin
  for i := 0 to self.Owner.Owner.ComponentCount - 1 do
   begin
    for j := 0 to self.Owner.Owner.Components[i].ComponentCount - 1 do
     begin
       Source := self.Owner.Owner.Components[i].Components[j];
       if Source is TButton then                                     //Buttons
       with Source as TButton do
          VerifyValue(Owner.Name, Name, Caption)
       else if Source is TSpeedButton then                           //SpeedButton
       with Source as TSpeedButton do
          VerifyValue(Owner.Name, Name, Caption)
       else if Source is TLabel then                                 //Labels
       with Source as TLabel do
          VerifyValue(Owner.Name, Name, Caption)
       else if Source is TOpenDialog then                            //Open & Save Dialogs
       with Source as TOpenDialog do
          VerifyValue(Owner.Name, Name, Title)
       else if Source is TMenuItem then                              //Menus
       with Source as TMenuItem do
          VerifyValue(Owner.Name, Name, Caption)
       else if Source is TCheckBox then                              //CheckBoxes
       with Source as TCheckBox do
          VerifyValue(Owner.Name, Name, Caption)
       else if Source is TGroupBox then                              //GroupBoxes
       with Source as TGroupBox do
          VerifyValue(Owner.Name, Name, Caption)
       else if Source is TRadioButton then                           //RadioButtons
       with Source as TRadioButton do
          VerifyValue(Owner.Name, Name, Caption)
       else if Source is TRadioGroup then                            //RadioGroups
       with Source as TRadioGroup do
          VerifyValue(Owner.Name, Name, Caption)
       else if Source is TPanel then                                 //Panels
       with Source as TPanel do
          VerifyValue(Owner.Name, Name, Caption)
       else if Source is TTabSheet then                              //TabSheets
       with Source as TTabSheet do
          VerifyValue(Owner.Name, Name, Caption)
       else if Source is TStatusBar then                             //TStatusBars
       with Source as TStatusBar do
           for k := 0 to Panels.Count - 1 do
            VerifyValue(Owner.Name, Name + '.Panels[' + IntToStr(k)
                + ']', Panels[k].Text)
       else if Source is TStaticText then                            //StaticTexts
       with Source as TStaticText do
          VerifyValue(Owner.Name, Name, Caption)
     end;
   end;
end;

procedure TLngINISupp.ReadCaptions;
var
Sections, Values: TStrings;
i, ii, j, jj, sbp, k: Integer;
Source: TComponent;
sbn: string;
begin
  Sections := TStringList.Create;
  Values   := TStringList.Create;
  AppIni := TIniFile.Create(FFileName);
  AppIni.ReadSections(Sections);
  for i := 0 to Sections.Count - 1 do
    begin
       AppIni.ReadSection(Sections[i], Values);
       for j := 0 to Values.Count - 1 do
         begin
           for ii := 0 to self.Owner.Owner.ComponentCount - 1 do
             begin
               for jj := 0 to self.Owner.Owner.Components[ii].ComponentCount - 1 do
                 begin
                   Source := self.Owner.Owner.Components[ii].Components[jj];
                   if self.Owner.Owner.Components[ii].Name = Sections[i] then             //Buttons
                     if Source is TButton then
                       if Source.Name = Values[j] then
                         with Source as TButton do
                           Caption := AppIni.ReadString(Sections[i], Values[j], 'ERROR');
                   if self.Owner.Owner.Components[ii].Name = Sections[i] then             //SpeedButtons
                     if Source is TSpeedButton then
                       if Source.Name = Values[j] then
                         with Source as TSpeedButton do
                           Caption := AppIni.ReadString(Sections[i], Values[j], 'ERROR');
                   if self.Owner.Owner.Components[ii].Name = Sections[i] then             //Labels
                     if Source is TLabel then
                       if Source.Name = Values[j] then
                         with Source as TLabel do
                           Caption := AppIni.ReadString(Sections[i], Values[j], 'ERROR');
                   if self.Owner.Owner.Components[ii].Name = Sections[i] then             //Open & Save Dialogs
                     if Source is TOpenDialog then
                       if Source.Name = Values[j] then
                         with Source as TOpenDialog do
                           Title := AppIni.ReadString(Sections[i], Values[j], 'ERROR');
                   if self.Owner.Owner.Components[ii].Name = Sections[i] then             //Menus
                     if Source is TMenuItem then
                       if Source.Name = Values[j] then
                         with Source as TMenuItem do
                           Caption := AppIni.ReadString(Sections[i], Values[j], 'ERROR');
                   if self.Owner.Owner.Components[ii].Name = Sections[i] then             //CheckBoxes
                     if Source is TCheckBox then
                       if Source.Name = Values[j] then
                         with Source as TCheckBox do
                           Caption := AppIni.ReadString(Sections[i], Values[j], 'ERROR');
                   if self.Owner.Owner.Components[ii].Name = Sections[i] then             //GroupBoxes
                     if Source is TGroupBox then
                       if Source.Name = Values[j] then
                         with Source as TGroupBox do
                           Caption := AppIni.ReadString(Sections[i], Values[j], 'ERROR');
                   if self.Owner.Owner.Components[ii].Name = Sections[i] then             //RadioButtons
                     if Source is TRadioButton then
                       if Source.Name = Values[j] then
                         with Source as TRadioButton do
                           Caption := AppIni.ReadString(Sections[i], Values[j], 'ERROR');
                   if self.Owner.Owner.Components[ii].Name = Sections[i] then             //RadioGroups
                     if Source is TRadioGroup then
                       if Source.Name = Values[j] then
                         with Source as TRadioGroup do
                           Caption := AppIni.ReadString(Sections[i], Values[j], 'ERROR');
                   if self.Owner.Owner.Components[ii].Name = Sections[i] then             //Panels
                     if Source is TPanel then
                       if Source.Name = Values[j] then
                         with Source as TPanel do
                           Caption := AppIni.ReadString(Sections[i], Values[j], 'ERROR');
                   if self.Owner.Owner.Components[ii].Name = Sections[i] then             //TabSheets
                     if Source is TTabSheet then
                       if Source.Name = Values[j] then
                         with Source as TTabSheet do
                           Caption := AppIni.ReadString(Sections[i], Values[j], 'ERROR');
                   if self.Owner.Owner.Components[ii].Name = Sections[i] then             //StaticTexts
                     if Source is TStaticText then
                       if Source.Name = Values[j] then
                         with Source as TStaticText do
                           Caption := AppIni.ReadString(Sections[i], Values[j], 'ERROR');
                   if self.Owner.Owner.Components[ii].Name = Sections[i] then             //CheckBoxes
                     if Source is TStatusBar then
                       begin
                         sbn := '';
                         sbp := 0;
                         for k := 1 to Length(Values[j]) do
                           begin
                             if Values[j][k] = '.' then
                               break
                             else
                               sbn := sbn + Values[j][k];
                           end;
                         for k := 1 to Length(Values[j]) do
                           begin
                             if Values[j][k] = '[' then
                               sbp := StrToInt(Values[j][k + 1]);
                           end;
                         if Source.Name = sbn then
                           with Source as TStatusBar do
                             Panels[sbp].Text := AppIni.ReadString(Sections[i], Values[j], 'ERROR');
                       end;
                 end;
             end;
         end;
    end;
  AppIni.Free;
  Values.Free;
  Sections.Free;
end;

procedure TLngINISupp.CheckFile(FN: TFileName);
var
 strm: TMemoryStream;
begin
  strm := TMemoryStream.Create;
  if FN = '' then
    begin
      ShowMessage('ERROR!!!' + #13#10 + 'File not preset!');
      FNP := true;
    end
  else
    begin
      try
        FNP := false;
        strm.LoadFromFile(FN);
       except
        ShowMessage('WARNING!!!' + #13#10 + ' Language File Not Found! Its now creating a new!');
        FNF := true;
      end;
    end;
  strm.Free;
end;

procedure TLngINISupp.Save;
begin
  CheckFile(FFileName);
  if FNP = true then abort;
  FNF := false;
  VV := true;
  FindCaptions;
end;

procedure TLngINISupp.FindLngFilesM;
var
  iii: Integer;
  sr: TSearchRec;
  FileAttrs: Integer;
  lfn: string;
begin
  FileAttrs := faReadOnly;
  FileAttrs := FileAttrs + faHidden;
  FileAttrs := FileAttrs + faSysFile;
  FileAttrs := FileAttrs + faVolumeID;
  FileAttrs := FileAttrs + faDirectory;
  FileAttrs := FileAttrs + faArchive;
  FileAttrs := FileAttrs + faAnyFile;
  if FindFirst(ExtractFileDir(ParamStr(0))+'\*.lng', FileAttrs, sr) = 0 then
  begin
    with LngFiles do
    begin
      if (sr.Attr and FileAttrs) = sr.Attr then
      begin
        Add(sr.Name);
      end;
      while FindNext(sr) = 0 do
      begin
        if (sr.Attr and FileAttrs) = sr.Attr then
        begin
        Add(sr.Name);
        end;
      end;
      FindClose(sr);
    end;
  end;
  Lng := TMenuItem.Create(self);
  Lng.Name := 'LngItem';
  Lng.Caption := 'Language';
  FMenu.Items.Insert(FMenu.Items.Count, Lng);
  for iii := 0 to LngFiles.Count - 1 do
   begin
     lfn := LngFiles[iii];
     AppIni := TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\' + lfn);
     delete(lfn, pos('.', lfn), 4);
     Child := TMenuItem.Create(self);
     Child.Name := lfn;
     Child.Caption := AppIni.ReadString('Language', 'Language', 'ERROR');
     Child.OnClick := MenuOnClick;
     Lng.Add(Child);
     AppIni.Free;
   end;
  MC := true;
end;

procedure TLngINISupp.FindLngFilesP;
var
  iii: Integer;
  sr: TSearchRec;
  FileAttrs: Integer;
  lfn: string;
begin
  FileAttrs := faReadOnly;
  FileAttrs := FileAttrs + faHidden;
  FileAttrs := FileAttrs + faSysFile;
  FileAttrs := FileAttrs + faVolumeID;
  FileAttrs := FileAttrs + faDirectory;
  FileAttrs := FileAttrs + faArchive;
  FileAttrs := FileAttrs + faAnyFile;
  if FindFirst(ExtractFileDir(ParamStr(0))+'\*.lng', FileAttrs, sr) = 0 then
  begin
    with LngFiles do
    begin
      if (sr.Attr and FileAttrs) = sr.Attr then
      begin
        Add(sr.Name);
      end;
      while FindNext(sr) = 0 do
      begin
        if (sr.Attr and FileAttrs) = sr.Attr then
        begin
        Add(sr.Name);
        end;
      end;
      FindClose(sr);
    end;
  end;
  PLng := TMenuItem.Create(self);
  PLng.Name := 'PLngItem';
  PLng.Caption := 'Language';
  FPMenu.Items.Insert(FPMenu.Items.Count, PLng);
  for iii := 0 to LngFiles.Count - 1 do
   begin
     lfn := LngFiles[iii];
     AppIni := TIniFile.Create(ExtractFileDir(ParamStr(0)) + '\' + lfn);
     delete(lfn, pos('.', lfn), 4);
     PChild := TMenuItem.Create(self);
     PChild.Name := 'P' + lfn;
     PChild.Caption := AppIni.ReadString('Language', 'Language', 'ERROR');
     PChild.OnClick := PMenuOnClick;
     PLng.Add(PChild);
     AppIni.Free;
   end;
  PC := true;
end;

end.
