%==========================================================================
% 2017/01/26: Set paths of local helpers and lib
%==========================================================================
libPath = '../../../LibAcousticSensing/Matlab/'
oriPath = cd(libPath)

LibSetup; % setup paths for the core LibAcousticSensing

cd(oriPath); % go back to the original path

addpath('LocalHelpers');

clear oriPath

javaaddpath('../../../LibAcousticSensing/Matlab/JavaSensingServer');
classpath = javaclasspath;
disp(classpath);



% check if the java class is correctly included
which classpath
