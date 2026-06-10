% script_test_fcn_HandTrace_createMenusFromFile
% This is a script to exercise the function:
% fcn_HandTrace_createMenusFromFile.m
%
% This script was written on 2026_05_15 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% REVISION HISTORY:
%
% As: script_test_fcn_HandTrace_createMenusFromFile
%
% 2026_05_15 by Sean Brennan, sbrennan@psu.edu
% - wrote the code originally using fcn_GetUserInputPath_getUserInputPath
%   % as a starter
%


% TO-DO:
%
% 2026_05_15 by Sean Brennan, sbrennan@psu.edu
% - (fill in items here)


%% Set up the workspace
close all

%% Code demos start here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   _____                              ____   __    _____          _
%  |  __ \                            / __ \ / _|  / ____|        | |
%  | |  | | ___ _ __ ___   ___  ___  | |  | | |_  | |     ___   __| | ___
%  | |  | |/ _ \ '_ ` _ \ / _ \/ __| | |  | |  _| | |    / _ \ / _` |/ _ \
%  | |__| |  __/ | | | | | (_) \__ \ | |__| | |   | |___| (_) | (_| |  __/
%  |_____/ \___|_| |_| |_|\___/|___/  \____/|_|    \_____\___/ \__,_|\___|
%
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Demos%20Of%20Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 1

close all;
fprintf(1,'Figure: 1XXXXXX: DEMO cases - all are interactive so commented out\n');



%% DEMO case: basic example
figNum = 10001;
titleString = sprintf('DEMO case: basic example ');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;


% Create a temporary file with menu definitions
txt = [
    "Signs_Green_Go"
	"Waypoints"
    "Segments"
    "Paints_Red"
	"Paints"
];

fname = "menu_def.txt";
writelines(txt, fname);

% Create a figure and build menus from the file
figHandle = figure('Name', 'Menu Example');
fcn_HandTrace_createMenusFromFile(fname, figHandle);

% Clean up (optional)
delete(fname)


%% DEMO case: basic example
figNum = 10002;
titleString = sprintf('DEMO case: example for Hand Trace');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Format:
% subcategoryName, defaultColorAs1x3, defaultSize, required (anything else is NOT required), patch or segment or points
% subcategoryName, defaultColorAs1x3, defaultSize, isRequiredAs1or0, isRoot0orisAABB1orIsPatch2orisLine3
% Create a temporary file with menu definitions
txt = [
	"AABBs, 0.5*[1 1 1], 5, notRequired, aabb" % Axis-aligned bounding box - these define the area that is being marked
	"AABBs_LocalRegion, 0.5*[1 1 1], 5, notRequired, aabb"  % Local region is the area in which definitions are valid within this file
];

fname = "menu_def.txt";
writelines(txt, fname);

% Create a figure and build menus from the file
figHandle = figure('Name', 'Menu Example');
fcn_plotRoad_plotLL([],[],(figHandle));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);
	
fcn_HandTrace_createMenusFromFile(fname, figHandle);

% Clean up (optional)
delete(fname)

%% DEMO case: advanced example
figNum = 10003;
titleString = sprintf('DEMO case: advanced example for Hand Trace');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Format:
% subcategoryName, defaultColorAs1x3, defaultSize, required (anything else is NOT required), patch or segment or points
% subcategoryName, defaultColorAs1x3, defaultSize, isRequiredAs1or0, isRoot0orisAABB1orIsPatch2orisLine3
% Create a temporary file with menu definitions
txt = [
	"AABBs, 0.5*[1 1 1], 5, notRequired, aabb" % Axis-aligned bounding box - these define the area that is being marked
	"AABBs_LocalRegion, 0.5*[1 1 1], 5, notRequired, aabb"  % Local region is the area in which definitions are valid within this file

    "Regions_Paved_PrimaryRoad, 0.5*[1 1 1], 5, notRequired, patch"
    "Regions_Paved_ShoulderOfRoad, 0.5*[1 1 1], 5, notRequired, patch"
    "Regions_Paved_Driveway, 0.5*[1 1 1], 5, notRequired, patch"
    "Regions_Paved_DrivableSurface, 0.5*[1 1 1], 5, notRequired, patch"
	"Regions_Paved_ParkingLot, 0.5*[1 1 1], 5, notRequired, patch"

	"Regions_UnPaved_PrimaryRoad, [0.588 0.294 0], 5, notRequired, patch"
    "Regions_UnPaved_ShoulderOfRoad, [0.502 0.349 0.263], 5, notRequired, patch"
    "Regions_UnPaved_Driveway, [0.588 0.294 0], 5, notRequired, patch"
    "Regions_UnPaved_DrivableSurface, [0.588 0.294 0], 5, notRequired, patch"
	"Regions_UnPaved_ParkingLot, [0.588 0.294 0], 5, notRequired, patch"
    
    "Nodes_EntrancesToAABB, 0.5*[0 1 0], 20, notRequired, points"
    "Nodes_ExitsFromAABB, 0.5*[1 0 0], 10, notRequired, points"
    "Nodes_ParkingNodes, [0 0 0], 30, notRequired, points"
	
	"NetworkLinkagePaths, [0 0 1], 5, notRequired, directedPath"
    "NetworkLinkagePaths_Centerlines, [0 0 1], 5, notRequired, directedPath"
    "NetworkLinkagePaths_Centerlines_ReferenceCenterlines, [0 0 1], 5, notRequired, directedPath"
    "NetworkLinkagePaths_Centerlines_CenterOfRoad, [0 0 1], 5, notRequired, directedPath"
    "NetworkLinkagePaths_Centerlines_CenterOfPaved, 0.5*[1 1 1], 3, notRequired, directedPath"
    "NetworkLinkagePaths_Centerlines_CenterOfLaneOneWay, 0.5*[0 1 0], 3, notRequired, directedPath"
    "NetworkLinkagePaths_Centerlines_CenterOfLaneTwoWay, 0.5*[1 1 0], 3, notRequired, directedPathTwoWay"
    "NetworkLinkagePaths_Parking, 0.5*[1 1 1], 5, notRequired, directedPathTwoWay"
    "NetworkLinkagePaths_Parking_ParkingAisleOneWay, 0.2*[0 1 0], 3, notRequired, directedPath"
    "NetworkLinkagePaths_Parking_ParkingAisleTwoWay, 0.2*[1 1 0], 3, notRequired, directedPathTwoWay"
    "NetworkLinkagePaths_Parking_ParkingTerminalLine, 0.2*[1 0 0], 3, notRequired, directedPathTwoWay"

    "Objects, 0.5*[1 1 0], 5, notRequired, patch"
    "Objects_TireBarriers, 0.5*[1 1 1], 5, notRequired, patch"
    "Objects_TireBarriers_FrontWheelStops, 0.5*[1 1 0], 5, notRequired, patch"
    "Objects_TireBarriers_Curbs, 0.5*[1 0 0], 5, notRequired, patch"
    "Objects_TireBarriers_NearRoadObject, [1 0 0], 5, notRequired, patch"
    "Objects_TireBarriers_LowProfileDivider, 0.8*[1 1 1], 5, notRequired, patch"

	"Objects_BumperBarriers, [1 0 0], 5, notRequired, patch"
	"Objects_BumperBarriers_ChargingStation, [1 0 0], 5, notRequired, patch"
	"Objects_BumperBarriers_FireHydrant, [1 0 0], 5, notRequired, patch"
	"Objects_BumperBarriers_PermanentBollard, [1 0 0], 5, notRequired, patch"
    "Objects_BumperBarriers_LightPole, [1 0 0], 5, notRequired, patch"
    "Objects_BumperBarriers_TelephonePole, [1 0 0], 5, notRequired, patch"
    "Objects_BumperBarriers_Wall, [1 0 0], 5, notRequired, patch"
    "Objects_BumperBarriers_Building, [1 0 0], 5, notRequired, patch"
    "Objects_BumperBarriers_TensionCable, [1 0 0], 5, notRequired, patch"
    "Objects_BumperBarriers_PlasticVerticalPole, [1 0 0], 5, notRequired, patch"
    "Objects_BumperBarriers_GuardRail, 0.8*[1 1 1], 5, notRequired, patch"
    "Objects_BumperBarriers_ChainFence, 0.8*[1 1 1], 5, notRequired, patch"
    "Objects_BumperBarriers_TreeTrunk, 0.8*[1 1 1], 5, notRequired, patch"
    "Objects_BumperBarriers_Vegetation, 0.8*[0 1 0], 5, notRequired, patch"

	"Objects_AccessBarriers, [0 1 0], 5, notRequired, patch"
	"Objects_AccessBarriers_EntranceGate, [1 0 0], 5, notRequired, patch"
    "Objects_AccessBarriers_ExitGate, [1 0 0], 5, notRequired, patch"
    "Objects_AccessBarriers_RaisedCrosswalk, [1 0 0], 5, notRequired, patch"
    "Objects_AccessBarriers_TemporaryBollard, [1 0 0], 5, notRequired, patch"
    "Objects_AccessBarriers_GasBox, 0.8*[1 1 1], 5, notRequired, patch"
    "Objects_AccessBarriers_WaterBox, 0.8*[1 1 1], 5, notRequired, patch"
    "Objects_AccessBarriers_ElectricalBox, 0.8*[1 1 1], 5, notRequired, patch"
    "Objects_AccessBarriers_EntryKiosk, [1 0 0], 5, notRequired, patch"
    "Objects_AccessBarriers_ExitKiosk, [1 0 0], 5, notRequired, patch"
    "Objects_AccessBarriers_GarageDoor, [1 0 0], 5, notRequired, patch"
    "Objects_AccessBarriers_ParkingMeter, 0.8*[1 1 1], 5, notRequired, patch"
    "Objects_AccessBarriers_ParkingPaymentBox, 0.8*[1 1 1], 5, notRequired, patch"
    "Objects_AccessBarriers_MailBox, 0.8*[1 1 1], 5, notRequired, patch"
    "Objects_AccessBarriers_Dumpster, 0.8*[1 1 1], 5, notRequired, patch"
    "Objects_AccessBarriers_TrashCan, 0.8*[1 1 1], 5, notRequired, patch"
    "Objects_AccessBarriers_GarageDoorAccessPanel, 0.8*[1 1 1], 5, notRequired, patch"
    "Objects_AccessBarriers_BusStopKiosk, 0.8*[1 1 1], 5, notRequired, patch"
	"Objects_AccessBarriers_ChargingStation, [1 0 0], 5, notRequired, patch"
    "Objects_AccessBarriers_FireHydrant, [1 0 0], 5, notRequired, patch"

	"Objects_OverheadBarriers_LowHeadroom, [1 0 0], 5, notRequired, patch"
	"Objects_OverheadBarriers_OverheadObject, [1 0 0], 5, notRequired, patch"
    "Objects_OverheadBarriers_GasLineOverhead, 0.8*[1 1 1], 5, notRequired, patch"
    "Objects_OverheadBarriers_WaterLineOverhead, 0.8*[1 1 1], 5, notRequired, patch"
    "Objects_OverheadBarriers_ElectricalLineOverhead, 0.8*[1 1 1], 5, notRequired, patch"

    "Objects_CrushBarriers_GasLineGround, 0.8*[1 1 1], 5, notRequired, patch"
    "Objects_CrushBarriers_WaterLineGround, 0.8*[1 1 1], 5, notRequired, patch"
    "Objects_CrushBarriers_ElectricalLineGround, 0.8*[1 1 1], 5, notRequired, patch"
	
    "Stripes, 0.5*[1 1 1], 5, notRequired, path"

    "Stripes_Painted, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteSingleSolid, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteSingleDashed, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteSingleDotted, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteDoubleSolidLeftSide, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteDoubleSolidRightSide, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteDoubleDashedLeftSide, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteDoubleDashedRightSide, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteSolidParkingMarkLeftAndRight, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteSolidParkingMarkLeft, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteSolidParkingMarkRight, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteSolidParkingAisleCap, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteSolidParkingHeadInBoundary, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteZigZag, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteSolidHorizontal, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteDashedHorizontal, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteStripedLines, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteSpeedBumpMarking, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteSpeedHumpMarking, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteBoxJunctionCrissCross, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteTrafficIslandInfill, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteThickChannelizingLine, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteNeutralChevronLine, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteCurb, 0.7*[1 1 1], 5, notRequired, path"
    "Stripes_Painted_WhiteCartCorral, 0.7*[1 1 1], 5, notRequired, path"  
    "Stripes_Painted_YellowSingleSolid, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowSingleDashed, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowSingleDotted, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowDoubleSolidLeftSide, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowDoubleSolidRightSide, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowDoubleDashedLeftSide, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowDoubleDashedRightSide, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowSolidParkingMarkLeftAndRight, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowSolidParkingMarkLeft, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowSolidParkingMarkRight, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowSolidParkingAisleCap, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowSolidParkingHeadInBoundary, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowZigZag, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowSolidHorizontal, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowDashedHorizontal, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowStripedLines, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowSpeedBumpMarking, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowSpeedHumpMarking, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowBoxJunctionCrissCross, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowTrafficIslandInfill, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowCurb, [1 1 0], 5, notRequired, path"
    "Stripes_Painted_YellowCartCorral, [1 1 0], 5, notRequired, path"


    "Stripes_Painted_BlueSingleSolid, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueSingleDashed, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueSingleDotted, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueDoubleSolidLeftSide, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueDoubleSolidRightSide, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueDoubleDashedLeftSide, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueDoubleDashedRightSide, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueSolidParkingMarkLeftAndRight, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueSolidParkingMarkLeft, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueSolidParkingMarkRight, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueSolidParkingAisleCap, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueSolidParkingHeadInBoundary, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueZigZag, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueSolidHorizontal, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueDashedHorizontal, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueStripedLines, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueSpeedBumpMarking, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueSpeedHumpMarking, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueBoxJunctionCrissCross, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueTrafficIslandInfill, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueCurb, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueCartCorral, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueNoParking, [0 0 1], 5, notRequired, path"
    "Stripes_Painted_BlueHandicappedParking, [0 0 1], 5, notRequired, path"

    "Stripes_Painted_GreenSingleSolid, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenSingleDashed, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenSingleDotted, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenDoubleSolidLeftSide, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenDoubleSolidRightSide, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenDoubleDashedLeftSide, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenDoubleDashedRightSide, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenSolidParkingMarkLeftAndRight, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenSolidParkingMarkLeft, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenSolidParkingMarkRight, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenSolidParkingAisleCap, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenSolidParkingHeadInBoundary, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenZigZag, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenSolidHorizontal, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenDashedHorizontal, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenStripedLines, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenSpeedBumpMarking, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenSpeedHumpMarking, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenBoxJunctionCrissCross, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenTrafficIslandInfill, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenCurb, [0 1 0], 5, notRequired, path"
    "Stripes_Painted_GreenCartCorral, [0 1 0], 5, notRequired, path"

    "Stripes_Painted_RedSingleSolid, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedSingleDashed, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedSingleDotted, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedDoubleSolidLeftSide, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedDoubleSolidRightSide, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedDoubleDashedLeftSide, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedDoubleDashedRightSide, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedSolidParkingMarkLeftAndRight, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedSolidParkingMarkLeft, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedSolidParkingMarkRight, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedSolidParkingAisleCap, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedSolidParkingHeadInBoundary, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedZigZag, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedSolidHorizontal, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedDashedHorizontal, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedStripedLines, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedSpeedBumpMarking, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedSpeedHumpMarking, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedBoxJunctionCrissCross, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedTrafficIslandInfill, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedCurb, [1 0 0], 5, notRequired, path"
    "Stripes_Painted_RedCartCorral, [1 0 0], 5, notRequired, path"
	
	"Stripes_Implied, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_SingleSolid, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_SingleDashed, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_SingleDotted, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_DoubleSolidLeftSide, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_DoubleSolidRightSide, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_DoubleDashedLeftSide, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_DoubleDashedRightSide, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_SolidParkingMarkLeftAndRight, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_SolidParkingMarkLeft, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_SolidParkingMarkRight, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_SolidParkingAisleCap, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_SolidParkingHeadInBoundary, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_ZigZag, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_SolidHorizontal, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_DashedHorizontal, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_StripedLines, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_SpeedBumpMarking, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_SpeedHumpMarking, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_BoxJunctionCrissCross, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_TrafficIslandInfill, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_Curb, 0.5*[1 1 1], 5, notRequired, path"
    "Stripes_Implied_CartCorral, 0.5*[1 1 1], 5, notRequired, path"

 

    "PaintedSymbolsWhite_HorizontalSolidStopLine, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_YieldTriangeSolid, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_YieldTriangeOutline, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_RailRoadXingX, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_RailRoadXingR, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_BicycleIconRidingToRight, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_BicycleIconRidingToLeft, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_PedestrianIconWalkingToRight, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_PedestrianIconWalkingToLeft, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_ArrowRight, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_ArrowLeft, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_ArrowStright, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_ArrowStraightAndRight, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_ArrowStraightAndLeft, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_ArrowLeftAndRight, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_ArrowSTraightAndLeftAndRight, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_ArrowSlantRight, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_ArrowSlantLeft, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_CrossWalkHash, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_DiamondHOV, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_StopLetterS, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_StopLetterT, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_StopLetterO, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_StopLetterP, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_OnlyLetterO, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_OnlyLetterN, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_OnlyLetterL, 0.7*[1 1 1], 5, notRequired, path"
    "PaintedSymbolsWhite_OnlyLetterY, 0.7*[1 1 1], 5, notRequired, path"


    "RoadSurfaceFeatures_Asphault, 0.7*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_Concrete, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_Unpaved, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_SpeedBumps, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_SpeedHumps, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_SpeedHills, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_RaisedPedestrianCrosswalks, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_RaisedEntryKiosks, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_RaisedExitKiosks, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_Dips, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_LargePotholes, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_MetalGratesBarsTransverseToRoad, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_MetalGratesBarsAlignedWithRoad, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_MetalGratesHash, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_StormDrains, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_Manholes, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_RampIntoCurbs, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_RumblestripsShoulder, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_RumblestripsLaneBoundary, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_BridgeSeams, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_RailRoadBars, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_MetalPlates, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_Reflectors, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_Asphault, 0.7*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_Concrete, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_Unpaved, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_SpeedBumps, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_SpeedHumps, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_SpeedHills, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_RaisedPedestrianCrosswalks, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_RaisedEntryKiosks, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_RaisedExitKiosks, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_Dips, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_LargePotholes, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_MetalGratesBarsTransverseToRoad, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_MetalGratesBarsAlignedWithRoad, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_MetalGratesHash, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_StormDrains, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_Manholes, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_RampIntoCurbs, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_RumblestripsShoulder, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_RumblestripsLaneBoundary, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_BridgeSeams, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_RailRoadBars, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_MetalPlates, 0.5*[1 1 1], 5, notRequired, patch"
    "RoadSurfaceFeatures_Reflectors, 0.5*[1 1 1], 5, notRequired, patch"

    "Zones_NoParking, [0 0 1], 5, notRequired, patch"
    "Zones_ParkingRestricted, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_PedistrianCrosswalk, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_HandicappedParking, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_ShortTermParking, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_DrivableBicycleLane, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_NonDrivableBicycleLane, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_DrivableSidewalk, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_NonDrivableSidewalk, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_LoadingAndUnLoading, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_FireLane, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_FireHydrant, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_Driveway, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_GarageEntrance, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_GarageExit, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_CartCorral, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_VegetationCollisionHazard, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_EntryTicketKiosk, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_ExitTicketKiosk, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_EntryGate, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_ExitGate, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_EVChargingParking, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_TrashAcessArea, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_BusStop, 0.5*[1 1 1], 5, notRequired, patch"
    "Zones_BusLane, 0.5*[1 1 1], 5, notRequired, patch"

	"Signs, 0.5*[1 1 1], 5, notRequired, oneSidedSegment"

    "Signs_Parking, 0.5*[1 1 1], 5, notRequired, oneSidedSegment"   
    "Signs_Parking_SpeedLimitsVerR2dash1, 0.5*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Parking_SpeedLimitsTrucksVerR2dash2, 0.5*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Parking_SpeedLimitsNightVerR2dash3, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Parking_SpeedLimitsTowingVerR2dash4, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Parking_SpeedLimitsSchoolVerS5dash1, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Parking_SpeedLimitEndSchoolZoneVerS5dash2, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Parking_SpeedLimitsWorkZone, [1 0.4039 0], 5, notRequired, oneSidedSegment"
    "Signs_Parking_SpeedLimitsReducedSpeedAheadVerR2dash5aOrb, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Parking_SpeedAdvisoryVerW13dash1, [1 1 0], 5, notRequired, oneSidedSegment"
    "Signs_Parking_SpeedLimitsAdvisorysCurveVerW13dash5, [1 1 0], 5, notRequired, oneSidedSegment"
    "Signs_Parking_SpeedLimitsAdvisoryExitRampVerW13dash2OrW13dash3, [1 1 0], 5, notRequired, oneSidedSegment"
    "Signs_Parking_SpeedLimitsMinimumSpeed, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Parking_SpeedLimitsRadarEnforced, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Parking_SpeedLimitsCheckedBy, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Parking_SpeedLimitsCustom, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"	
    "Signs_Parking_StopVerR1dash1, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Parking_StopAllWayVerR1dash3, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Parking_StopMultiWay, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Parking_Stop2Way, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Parking_StopHereForPedestriansVerR1dash5b, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Parking_StopHereForSchoolCrossingVerR1dash5c, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Parking_StopHereForTrailCrossingVerR1dash5e, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Parking_StopSmallInStreetPedestrianOrSchoolCrossingVerR1dash6a, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Parking_LEDFlashingStopVerR1dash1LED, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Parking_StopAheadVerW3dash1, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Parking_StopHereOnRedVerR10dash6, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Parking_StopGateSignRailroad, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Parking_NoTurnOnRedVerR10dash11, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Parking_YieldSmallInStreetPedestrianOrSchoolCrossingVerR1dash6, [1 1 0], 5, notRequired, oneSidedSegment"

	"Signs_Roadway, 0.5*[1 1 1], 5, notRequired, oneSidedSegment"    
    "Signs_Roadway_SpeedLimitsVerR2dash1, 0.5*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_SpeedLimitsTrucksVerR2dash2, 0.5*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_SpeedLimitsNightVerR2dash3, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_SpeedLimitsTowingVerR2dash4, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_SpeedLimitsSchoolVerS5dash1, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_SpeedLimitEndSchoolZoneVerS5dash2, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_SpeedLimitsWorkZone, [1 0.4039 0], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_SpeedLimitsReducedSpeedAheadVerR2dash5aOrb, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_SpeedAdvisoryVerW13dash1, [1 1 0], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_SpeedLimitsAdvisorysCurveVerW13dash5, [1 1 0], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_SpeedLimitsAdvisoryExitRampVerW13dash2OrW13dash3, [1 1 0], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_SpeedLimitsMinimumSpeed, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_SpeedLimitsRadarEnforced, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_SpeedLimitsCheckedBy, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_SpeedLimitsCustom, 0.7*[1 1 1], 5, notRequired, oneSidedSegment"    
    "Signs_Roadway_StopVerR1dash1, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_StopAllWayVerR1dash3, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_StopMultiWay, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_Stop2Way, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_StopHereForPedestriansVerR1dash5b, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_StopHereForSchoolCrossingVerR1dash5c, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_StopHereForTrailCrossingVerR1dash5e, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_StopSmallInStreetPedestrianOrSchoolCrossingVerR1dash6a, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_LEDFlashingStopVerR1dash1LED, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_StopAheadVerW3dash1, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_StopHereOnRedVerR10dash6, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_StopGateSignRailroad, [1 0 0], 5, notRequired, oneSidedSegment"
    "Signs_Roadway_NoTurnOnRedVerR10dash11, [1 0 0], 5, notRequired, oneSidedSegment"    
    "Signs_Roadway_YieldSmallInStreetPedestrianOrSchoolCrossingVerR1dash6, [1 1 0], 5, notRequired, oneSidedSegment"
];

fname = "menu_def.txt";
writelines(txt, fname);

% Create a figure and build menus from the file
figHandle = figure('Name', 'Menu Example');
fcn_plotRoad_plotLL([],[],(figHandle));
set(gca,'MapCenter',[40.793695059681355 -77.864213807810174],'ZoomLevel',20);
	
fcn_HandTrace_createMenusFromFile(fname, figHandle);

% Clean up (optional)
delete(fname)


%% Test cases start here. These are very simple, usually trivial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  _______ ______  _____ _______ _____
% |__   __|  ____|/ ____|__   __/ ____|
%    | |  | |__  | (___    | | | (___
%    | |  |  __|  \___ \   | |  \___ \
%    | |  | |____ ____) |  | |  ____) |
%    |_|  |______|_____/   |_| |_____/
%
%
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=TESTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 2

close all;
fprintf(1,'Figure: 2XXXXXX: TEST mode cases\n');

%% TEST case: This one returns nothing since there is no portion of the path in criteria
figNum = 20001;
titleString = sprintf('TEST case: This one returns nothing since there is no portion of the path in criteria');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

%% Fast Mode Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ______        _     __  __           _        _______        _
% |  ____|      | |   |  \/  |         | |      |__   __|      | |
% | |__ __ _ ___| |_  | \  / | ___   __| | ___     | | ___  ___| |_ ___
% |  __/ _` / __| __| | |\/| |/ _ \ / _` |/ _ \    | |/ _ \/ __| __/ __|
% | | | (_| \__ \ |_  | |  | | (_) | (_| |  __/    | |  __/\__ \ |_\__ \
% |_|  \__,_|___/\__| |_|  |_|\___/ \__,_|\___|    |_|\___||___/\__|___/
%
%
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Fast%20Mode%20Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 8

close all;
fprintf(1,'Figure: 8XXXXXX: FAST mode cases - none because this is a plotting function\n');

% %% Basic example - NO FIGURE
% figNum = 80001;
% fprintf(1,'Figure: %.0f: FAST mode, empty figNum\n',figNum);
% figure(figNum); close(figNum);
%
% dataSetNumber = 9;
%
% % Load some test data
% tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);
%
% start_definition = [10 3 0 0]; % Radius 10, 3 points must pass near [0,0]
% end_definition = [30 3 0 -60]; % Radius 30, 3 points must pass near [0,-60]
% excursion_definition = []; % empty
%
% [cell_array_of_lap_indices, ...
%     cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
%     fcn_Laps_breakDataIntoLapIndices(...
%     tempXYdata,...
%     start_definition,...
%     end_definition,...
%     excursion_definition,...
%     ([]));
%
% % Check variable types
% assert(iscell(cell_array_of_lap_indices));
% assert(iscell(cell_array_of_entry_indices));
% assert(iscell(cell_array_of_exit_indices));
%
% % Check variable sizes
% Nlaps = 3;
% assert(isequal(Nlaps,length(cell_array_of_lap_indices)));
% assert(isequal(Nlaps,length(cell_array_of_entry_indices)));
% assert(isequal(Nlaps,length(cell_array_of_exit_indices)));
%
% % Check variable values
% % Are the laps starting at expected points?
% assert(isequal(2,min(cell_array_of_lap_indices{1})));
% assert(isequal(102,min(cell_array_of_lap_indices{2})));
% assert(isequal(215,min(cell_array_of_lap_indices{3})));
%
% % Are the laps ending at expected points?
% assert(isequal(88,max(cell_array_of_lap_indices{1})));
% assert(isequal(199,max(cell_array_of_lap_indices{2})));
% assert(isequal(293,max(cell_array_of_lap_indices{3})));
%
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
%
%
% %% Basic fast mode - NO FIGURE, FAST MODE
% figNum = 80002;
% fprintf(1,'Figure: %.0f: FAST mode, figNum=-1\n',figNum);
% figure(figNum); close(figNum);
%
% dataSetNumber = 9;
%
% % Load some test data
% tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);
%
% start_definition = [10 3 0 0]; % Radius 10, 3 points must pass near [0,0]
% end_definition = [30 3 0 -60]; % Radius 30, 3 points must pass near [0,-60]
% excursion_definition = []; % empty
%
% [cell_array_of_lap_indices, ...
%     cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
%     fcn_Laps_breakDataIntoLapIndices(...
%     tempXYdata,...
%     start_definition,...
%     end_definition,...
%     excursion_definition,...
%     (-1));
%
% % Check variable types
% assert(iscell(cell_array_of_lap_indices));
% assert(iscell(cell_array_of_entry_indices));
% assert(iscell(cell_array_of_exit_indices));
%
% % Check variable sizes
% Nlaps = 3;
% assert(isequal(Nlaps,length(cell_array_of_lap_indices)));
% assert(isequal(Nlaps,length(cell_array_of_entry_indices)));
% assert(isequal(Nlaps,length(cell_array_of_exit_indices)));
%
% % Check variable values
% % Are the laps starting at expected points?
% assert(isequal(2,min(cell_array_of_lap_indices{1})));
% assert(isequal(102,min(cell_array_of_lap_indices{2})));
% assert(isequal(215,min(cell_array_of_lap_indices{3})));
%
% % Are the laps ending at expected points?
% assert(isequal(88,max(cell_array_of_lap_indices{1})));
% assert(isequal(199,max(cell_array_of_lap_indices{2})));
% assert(isequal(293,max(cell_array_of_lap_indices{3})));
%
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
%
%
% %% Compare speeds of pre-calculation versus post-calculation versus a fast variant
% figNum = 80003;
% fprintf(1,'Figure: %.0f: FAST mode comparisons\n',figNum);
% figure(figNum);
% close(figNum);
%
% dataSetNumber = 9;
%
% % Load some test data
% tempXYdata = fcn_INTERNAL_loadExampleData(dataSetNumber);
%
% start_definition = [10 3 0 0]; % Radius 10, 3 points must pass near [0,0]
% end_definition = [30 3 0 -60]; % Radius 30, 3 points must pass near [0,-60]
% excursion_definition = []; % empty
%
%
% Niterations = 50;
%
% % Do calculation without pre-calculation
% tic;
% for ith_test = 1:Niterations
%     % Call the function
%     [cell_array_of_lap_indices, ...
%         cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
%         fcn_Laps_breakDataIntoLapIndices(...
%         tempXYdata,...
%         start_definition,...
%         end_definition,...
%         excursion_definition,...
%         ([]));
% end
% slow_method = toc;
%
% % Do calculation with pre-calculation, FAST_MODE on
% tic;
% for ith_test = 1:Niterations
%     % Call the function
%     [cell_array_of_lap_indices, ...
%         cell_array_of_entry_indices, cell_array_of_exit_indices] = ...
%         fcn_Laps_breakDataIntoLapIndices(...
%         tempXYdata,...
%         start_definition,...
%         end_definition,...
%         excursion_definition,...
%         (-1));
% end
% fast_method = toc;
%
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
%
% % Plot results as bar chart
% figure(373737);
% clf;
% hold on;
%
% X = categorical({'Normal mode','Fast mode'});
% X = reordercats(X,{'Normal mode','Fast mode'}); % Forces bars to appear in this exact order, not alphabetized
% Y = [slow_method fast_method ]*1000/Niterations;
% bar(X,Y)
% ylabel('Execution time (Milliseconds)')
%
%
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));


%% BUG cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ____  _    _  _____
% |  _ \| |  | |/ ____|
% | |_) | |  | | |  __    ___ __ _ ___  ___  ___
% |  _ <| |  | | | |_ |  / __/ _` / __|/ _ \/ __|
% | |_) | |__| | |__| | | (_| (_| \__ \  __/\__ \
% |____/ \____/ \_____|  \___\__,_|___/\___||___/
%
% See: http://patorjk.com/software/taag/#p=display&v=0&f=Big&t=BUG%20cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All bug case figures start with the number 9

% close all;

%% BUG

%% Fail conditions
if 1==0
	%

end


%% Functions follow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ______                _   _
%  |  ____|              | | (_)
%  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§
