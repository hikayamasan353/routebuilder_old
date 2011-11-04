program RB1;

uses
  Forms,
  tmain in 'tmain.pas' {FormMain},
  tWizard_CreateProject in 'tWizard_CreateProject.pas' {CreateProj_Wizard},
  tBveFolder in 'tBveFolder.pas' {FormSetBveFolder},
  toptions in 'toptions.pas' {FormOptions},
  taddons in 'taddons.pas' {FormAddons},
  tabout in 'tabout.pas' {FormAbout},
  uTrackProperties in 'uTrackProperties.pas' {FormTrackProperties},
  uGlobalDef in 'uGlobalDef.pas',
  uRBProject in 'uRBProject.pas',
  uEditorFrame in 'uEditorFrame.pas' {FrmEditor: TFrame},
  ttrain in 'ttrain.pas' {FormTrain},
  uRouteDefinitionsForm in 'uRouteDefinitionsForm.pas' {FormRouteDefinitions},
  tRBExport in 'tRBExport.pas',
  texport in 'texport.pas' {FormExport},
  uObjectsFrame in 'uObjectsFrame.pas' {FrmObjects: TFrame},
  uObjectsForm in 'uObjectsForm.pas' {FormObjects},
  uRBWallList in 'uRBWallList.pas',
  uStationsForm in 'uStationsForm.pas' {FormStations},
  uRBMiniMap in 'uRBMiniMap.pas',
  uRBStation in 'uRBStation.pas',
  uBGMapForm in 'uBGMapForm.pas' {FormBGMap},
  uRBPoint in 'uRBPoint.pas',
  uNewBGImageForm in 'uNewBGImageForm.pas' {FormNewBGImage},
  uCurrentSituation in 'uCurrentSituation.pas',
  uRBConnection in 'uRBConnection.pas',
  uRBConnectionList in 'uRBConnectionList.pas',
  uRBRouteDefinition in 'uRBRouteDefinition.pas',
  uProjectProperties in 'uProjectProperties.pas' {FormProjectProperties},
  uSelectObjectForm in 'uSelectObjectForm.pas' {FormSelectObject},
  uwelcome in 'uwelcome.pas' {FormWelcome},
  uRBObject in 'uRBObject.pas',
  uTools in 'uTools.pas',
  uFreeObjectPropertiesForm in 'uFreeObjectPropertiesForm.pas' {FormFreeObjProperties},
  RBAddonInterface in 'RBAddonInterface.pas',
  uAddonFunc in 'uAddonFunc.pas',
  uRBRooflist in 'uRBRooflist.pas',
  uRBTrackDefinition in 'uRBTrackDefinition.pas',
  uMoveEverything in 'uMoveEverything.pas' {FormMoveEverything},
  tPackager in 'tPackager.pas' {FormPackage},
  uPredefinedObjectsForm in 'uPredefinedObjectsForm.pas' {FormPredefinedObjects},
  uRBPlatformlist in 'uRBPlatformlist.pas',
  tcreatepackage in 'tcreatepackage.pas' {FormCreatePackage},
  uTrackTypes in 'uTrackTypes.pas' {FormTrackTypes},
  uReplaceForm in 'uReplaceForm.pas' {FormReplace},
  uRBGroundTexturelist in 'uRBGroundTexturelist.pas',
  uRBCatenaryPolelist in 'uRBCatenaryPoleList.pas',
  uRBGridsForm in 'uRBGridsForm.pas' {FormGrids},
  uRBGrid in 'uRBGrid.pas',
  StateD in 'STATED.pas',
  uGridTracks in 'uGridTracks.pas' {FormGridTracks},
  tRbTimetable in 'tRbTimetable.pas',
  ttimetable in 'ttimetable.pas' {FormTimetables},
  uRBTrain in 'uRBTrain.pas',
  uRBToWorld in 'uRBToWorld.pas',
  uRBTo3DStateWorld in 'uRBTo3DStateWorld.pas',
  ttimetablesRD in 'ttimetablesRD.pas' {FormTimetablesRD},
  uChangePropertyForm in 'uChangePropertyForm.pas' {FormChangeProperty},
  URBObjCache in 'URBObjCache.pas',
  uRBSignal in 'uRBSignal.pas',
  uRBSignalsForm in 'uRBSignalsForm.pas' {FormSignals},
  uRBSaveRegionForm in 'uRBSaveRegionForm.pas' {FormSaveRegion},
  uRBRegionBrowser in 'uRBRegionBrowser.pas' {FormRegionBrowser},
  uRBTrackObject in 'uRBTrackObject.pas',
  uPointHeightForm in 'uPointHeightForm.pas' {FormPointHeight},
  uRBExportTimetable in 'uRBExportTimetable.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'RouteBuilder for openBVE';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormOptions, FormOptions);
  Application.CreateForm(TCreateProj_Wizard, CreateProj_Wizard);
  Application.CreateForm(TFormAddons, FormAddons);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.CreateForm(TFormTrackProperties, FormTrackProperties);
  Application.CreateForm(TFormTrain, FormTrain);
  Application.CreateForm(TFormRouteDefinitions, FormRouteDefinitions);
  Application.CreateForm(TFormExport, FormExport);
  Application.CreateForm(TFormObjects, FormObjects);
  Application.CreateForm(TFormStations, FormStations);
  Application.CreateForm(TFormBGMap, FormBGMap);
  Application.CreateForm(TFormNewBGImage, FormNewBGImage);
  Application.CreateForm(TFormProjectProperties, FormProjectProperties);
  Application.CreateForm(TFormSelectObject, FormSelectObject);
  Application.CreateForm(TFormWelcome, FormWelcome);
  Application.CreateForm(TFormFreeObjProperties, FormFreeObjProperties);
  Application.CreateForm(TFormMoveEverything, FormMoveEverything);
  Application.CreateForm(TFormPackage, FormPackage);
  Application.CreateForm(TFormPredefinedObjects, FormPredefinedObjects);
  Application.CreateForm(TFormCreatePackage, FormCreatePackage);
  Application.CreateForm(TFormTrackTypes, FormTrackTypes);
  Application.CreateForm(TFormReplace, FormReplace);
  Application.CreateForm(TFormGrids, FormGrids);
  Application.CreateForm(TFormGridTracks, FormGridTracks);
  Application.CreateForm(TFormTimetables, FormTimetables);
  Application.CreateForm(TFormTimetablesRD, FormTimetablesRD);
  Application.CreateForm(TFormChangeProperty, FormChangeProperty);
  Application.CreateForm(TFormSignals, FormSignals);
  Application.CreateForm(TFormPointHeight, FormPointHeight);
  Application.Run;

end.
