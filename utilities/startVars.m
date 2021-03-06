%% startVars.m - Initialize variables
% This script initializes variables and buses required for the model to
% work.

% Copyright 2013-2018 The MathWorks, Inc.

% Register variables in the workspace before the project is loaded
initVars = who;

% Variants Conditions
asbVariantDefinition;
VSS_COMMAND = 0;       % 0: Signal Editor, 1: Joystick, 2: Pre-saved data, 3: Pre-saved data in a Spreadsheet
VSS_SENSORS = 1;       % 0: Feedthrough, 1: Dynamics
VSS_ENVIRONMENT = 0;   % 0: Constant, 1: Variable
VSS_VISUALIZATION = 3; % 0: Scopes, 1: Send values to workspace, 2: FlightGear, 3: Simulink 3D.
VSS_VEHICLE = 1;       % 0: Linear Airframe, 1: Nonlinear Airframe.
 
% Bus definitions
asbBusDefinitionCommand; 
asbBusDefinitionSensors;
asbBusDefinitionEnvironment;
asbBusDefinitionStates;

% Enum definitions
asbEnumDefinition;

% Sampling rate
Ts= 0.005;   % Flight Control System sample rate
VTs = 40*Ts; % Image processing sampling rate

% Simulation time
TFinal = 120;

% Geometric properties
thrustArm = 0.10795;

% Initial conditions
init.date = [2017 1 1 0 0 0];
init.posLLA = [42.299886 -71.350447 71.3232];
init.posNED = [57 95 -0.046];
init.vb = [0 0 0];
init.euler = [0 0 0];
init.angRates = [0 0 0];

% Initialize States:
States = Simulink.Bus.createMATLABStruct('StatesBus');
States.V_body = init.vb';
States.Omega_body = init.angRates';
States.Euler = init.euler';
States.X_ned = init.posNED';
States.LLA = init.posLLA;
States.DCM_be = angle2dcm(init.euler(3),init.euler(2),init.euler(1));

% Environment
rho = 1.184;
g = 9.81;

% Variables
% Load MAT file with model for persistence
load('modelParrot');
% Obtain vehicle variables
vehicleVars;
% Obtain sensor variables
sensorsVars;
% Obtain controller variables
controllerVars;
% Obtain command variables
commandVars;
% Obtain estimator variables
estimatorVars;
% Obtain visualization variables
visualizationFlightGearVars;

% Simulation Settings
takeOffDuration = 1;
enableLanding = false;
landingAltitude = -0.6;

%% Custom Variables
% Add your variables here:
% myvariable = 0;

% Register variables after the project is loaded and store the variables in
% initVars so they can be cleared later on the project shutdown.
endVars = who;
initVars = setdiff(endVars,initVars);
clear endVars;

DuzzyCorrAGM = readfis("DuzzyCorrAGM.fis")

% Liga o fuzzy e set controlador de altitude
fuzzy_feed = 1;
a_gainP = 0.5;
a_gainD = 0.2;
a_gainI = 0.1;

refAlt = [-2 -3 -3  -1.5 -1.5   -3  -3   -1.5  -1.7 -1.7];
refT   = [0  10 40   57    60  61   74  75  119 120]; 


% posi????o desejada Front(pich)
refPich = [56 54.5 54 54 54.3];
refTPi  = [0  10 15 60 120];


% posi????o desejada Lat(roll)
refRoll = [94 95 99 100 100 100.15];
refTRol = [0 10 30 35  60 120];

%Com o sem ruido no controle de altitude
ligaRuido = 0;
