unit uRBExportTimetable;

interface

uses sysutils, classes, math, utools, uglobaldef, graphics, DateUtils, uRBTrain, tabout;

type
     TRBTimetableItem = class(TCollectionItem)
       public
         position: integer; // in meter
         name: string;
         arrivaltime,
         departtime: double;
         stop: boolean;
         vmax: integer;
     end;

     TRBExportTimetable = class(TCollection)
       public
         Name: String;
         Train: TRBTrain;
         procedure AddStation(_pos: integer; const _name: string; _arrive,_depart: double; _stop: boolean=true; _vmax: integer=0);
         procedure RenderToBitmap(bitmap: TBitmap);
         procedure ExportAsBitmap(const filename: string);
     end;

implementation

procedure TRBExportTimetable.AddStation(_pos: integer; const _name: string; _arrive,_depart: double; _stop: boolean=true; _vmax: integer=0);
var ti: TRBTimetableItem;
begin
  ti := Add() as TRBTimetableItem;
  ti.position := _pos;
  ti.name := _name;
  ti.arrivaltime := _arrive;
  ti.departtime := _depart;
  ti.stop := _stop;
  ti.vmax := _vmax;
end;

procedure TRBExportTimetable.RenderToBitmap(bitmap: TBitmap);
var s: string;
    spalte_x: array[1..6] of integer;
    zeile,i,last_v: integer;
    ti: TRBTimetableItem;
begin
  last_v:=-999;
  with bitmap.canvas do
  begin
    Brush.Color := clWhite;
    Brush.Style := bsSolid;
    FillRect(ClipRect);

    Font.Color := clBlack;
    Font.Name := 'Arial';
    Font.Size := 14;
    Font.Style := [fsBold];
    // Timetable name
    TextOut(5,5,name);
    // Train name and data
    if((train<>nil)and(train.name<>'')) then
    begin
      TextOut(512-TextWidth(Train.name)-5,5,train.name);
      Font.Size := 10;
      Font.style := [];
      TextOut(5,26,inttostr(round(Train.GetTotalUnitWeight))+' t');
      s := 'vmax='+inttostr(train.GetMaxSpeed)+' km/h';
      TextOut(512-TextWidth(s)-5,26,s);
    end;
    // table headers
    spalte_x[1]:=3;
    spalte_x[2]:=55;
    spalte_x[3]:=105;
    spalte_x[4]:=408;
    spalte_x[5]:=458;
    spalte_x[6]:=508;
    zeile := 40;
    Pen.Color:=clBlack;
    Pen.Width:=1;
    Pen.Style:=psSolid;
    for i:=1 to 6 do
    begin
      MoveTo(spalte_x[i],zeile); LineTo(spalte_x[i],511);
    end;
    TextOut(spalte_x[1]+2,zeile+2,'km');
    TextOut(spalte_x[2]+2,zeile+2,'vmax');
    TextOut(spalte_x[3]+2,zeile+2,'Station/Signal');
    TextOut(spalte_x[4]+2,zeile+2,'arrive');
    TextOut(spalte_x[5]+2,zeile+2,'depart');
    inc(zeile,16);
    MoveTo(spalte_x[1],zeile); LineTo(spalte_x[6],zeile);
    MoveTo(spalte_x[1],zeile-16); LineTo(spalte_x[6],zeile-16);
    inc(zeile,3);
//    TextFlags := 0; 
    for i:=0 to Count-1 do
    begin
      ti := items[i] as TRBTimetableItem;
      // km
      s:=floattostrPoint(ti.position/1000,1);
      TextOut(spalte_x[2]-2-textwidth(s),zeile,s);
      // vmax
      if (i<>count-1)and(ti.vmax<>0)and(ti.vmax<>last_v) then
      begin
        s:=inttostr(ti.vmax);
        TextOut(spalte_x[3]-2-textwidth(s),zeile,s);
        last_v := ti.vmax;
        if i<>0 then begin MoveTo(spalte_x[2],zeile-1); LineTo(spalte_x[3],zeile-1); end;
      end;
      // station
      TextOut(spalte_x[3]+2,zeile,ti.name);
      // arrival
      if ti.stop then
      begin
        s:=floattostrPoint( HourOf(ti.arrivaltime) + MinuteOf(ti.arrivaltime)/100 + SecondOf(ti.arrivaltime)/10000, 2 );
        TextOut(spalte_x[5]-2-textwidth(s),zeile,s);
      end;
      // departure
      if(i<>count-1) then
      begin
        s:=floattostrPoint( HourOf(ti.departtime) + MinuteOf(ti.departtime)/100 + SecondOf(ti.departtime)/10000, 2 );
        TextOut(spalte_x[6]-2-textwidth(s),zeile,s);
      end;
      inc(zeile,TextHeight(s));
    end;
    // RB-image
    Draw(511-FormAbout.Image1.Picture.Bitmap.Width,511-FormAbout.Image1.Picture.Bitmap.Height,FormAbout.Image1.Picture.Bitmap);
  end;


end;

procedure TRBExportTimetable.ExportAsBitmap(const filename: string);
var bmp: TBitmap;
begin
  bmp := TBitmap.create;
  bmp.Width :=512;
  bmp.Height := 512;
  bmp.PixelFormat := pf8Bit;
  RenderToBitmap(bmp);
  ForceDirectories(extractfilepath(filename));
  bmp.SaveToFile(filename);
  bmp.free;
end;

end.
