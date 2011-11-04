unit CylinderCreator;

interface

uses sysutils,classes;

type TCylinderCreator=class(TStringlist)
       public
         procedure CreateCylinder(facecount,radius,height: integer; const imgfile: string);
     end;

implementation

procedure TCylinderCreator.CreateCylinder(facecount,radius,height: integer; const imgfile: string);
var i: integer;
    a,x,z: double;
    s: string;
    comma: char;
begin
  clear;
  comma := DecimalSeparator;
  DecimalSeparator := '.';

  add(';description=cylinder automatically created by RBACylinderCreator');
  add(';copyright=to be freely used in free BVE routes');

  add('');

  add('[MeshBuilder]');


  for i:=0 to facecount do
  begin
    a := 2*pi*i/facecount-pi;
    x := cos(a)*radius;
    z := sin(a)*radius;

    s := format('Vertex %f,%f,%f',[x,0.0,z]);
    add(s);
    s := format('Vertex %f,%f,%f',[x,1.0*height,z]);
    add(s);

  end;

  for i:=0 to facecount do
  begin
    s := 'Face ';
    s := s + inttostr((i*2+1) mod (facecount*2)) + ',';
    s := s + inttostr((i*2+3) mod (facecount*2)) + ',';
    s := s + inttostr((i*2+2) mod (facecount*2)) + ',';
    s := s + inttostr((i*2+0) mod (facecount*2));
    add(s);
  end;

  //add('color 100,200,255');

  add('');

  add('[Texture]');
  add('Load ' + imgfile);

  x := 0;
  for i:=0 to facecount do
  begin
    s := 'Coordinates '+inttostr(i*2) +','+format('%f',[x])+',1';
    add(s);
    s := 'Coordinates '+inttostr(i*2+1) +','+format('%f',[x])+',0';
    add(s);
    x := x + 1/facecount;
  end;

  DecimalSeparator := comma;

end;

end.
