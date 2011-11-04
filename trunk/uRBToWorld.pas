unit uRBToWorld;

interface

uses sysutils, classes,
     uRBObject,
     uRBProject,
     uGlobalDef;

type
     TRBToWorld = class
       public
         OnProgress: TGetIntProc;
         constructor Create;
         destructor Destroy;
         procedure Clear; virtual; abstract;
         function AddObject(obj: TRBObject; x,y,z: double; wx,wy,wz: double): boolean; virtual; abstract;
         function AddProject(project: TRBProject): boolean; virtual; abstract;
         function SaveToFile(const s: string): boolean; virtual; abstract;
     end;

implementation

constructor TRBToWorld.Create;
begin
end;

destructor TRBToWorld.Destroy;
begin
end;

end.
