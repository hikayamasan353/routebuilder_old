unit uRBTo3DStateWorld;

interface

uses sysutils, classes,
     windows,
     uRBToWorld,
     uRBProject,
     uRBObject,
     uRBConnection,
     uRBPoint,
     uRBGrid,
     uRBB3DObject, uRB3DObject,
     toptions,
     uGlobalDef,
     uTools,
     uTrackTypes,
     StateD;

type
     TRBTo3DStateWorld = class(TRBToWorld)
       public
         incomplete: boolean;
         BasePath: string;
         constructor Create;
         destructor Destroy;
         procedure Clear;
         function AddObject(obj: TRBObject; x,y,z: double; wx,wy,wz: double): boolean;
         function AddProject(project: TRBProject;area1,area2: TDoublePoint): boolean;
         function SaveToFile(const s: string): boolean;
     end;

implementation

constructor TRBTo3DStateWorld.Create;
begin
  inherited;
  Clear();
end;

destructor TRBTo3DStateWorld.Destroy;
begin
inherited;
end;



procedure TRBTo3DStateWorld.Clear;
begin
  // leere World erstellen
  if STATE_engine_is_engine_empty()<>0 then
    STATE_engine_load_world(nil, nil, nil, EDITOR_MODE);
  STATE_engine_set_picture_quality(1000000);
end;

function TRBTo3DStateWorld.AddObject(obj: TRBObject; x,y,z: double; wx,wy,wz: double): boolean;
var pol_point: array[0..5] of double;
    center,loc: array[0..2] of double;
    box: array[0..1,0..2] of double;
    transparent_index,i,j,group,coord_index: integer;
    poly,bmp: DWORD;
    face: TRB3DFace;
    filename: string;
    b3d: TRBB3DObject;
    point: TRB3DMeshPoint;
begin
   b3d:= TRBB3DObject.Create;
   filename := BasePath+formOptions.GetObjectFolder()+ '\'+obj.GetPath;
   if not b3d.LoadFromFileAndParse(filename) then begin b3d.free; exit; end;

  incomplete := false;
  loc[0]:=x; loc[1]:=y; loc[2]:=z;
  pol_point[3] := 0;
  pol_point[4] := 0;
  pol_point[5] := 255;
  group := STATE_group_create('b3d');
  for i:=0 to b3d.GetFaceCount-1 do
  begin
    poly := STATE_polygon_create();
    face := b3d.GetFace(i);
    for j:=0 to face.GetPointCount-1 do
    begin
      point := face.GetPoint(j);
      point.Get(pol_point[0],pol_point[1],pol_point[2]);
      coord_index := point.GetIndex;
      face.GetBitmapCoord(coord_index,pol_point[3],pol_point[4],pol_point[5]);
      STATE_polygon_add_point(poly, pol_point);
    end;
    if face.Bitmap=nil then
      STATE_polygon_set_color_fill(poly,face.Color.R,face.Color.G,face.Color.B)
    else
    begin
      transparent_index := -1;
      filename:= BasePath+formOptions.GetObjectFolder()+ '\'+obj.Folder+'\'+face.bitmap.filename;
      bmp := STATE_bitmap_load(pchar(filename), -1);
      if bmp<>0 then
      begin
       if face.bitmap.TransparentColor.isset then
        transparent_index :=  STATE_bitmap_rgb_color_to_index(bmp,
          face.bitmap.TransparentColor.R,face.bitmap.TransparentColor.G,face.bitmap.TransparentColor.B);
       bmp := STATE_bitmap_load(pchar(filename), transparent_index);
       STATE_polygon_set_bitmap_fill(poly,bmp);
      end
      else
      begin
        incomplete := true;
      end;
    end;
    STATE_engine_add_polygon(poly);
    STATE_polygon_set_group(poly,group);
  end;
  STATE_group_rotate(group,wx,WORLD_SPACE,0);
  STATE_group_rotate(group,wy,WORLD_SPACE,1);
  STATE_group_rotate(group,wz,WORLD_SPACE,2);
  STATE_group_move(group,loc,WORLD_SPACE);
//  STATE_group_set_location(group,loc);
  // get center (group wurde dort positioniert)
//  STATE_group_get_center_of_mass(group,center);
{  STATE_group_get_bounding_box(group,box);
  center[0] :=0;//-box[0,0];
  center[1] :=0;//-box[0,1];
  center[2] :=-box[0,2];
  // verschiebe entsprechend
  STATE_group_move(group,center,WORLD_SPACE);}
  b3d.free;
end;

function TRBTo3DStateWorld.AddProject(project: TRBProject;area1,area2: TDoublePoint): boolean;
var i,j,
    curve: integer;
    x,y,z,wx,wy,wz: double;
    obj,obj1: TRBObject;
    point1: TRBPoint;
    conn: TRBConnection;
    grid: TRBGrid;
    s: string;
    in_grid: boolean;
begin
  // für alle Objekte im Projekt aufrufen:
  //  to3DState.AddObject(obj,x,y,z,wx,wy,wz);
  clear;
  // connections
  for i:=0 to project.Connections.count-1 do
  begin
    if assigned(OnProgress) then
      OnProgress((i*100) div project.Connections.count);
    conn := project.connections[i] as TRBConnection;
    in_grid := false;
    {for j:=0 to project.Grids.count-1 do
    begin
      grid := project.grids[j] as TRBGrid;
      if grid.IsConnInGrid(conn.id) then
      begin
        in_grid := true;
        curve := 0;
        s := FormTrackTypes.GetTrackDefinitionObject(conn.Texture,curve);
        obj := TRBObject.Create(s);
        point1 := conn.P1;
        AddObject(obj,-point1.point.y,point1.point.x,point1.height,0,0,grid.GridAngle-90);
        // angeflanschte Objekte
        if conn.TSOLeft<>'' then
        begin
          obj1 := TRBObject.Create('walls',conn.TSOLeft+'_l.b3d');
          AddObject(obj1,-point1.point.y,point1.point.x,point1.Height+conn.TSOOffsetLeft,0,0,grid.GridAngle-90);
          obj1.free;
        end;
        if conn.TSORight<>'' then
        begin
          obj1 := TRBObject.Create('walls',conn.TSORight+'_r.b3d');
          AddObject(obj1,-point1.point.y,point1.point.x,point1.Height+conn.TSOOffsetRight,0,0,grid.GridAngle-90);
          obj1.free;
        end;
        if conn.WallLeft<>'' then
        begin
          obj1 := TRBObject.Create('walls',conn.WallLeft+'_l.b3d');
          AddObject(obj1,-point1.point.y,point1.point.x,point1.Height,0,0,grid.GridAngle-90);
          obj1.free;
        end;
        if conn.WallRight<>'' then
        begin
          obj1 := TRBObject.Create('walls',conn.WallRight+'_l.b3d');
          AddObject(obj1,-point1.point.y,point1.point.x,point1.Height,0,0,grid.GridAngle-90);
          obj1.free;
        end;

        obj.free;
      end;
    end;
    if not in_grid then     }
    if IsDoublePointInRect(conn.p1.point,area1,area2) and IsDoublePointInRect(conn.p2.point,area1,area2)  then
    begin
      //
        s := FormTrackTypes.GetTrackDefinitionObject(conn.Texture,curve);
        obj := TRBObject.Create(s);
        point1 := conn.P1;
        AddObject(obj,-point1.point.y,point1.point.x,conn.Height,0,0,conn.GetAngle(nil)-90);
        obj.free;
        // angeflanschte Objekte
        if conn.TSOLeft<>'' then
        begin
          s := conn.TSOLeft;
          if CountTokens(s,',')>1 then s := StrGetToken(s,',',random(CountTokens(s,','))+1);
          obj1 := TRBObject.Create('walls',s+'_l.b3d');
          AddObject(obj1,-point1.point.y,point1.point.x,point1.Height+conn.TSOOffsetLeft,0,0,conn.GetAngle(nil)-90);
          obj1.free;
        end;
        if conn.TSORight<>'' then
        begin
          s := conn.TSORight;
          if CountTokens(s,',')>1 then s := StrGetToken(s,',',random(CountTokens(s,','))+1);
          obj1 := TRBObject.Create('walls',s+'_r.b3d');
          AddObject(obj1,-point1.point.y,point1.point.x,point1.Height+conn.TSOOffsetRight,0,0,conn.GetAngle(nil)-90);
          obj1.free;
        end;
        if conn.WallLeft<>'' then
        begin
          s := conn.WallLeft;
          if CountTokens(s,',')>1 then s := StrGetToken(s,',',random(CountTokens(s,','))+1);
          obj1 := TRBObject.Create('walls',s+'_l.b3d');
          AddObject(obj1,-point1.point.y,point1.point.x,point1.Height,0,0,conn.GetAngle(nil)-90);
          obj1.free;
        end;
        if conn.WallRight<>'' then
        begin
          s := conn.WallRight;
          if CountTokens(s,',')>1 then s := StrGetToken(s,',',random(CountTokens(s,','))+1);
          obj1 := TRBObject.Create('walls',s+'_r.b3d');
          AddObject(obj1,-point1.point.y,point1.point.x,point1.Height,0,0,conn.GetAngle(nil)-90);
          obj1.free;
        end;
        if conn.PolesType<>'' then
        begin
          s := conn.PolesType;
          obj1 := TRBObject.Create('poles',s);
          if conn.PolesPos=-1 then
            AddObject(obj1,-point1.point.y,point1.point.x,point1.Height,0,0,conn.GetAngle(nil)+90)
          else
            AddObject(obj1,-point1.point.y,point1.point.x,point1.Height,0,0,conn.GetAngle(nil)-90);
          obj1.free;
        end;
        if conn.PlatformType<>'' then
        begin
          s := conn.PlatformType+PlatformPosChar(conn.PlatformPos)+'.b3d';
          obj1 := TRBObject.Create('platforms',s);
          AddObject(obj1,-point1.point.y,point1.point.x,point1.Height,0,0,conn.GetAngle(nil)-90);
          obj1.free;
          s := conn.PlatformType+'C'+PlatformPosChar(conn.PlatformPos)+'.b3d';
          obj1 := TRBObject.Create('platforms',s);
          AddObject(obj1,-point1.point.y,point1.point.x,point1.Height,0,0,conn.GetAngle(nil)-90);
          obj1.free;
          if conn.RoofType<>'' then
          begin
            s := conn.RoofType+PlatformPosChar(conn.PlatformPos)+'.b3d';
            obj1 := TRBObject.Create('platforms',s);
            AddObject(obj1,-point1.point.y,point1.point.x,point1.Height,0,0,conn.GetAngle(nil)-90);
            obj1.free;
            s := conn.RoofType+'C'+PlatformPosChar(conn.PlatformPos)+'.b3d';
            obj1 := TRBObject.Create('platforms',s);
            AddObject(obj1,-point1.point.y,point1.point.x,point1.Height,0,0,conn.GetAngle(nil)-90);
            obj1.free;
          end;
        end;
        for j:=0 to Project.Freeobjects.count-1 do
        begin
          obj1 := Project.Freeobjects[j] as TRBObject;
          // TODO Offset und Winkel!!!!!!!!!!!!!!!!
          if obj1.boundtoConnID=conn.id then
             AddObject(obj1,-point1.point.y,point1.point.x,point1.Height+obj1.yoffset,0,0,conn.GetAngle(nil)-90);
        end;

    end;
  end;

  // freeobj
  for i:=0 to project.Freeobjects.count-1 do
  begin
    obj := project.Freeobjects[i] as TRBObject;
    if assigned(OnProgress) then
      OnProgress((i*100) div project.Freeobjects.count);
    if IsDoublePointInRect(obj.point,area1,area2) then
      AddObject(obj,-obj.point.y,obj.point.x,obj.yoffset,0,0,obj.angle);
  end;


end;

function TRBTo3DStateWorld.SaveToFile(const s: string): boolean;
begin
  STATE_engine_save(pChar(s),0,SAVE_BITMAP_AS_JBM or SAVE_RELEASE);
end;

end.

